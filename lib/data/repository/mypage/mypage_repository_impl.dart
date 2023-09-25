import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/url.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/default_response.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_info_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/profile_detail_response.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class MyPageRepositoryImpl extends MyPageRepository {
  final Dio _dio;

  MyPageRepositoryImpl(this._dio);

  @override
  Future<StateAPI> getProfileDetail({required DefaultRequest getProfileRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/getMyInfo';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: getProfileRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      switch (response.statusCode) {
        case 200:
          {
            final profileDetailResponse = ProfileDetailResponse.fromJson(response.data);
            final StateAPI state = Success(profileDetailResponse);
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
  Future<StateAPI> addCar({required CarInfoRequest carInfoRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/regMycar';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: carInfoRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final registerResponse = DefaultResponse.fromJson(response.data);
            final StateAPI state = Success(registerResponse);
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
  Future<StateAPI> withdrawalMember({required DefaultRequest withdrawalMemberRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/cancelMbr';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: withdrawalMemberRequest.toJson(),
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
