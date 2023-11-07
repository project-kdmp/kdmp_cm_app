import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/client_info.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/auth/refresh_request.dart';
import 'package:kdmp_cm_app/data/model/auth/refresh_response.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/get_auto_refresh_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_user_data_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_user_data_usecase.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../domain/usecase/secure_storage/jwt/get_jwt_usecase.dart';

class TokenInterceptor extends InterceptorsWrapper {
  final GetJwtUseCase getJwtUseCase;
  final GetAutoRefreshUseCase getAutoRefreshUseCase;
  final GetMbrSqUseCase getMbrSqUseCase;
  final SetUserDataUseCase setUserDataUseCase;
  final DeleteUserDataUseCase deleteUserDataUseCase;

  TokenInterceptor({
    required this.getJwtUseCase,
    required this.getAutoRefreshUseCase,
    required this.getMbrSqUseCase,
    required this.setUserDataUseCase,
    required this.deleteUserDataUseCase,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!options.path.contains("/v1/auth-svr/cmLogin") && !options.path.contains("/v1/biztotal/cm/mbr/newMember") && !options.path.contains("/v1/biztotal/cm/listTerm") && !options.path.contains("/v1/biztotal/cm/getTerm")) {
      final token = await getJwtUseCase.execute();
      options.headers['SCLAuthorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  /// DioException 발생 시 실행됨
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    /// AccessToken 만료 시 RefreshToken 으로 재발급
    if (err.response?.statusCode == 401) {
      final accessToken = await getJwtUseCase.execute();
      final refreshToken = await getAutoRefreshUseCase.execute();
      final mbrSq = await getMbrSqUseCase.execute();

      final Dio dio = Dio();
      // dio.interceptors.clear();

      /// Dio Log Interceptor
      /// 디버그 모드에서만 Dio 인스턴스의 모든 로그를 출력
      if (kDebugMode) {
        dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          compact: true,
        ));
      }
      dio.interceptors.add(
        InterceptorsWrapper(
          onError: (err, handler) async {
            /// 다시 인증 오류가 발생했을 경우 RefreshToken 만료된 상태
            // 기기의 자동 로그인 정보 삭제
            ClientInfo.setClientId = "";
            await deleteUserDataUseCase.logout();

            Fluttertoast.showToast(msg: "로그인이 만료되었습니다.\n다시 로그인해주세요.");

            /// 앱 종료
            SystemNavigator.pop();
          },
        ),
      );

      // 토큰 갱신 API 요청 시 AccessToken(만료), RefreshToken 포함
      dio.options.headers['SCLAuthorization'] = 'Bearer $accessToken';

      // 토큰 갱신 API 요청
      const api = '/v1/auth-svr/refreshToken';
      final url = '${AppConstants.AUTH_API}$api';

      /// Token Refresh
      try {
        final refreshRequest = RefreshRequest(mbrSq: mbrSq, autoRefreshToken: refreshToken);
        final response = await dio.post(
          url,
          data: refreshRequest.toJson(),
          options: Options(contentType: Headers.jsonContentType),
        );
        final refreshResponse = RefreshResponse.fromJson(response.data);
        final jwt = refreshResponse.jwt;
        final autoRefresh = refreshResponse.autoRefresh;

        // 기기에 저장된 AccessToken, RefreshToken 갱신
        await setUserDataUseCase.autoLogin(jwt: jwt, autoRefresh: autoRefresh);

        // AccessToken 만료로 수행하지 못했던 API 요청에 담겼던 AccessToken 갱신
        err.requestOptions.headers['SCLAuthorization'] = 'Bearer $jwt';

        /// 수행하지 못했던 API 요청 복사본 생성
        final clonedRequest = await dio.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          ),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );

        /// API 복사본으로 재요청
        return handler.resolve(clonedRequest);
      } catch (e) {
        return handler.next(err);
      }
    } else if (err.response?.statusCode == 200) {
      final errorMessage = DioExceptions.fromDioError(err).toString();
      Fluttertoast.showToast(msg: errorMessage);
    }
    return super.onError(err, handler);
  }
}
