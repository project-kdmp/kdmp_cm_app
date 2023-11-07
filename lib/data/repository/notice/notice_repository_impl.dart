import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
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
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: noticeListRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final noticeListResponse = NoticeListResponse.fromJson(response.data);
        final StateAPI state = Success(noticeListResponse);
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
  Future<StateAPI> getNoticeDetail({required NoticeDetailRequest noticeDetailRequest}) async {
    const api = '/v1/biztotal/cm/cs/getNotice';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: noticeDetailRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final noticeDetailResponse = NoticeDetailResponse.fromJson(response.data);
        final StateAPI state = Success(noticeDetailResponse);
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
