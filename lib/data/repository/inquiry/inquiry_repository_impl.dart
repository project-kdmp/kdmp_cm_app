import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
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
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: inquiryListRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final responseObject = InquiryListResponse.fromJson(response.data);
        final StateAPI state = Success(responseObject);
        debugPrint("state: $state");
        return state;
      } else {
        final badResponse = BadResponse.fromJson(response.data);
        final StateAPI state = Bad(badResponse);
        if (badResponse.detailMessage.isNotEmpty) {
          Fluttertoast.showToast(msg: badResponse.detailMessage);
        } else {
          Fluttertoast.showToast(msg: "오류가 발생했습니다.");
        }
        debugPrint("state: $state");
        return state;
      }
    } catch (e) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }

  @override
  Future<StateAPI> getInquiryDetail({required InquiryDetailRequest inquiryDetailRequest}) async {
    const api = '/v1/biztotal/cm/cs/getInquiry';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: inquiryDetailRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final responseObject = InquiryDetailResponse.fromJson(response.data);
        final StateAPI state = Success(responseObject);
        debugPrint("state: $state");
        return state;
      } else {
        final badResponse = BadResponse.fromJson(response.data);
        final StateAPI state = Bad(badResponse);
        if (badResponse.detailMessage.isNotEmpty) {
          Fluttertoast.showToast(msg: badResponse.detailMessage);
        } else {
          Fluttertoast.showToast(msg: "오류가 발생했습니다.");
        }
        debugPrint("state: $state");
        return state;
      }
    } catch (e) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }

  @override
  Future<StateAPI> writeInquiry({required InquiryWriteRequest inquiryWriteRequest}) async {
    const api = '/v1/biztotal/cm/cs/regInquiry';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.post(
        url,
        data: inquiryWriteRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final responseObject = InquiryWriteResponse.fromJson(response.data);
        final StateAPI state = Success(responseObject);
        debugPrint("state: $state");
        return state;
      } else {
        final badResponse = BadResponse.fromJson(response.data);
        final StateAPI state = Bad(badResponse);
        if (badResponse.detailMessage.isNotEmpty) {
          Fluttertoast.showToast(msg: badResponse.detailMessage);
        } else {
          Fluttertoast.showToast(msg: "오류가 발생했습니다.");
        }
        debugPrint("state: $state");
        return state;
      }
    } catch (e) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }

  @override
  Future<StateAPI> deleteInquiry({required InquiryDeleteRequest inquiryDeleteRequest}) async {
    const api = '/v1/biztotal/cm/cs/delInquiry';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.post(
        url,
        data: inquiryDeleteRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final responseObject = DefaultResponse.fromJson(response.data);
        final StateAPI state = Success(responseObject);
        debugPrint("state: $state");
        return state;
      } else {
        final badResponse = BadResponse.fromJson(response.data);
        final StateAPI state = Bad(badResponse);
        if (badResponse.detailMessage.isNotEmpty) {
          Fluttertoast.showToast(msg: badResponse.detailMessage);
        } else {
          Fluttertoast.showToast(msg: "오류가 발생했습니다.");
        }
        debugPrint("state: $state");
        return state;
      }
    } catch (e) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }
}
