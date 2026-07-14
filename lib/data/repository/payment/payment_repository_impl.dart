import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/payment/kgmobil_billingkey_request.dart';
import 'package:kdmp_cm_app/data/model/payment/kgmobil_billingkey_response.dart';
import 'package:kdmp_cm_app/domain/repository/payment/payment_repository.dart';

class PaymentRepositoryImpl extends PaymentRepository {
  final Dio _dio;

  PaymentRepositoryImpl(this._dio);

  @override
  Future<StateAPI> setKGMobilBillingKey({required KGMobilBillingKeyRequest kgMobilBillingKeyRequest}) async {
    const api = '/v1/biztotal/cm/drv/genKGMobiBillingKey';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.post(
        url,
        data: kgMobilBillingKeyRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final responseObject = KGMobilBillingKeyResponse.fromJson(response.data);
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
    } catch (e, stackTrace) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      debugPrint("[$runtimeType] error: $e\n$stackTrace");
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }
}
