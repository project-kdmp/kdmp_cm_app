import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/url.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_detail_request.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_detail_response.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_list_request.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_list_response.dart';
import 'package:kdmp_cm_app/domain/repository/notice/notice_repository.dart';

class NoticeRepositoryImpl extends NoticeRepository {
  final Dio _dio;

  NoticeRepositoryImpl(this._dio);

  @override
  Future<StateAPI> getNoticeList({required NoticeListRequest noticeListRequest}) async {
    const api = '/v1/biztotal/cm/cs/listNotice';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: noticeListRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      switch (response.statusCode) {
        case 200:
          {
            final noticeListResponse = NoticeListResponse.fromJson(response.data);
            final StateAPI state = Success(noticeListResponse);
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
  Future<StateAPI> getNoticeDetail({required NoticeDetailRequest noticeDetailRequest}) async {
    const api = '/v1/biztotal/cm/cs/getNotice';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: noticeDetailRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      switch (response.statusCode) {
        case 200:
          {
            final noticeDetailResponse = NoticeDetailResponse.fromJson(response.data);
            final StateAPI state = Success(noticeDetailResponse);
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
