import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/register/register_request.dart';
import 'package:kdmp_cm_app/data/model/register/register_response.dart';
import 'package:kdmp_cm_app/data/model/register/service_stop_request.dart';
import 'package:kdmp_cm_app/data/model/register/service_stop_response.dart';
import 'package:kdmp_cm_app/domain/repository/register/register_repository.dart';

class RegisterRepositoryImpl extends RegisterRepository {
  final Dio _dio;

  RegisterRepositoryImpl(this._dio);

  @override
  Future<StateAPI> register({required RegisterRequest registerRequest}) async {
    const api = '/v1/biztotal/cm/mbr/newMember';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.post(
        url,
        data: registerRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final registerResponse = RegisterResponse.fromJson(response.data);
        final StateAPI state = Success(registerResponse);
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
  Future<StateAPI> getServiceStop({required ServiceStopRequest serviceStopRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/getServiceStopReason';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: serviceStopRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final registerResponse = ServiceStopResponse.fromJson(response.data);
        final StateAPI state = Success(registerResponse);
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
