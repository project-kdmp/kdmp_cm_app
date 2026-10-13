import 'dart:convert';

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

  /// 공지 본문에 박힌 이미지를 받아 data URI 로 돌려준다. 실패하면 null.
  ///
  /// 본문은 웹뷰로 그리는데, 이미지 경로(`/datafile/...`)는 **인증을 요구한다.**
  /// 웹뷰는 앱의 토큰을 붙이지 않아 그대로 두면 거절당해 빈 칸이 된다. 그래서 토큰이
  /// 붙는 Dio 로 미리 받아 본문에 심는다.
  @override
  Future<String?> getNoticeImageDataUri({required String path}) async {
    /// 서버가 주는 경로에는 /v1/biztotal 접두가 없다. 다른 화면들이 IMAGE_URL 과
    /// 붙여 쓰는 것과 같은 규칙이다.
    final url = '${AppConstants.IMAGE_URL}$path';

    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = response.data;

      if (bytes == null || bytes.isEmpty) {
        return null;
      }

      final mime = response.headers.value(Headers.contentTypeHeader) ?? 'image/png';

      return 'data:$mime;base64,${base64Encode(bytes)}';
    } catch (e) {
      /// 이미지 하나를 못 받아도 공지 본문은 보여야 한다. 토스트를 띄우지 않는다.
      debugPrint('[$runtimeType] 공지 이미지 실패: $path $e');
      return null;
    }
  }

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
    } catch (e, stackTrace) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      debugPrint("[$runtimeType] error: $e\n$stackTrace");
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
    } catch (e, stackTrace) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      debugPrint("[$runtimeType] error: $e\n$stackTrace");
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }
}
