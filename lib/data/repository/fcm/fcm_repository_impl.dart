import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/url.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
import 'package:kdmp_cm_app/data/model/common/default_response.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/fcm/fcm_push_request.dart';
import 'package:kdmp_cm_app/data/model/fcm/fcm_token_request.dart';
import 'package:kdmp_cm_app/domain/repository/fcm/fcm_repository.dart';

class FCMRepositoryImpl extends FCMRepository {
  final Dio _dio;

  FCMRepositoryImpl(this._dio);

  @override
  Future<StateAPI> setToken({required FCMTokenRequest fcmTokenRequest}) async {
    const api = '/v1/biztotal/adm/fcm/regFcmToken';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: fcmTokenRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = DefaultResponse.fromJson(response.data);
            final StateAPI state = Success(responseObject);
            debugPrint("state: $state");
            return state;
          }
        default:
          {
            final badResponse = BadResponse.fromJson(response.data);
            final StateAPI state = Bad(badResponse);
            debugPrint("state: $state");
            return state;
          }
      }
    } on DioException catch (e) {
      try {
        if (e.response != null) {
          final badResponse = BadResponse.fromJson(e.response?.data);
          final StateAPI state = Bad(badResponse);
          debugPrint("state: $state");
          return state;
        }
        return Fail(errorMessage: DioExceptions.fromDioError(e).toString());
      } catch (e2) {
        return Fail(errorMessage: DioExceptions.fromDioError(e).toString());
      }
    }
  }

  @override
  Future<StateAPI> sendPush({required FCMPushRequest fcmPushRequest}) async {
    const api = '/v1/biztotal/adm/fcm/fcmPushMbrSq';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: fcmPushRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = DefaultResponse.fromJson(response.data);
            final StateAPI state = Success(responseObject);
            debugPrint("state: $state");
            return state;
          }
        default:
          {
            final badResponse = BadResponse.fromJson(response.data);
            final StateAPI state = Bad(badResponse);
            debugPrint("state: $state");
            return state;
          }
      }
    } on DioException catch (e) {
      try {
        if (e.response != null) {
          final badResponse = BadResponse.fromJson(e.response?.data);
          final StateAPI state = Bad(badResponse);
          debugPrint("state: $state");
          return state;
        }
        return Fail(errorMessage: DioExceptions.fromDioError(e).toString());
      } catch (e2) {
        return Fail(errorMessage: DioExceptions.fromDioError(e).toString());
      }
    }
  }
}
