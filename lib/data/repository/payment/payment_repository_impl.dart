import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/url.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/payment/toss_billingkey_request.dart';
import 'package:kdmp_cm_app/data/model/payment/toss_billingkey_response.dart';
import 'package:kdmp_cm_app/domain/repository/payment/payment_repository.dart';

class PaymentRepositoryImpl extends PaymentRepository {
  final Dio _dio;

  PaymentRepositoryImpl(this._dio);

  @override
  Future<StateAPI> setTossBillingKey({required TossBillingKeyRequest tossBillingKeyRequest}) async {
    const api = '/v1/biztotal/cm/drv/genTossBillingKey';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: tossBillingKeyRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      switch (response.statusCode) {
        case 200:
          {
            final responseObject = TossBillingKeyResponse.fromJson(response.data);
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
