import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/url.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/register/register_request.dart';
import 'package:kdmp_cm_app/data/model/register/register_response.dart';
import 'package:kdmp_cm_app/domain/repository/register/register_repository.dart';

class RegisterRepositoryImpl extends RegisterRepository {
  final Dio _dio;

  RegisterRepositoryImpl(this._dio);

  @override
  Future<StateAPI> register({required RegisterRequest registerRequest}) async {
    const api = '/v1/biztotal/cm/mbr/newMember';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: registerRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final registerResponse = RegisterResponse.fromJson(response.data);
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
}
