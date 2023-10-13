import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kdmp_cm_app/data/constant/url.dart';
import 'package:kdmp_cm_app/data/model/auth/refresh_request.dart';
import 'package:kdmp_cm_app/data/model/auth/refresh_response.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/get_auto_refresh_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/set_auto_refresh_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/set_jwt_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrid_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrid_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrpw_usecase.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../domain/usecase/secure_storage/jwt/get_jwt_usecase.dart';

class TokenInterceptor extends InterceptorsWrapper {
  final Dio dio;
  final GetJwtUseCase getJwtUseCase;
  final SetJwtUseCase setJwtUseCase;
  final GetAutoRefreshUseCase getAutoRefreshUseCase;
  final SetAutoRefreshUseCase setAutoRefreshUseCase;
  final GetMbrIdUseCase getMbrIdUseCase;
  final SetMbrIdUseCase setMbrIdUseCase;
  final SetMbrPwUseCase setMbrPwUseCase;

  TokenInterceptor({
    required this.dio,
    required this.getJwtUseCase,
    required this.setJwtUseCase,
    required this.getAutoRefreshUseCase,
    required this.setAutoRefreshUseCase,
    required this.getMbrIdUseCase,
    required this.setMbrIdUseCase,
    required this.setMbrPwUseCase,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await getJwtUseCase.execute();
    options.headers['Authorization'] = 'Bearer $token';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint("TokenInterceptor onError");

    /// 인증 오류, AccessToken 만료
    if (err.response?.statusCode == 401) {
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
            await setMbrIdUseCase.execute(mbrId: "");
            await setMbrPwUseCase.execute(mbrPw: "");
            await setJwtUseCase.execute(jwt: "");

            // . . .
            // 로그인 만료 dialog 발생 후 로그인 페이지로 이동
            // . . .
            // }
            return handler.next(err);
          },
        ),
      );

      // 토큰 갱신 API 요청 시 AccessToken(만료), RefreshToken 포함
      dio.options.headers['Authorization'] = 'Bearer $accessToken';

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
      await setJwtUseCase.execute(jwt: jwt);
      await setAutoRefreshUseCase.execute(autoRefresh: autoRefresh);

      // AccessToken의 만료로 수행하지 못했던 API 요청에 담겼던 AccessToken 갱신
      err.requestOptions.headers['Authorization'] = 'Bearer $jwt';

      // 수행하지 못했던 API 요청 복사본 생성
      final clonedRequest = await dio.request(
        err.requestOptions.path,
        options: Options(method: err.requestOptions.method, headers: err.requestOptions.headers),
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
      );
      // API 복사본으로 재요청
      return handler.resolve(clonedRequest);
    } else {
      Fluttertoast.showToast(msg: "인증오류 외 오류 발생");
    }
    super.onError(err, handler);
  }
}
