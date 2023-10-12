import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/url.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
import 'package:kdmp_cm_app/data/model/common/default_response.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_delete_response.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_detail_request.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_detail_response.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_list_request.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_list_response.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_write_request.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_write_response.dart';
import 'package:kdmp_cm_app/domain/repository/inquiry/inquiry_repository.dart';

class InquiryRepositoryImpl extends InquiryRepository {
  final Dio _dio;

  InquiryRepositoryImpl(this._dio);

  @override
  Future<StateAPI> getInquiryList({required InquiryListRequest inquiryListRequest}) async {
    const api = '/v1/biztotal/cm/cs/listInquiry';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: inquiryListRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      switch (response.statusCode) {
        case 200:
          {
            final responseObject = InquiryListResponse.fromJson(response.data);
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
  Future<StateAPI> getInquiryDetail({required InquiryDetailRequest inquiryDetailRequest}) async {
    const api = '/v1/biztotal/cm/cs/getInquiry';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: inquiryDetailRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      switch (response.statusCode) {
        case 200:
          {
            final responseObject = InquiryDetailResponse.fromJson(response.data);
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
  Future<StateAPI> writeInquiry({required InquiryWriteRequest inquiryWriteRequest}) async {
    const api = '/v1/biztotal/cm/cs/regInquiry';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: inquiryWriteRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      switch (response.statusCode) {
        case 200:
          {
            final responseObject = InquiryWriteResponse.fromJson(response.data);
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
  Future<StateAPI> deleteInquiry({required InquiryDeleteRequest inquiryDeleteRequest}) async {
    const api = '/v1/biztotal/cm/cs/delInquiry';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: inquiryDeleteRequest.toJson(),
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
