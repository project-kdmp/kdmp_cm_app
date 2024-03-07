import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/juso/juso_list_request.dart';
import 'package:kdmp_cm_app/data/model/juso/juso_list_response.dart';
import 'package:kdmp_cm_app/domain/repository/juso/juso_repository.dart';

class JusoRepositoryImpl extends JusoRepository {
  final Dio _dio;

  JusoRepositoryImpl(this._dio);

  @override
  Future<StateAPI> getJusoList({required JusoListRequest jusoListRequest}) async {
    final url = AppConstants.KAKAO_JUSO_API;

    try {
      final response = await _dio.get(
        url,
        queryParameters: jusoListRequest.toJson(),
        options: Options(
          contentType: "application/json;charset=UTF-8",
          headers: {"Authorization": "KakaoAK ${jusoListRequest.confmKey}"},
        ),
      );
      final responseObject = JusoListResponse.fromJson(response.data);
      if (response.statusCode == 200) {
        final StateAPI state = Success(responseObject);
        debugPrint("state: $state");
        return state;
      } else if (response.statusCode == 429) {
        // 쿼터 초과(Daum 검색, 로컬, 모먼트, 키워드광고 API에만 해당)
        // 정해진 사용량이나 초당 요청 한도를 초과한 경우
        Fluttertoast.showToast(msg: "요청 한도를 초과했습니다.");
        return Fail();
      } else {
        return Fail();
      }
    } catch (e) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }
}
