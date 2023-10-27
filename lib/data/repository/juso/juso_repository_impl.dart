import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/juso/juso_list_request.dart';
import 'package:kdmp_cm_app/data/model/juso/juso_list_response.dart';
import 'package:kdmp_cm_app/domain/repository/juso/juso_repository.dart';

class JusoRepositoryImpl extends JusoRepository {
  final Dio _dio;

  JusoRepositoryImpl(this._dio);

  @override
  Future<StateAPI> getJusoList({required JusoListRequest jusoListRequest}) async {
    final url = AppConstants.JUSO_API;

    try {
      final response = await _dio.get(
        url,
        queryParameters: jusoListRequest.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );
      final responseObject = JusoListResponse.fromJson(response.data);
      if (responseObject.results.common.errorCode == "0") {
        final StateAPI state = Success(responseObject);
        debugPrint("state: $state");
        return state;
      } else {
        return Fail(errorMessage: responseObject.results.common.errorMessage);
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
