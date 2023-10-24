import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kdmp_cm_app/data/constant/url.dart';
import 'package:kdmp_cm_app/data/model/auth/refresh_request.dart';
import 'package:kdmp_cm_app/data/model/auth/refresh_response.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/get_auto_refresh_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_user_data_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrid_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_user_data_usecase.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../domain/usecase/secure_storage/jwt/get_jwt_usecase.dart';

class TokenInterceptor extends InterceptorsWrapper {
  final Dio dio;
  final GetJwtUseCase getJwtUseCase;
  final GetAutoRefreshUseCase getAutoRefreshUseCase;
  final GetMbrIdUseCase getMbrIdUseCase;
  final SetUserDataUseCase setUserDataUseCase;
  final DeleteUserDataUseCase deleteUserDataUseCase;

  TokenInterceptor({
    required this.dio,
    required this.getJwtUseCase,
    required this.getAutoRefreshUseCase,
    required this.getMbrIdUseCase,
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

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);

    try {
      final badResponse = BadResponse.fromJson(err.response?.data);
      final StateAPI state = Bad(badResponse);
      debugPrint("state: $state");

      /// 인증 오류
      if (badResponse.bizErrCode == 22010) {
        final accessToken = await getJwtUseCase.execute();
        final refreshToken = await getAutoRefreshUseCase.execute();
        final mbrId = await getMbrIdUseCase.execute();

        dio.interceptors.clear();

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
              // 다시 인증 오류가 발생했을 경우: RefreshToken 만료
              // if (err.response?.statusCode == 401) {
              // 기기의 자동 로그인 정보 삭제
              await deleteUserDataUseCase.logout();

              Fluttertoast.showToast(msg: "로그인이 만료되었습니다.\n다시 로그인해주세요.");

              /// 앱 종료
              SystemNavigator.pop();

              return handler.next(err);
            },
          ),
        );

        // 토큰 갱신 API 요청 시 AccessToken(만료), RefreshToken 포함
        dio.options.headers['SCLAuthorization'] = 'Bearer $accessToken';

        // 토큰 갱신 API 요청
        const api = '/v1/auth-svr/refreshToken';
        const url = '$baseUrl$api';

        final refreshRequest = RefreshRequest(mbrId: mbrId, autoRefreshToken: refreshToken);
        final response = await dio.post(
          url,
          data: refreshRequest.toJson(),
          options: Options(contentType: Headers.jsonContentType),
        );
        final refreshResponse = RefreshResponse.fromJson(response.data);
        // response로부터 새로 갱신된 AccessToken과 RefreshToken 파싱
        final jwt = refreshResponse.jwt;
        final autoRefresh = refreshResponse.autoRefresh;

        // 기기에 저장된 AccessToken과 RefreshToken 갱신
        await setUserDataUseCase.autoLogin(jwt: jwt, autoRefresh: autoRefresh);

        // AccessToken의 만료로 수행하지 못했던 API 요청에 담겼던 AccessToken 갱신
        err.requestOptions.headers['SCLAuthorization'] = 'Bearer $jwt';

        // 수행하지 못했던 API 요청 복사본 생성
        final clonedRequest = await dio.request(
          err.requestOptions.path,
          options: Options(method: err.requestOptions.method, headers: err.requestOptions.headers),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );
        // API 복사본으로 재요청
        return handler.resolve(clonedRequest);
      } else if (badResponse.detailMessage.isNotEmpty) {
        Fluttertoast.showToast(msg: badResponse.detailMessage);
      } else {
        Fluttertoast.showToast(msg: "서버 오류가 발생했습니다.\n앱을 다시 실행해주세요.");

        /// 앱 종료
        SystemNavigator.pop();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "서버 오류가 발생했습니다.\n앱을 다시 실행해주세요.");

      /// 앱 종료
      SystemNavigator.pop();
    }
  }
}
