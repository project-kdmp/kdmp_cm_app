import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/lost_child/lost_child_list_request.dart';
import 'package:kdmp_cm_app/data/model/lost_child/lost_child_list_response.dart';
import 'package:kdmp_cm_app/domain/repository/lost_child/lost_child_repository.dart';

class LostChildRepositoryImpl extends LostChildRepository {
  final Dio _dio;

  LostChildRepositoryImpl(this._dio);

  @override
  Future<StateAPI> getLostChildList({required LostChildListRequest lostChildListRequest}) async {
    const api = '/v1/biztotal/cm/cs/listLostChild';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: lostChildListRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        /// [TEMP] 사진 미노출 원인 확인용 로그 - resultList의 실제 키 구조 확인
        final rawResultList = response.data["resultList"];
        if (rawResultList is List && rawResultList.isNotEmpty) {
          debugPrint("lostChild raw keys: ${(rawResultList[0] as Map).keys.toList()}");
          debugPrint("lostChild raw tknphotoFile: ${rawResultList[0]["tknphotoFile"]?.toString().substring(0, rawResultList[0]["tknphotoFile"] != null ? (rawResultList[0]["tknphotoFile"].toString().length > 30 ? 30 : rawResultList[0]["tknphotoFile"].toString().length) : 0)}");
          debugPrint("lostChild raw tknphotolength: ${rawResultList[0]["tknphotolength"]}");
        } else {
          debugPrint("lostChild raw resultList empty or null");
        }

        final lostChildListResponse = LostChildListResponse.fromJson(response.data);
        final StateAPI state = Success(lostChildListResponse);
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
