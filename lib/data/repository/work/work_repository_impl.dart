import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/url.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
import 'package:kdmp_cm_app/data/model/common/default_response.dart';
import 'package:kdmp_cm_app/data/model/common/drv_request.dart';
import 'package:kdmp_cm_app/data/model/common/drv_response.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/call_cancel_request.dart';
import 'package:kdmp_cm_app/data/model/work/call_fee_change_request.dart';
import 'package:kdmp_cm_app/data/model/work/call_info_response.dart';
import 'package:kdmp_cm_app/data/model/work/call_request.dart';
import 'package:kdmp_cm_app/data/model/work/confirm_call_cancel_request.dart';
import 'package:kdmp_cm_app/data/model/work/pay_request.dart';
import 'package:kdmp_cm_app/data/model/work/reservation_info_response.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class WorkRepositoryImpl extends WorkRepository {
  final Dio _dio;

  WorkRepositoryImpl(this._dio);

  @override
  Future<StateAPI> cancelCall({required CallCancelRequest callCancelRequest}) async {
    const api = '/v1/biztotal/cm/drv/cancelCall';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: callCancelRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = DrvResponse.fromJson(response.data);
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
  Future<StateAPI> cancelConfirmCall({required ConfirmCallCancelRequest confirmCallCancelRequest}) async {
    const api = '/v1/biztotal/cm/drv/cancelConfirmCall';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: confirmCallCancelRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = DrvResponse.fromJson(response.data);
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
  Future<StateAPI> setPay({required PayRequest payRequest}) async {
    const api = '/v1/biztotal/cm/drv/donePaym';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: payRequest.toJson(),
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

  @override
  Future<StateAPI> getCallInfo({required DrvRequest getCallInfoRequest}) async {
    const api = '/v1/biztotal/cm/drv/getCallInfo';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: getCallInfoRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = CallInfoResponse.fromJson(response.data);
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
  Future<StateAPI> getReservationInfo({required DrvRequest getReservationInfoRequest}) async {
    const api = '/v1/biztotal/cm/drv/listResvCall';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: getReservationInfoRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = ReservationInfoResponse.fromJson(response.data);
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
  Future<StateAPI> requestCall({required CallRequest callRequest}) async {
    const api = '/v1/biztotal/cm/drv/requestCall';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: callRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = DrvResponse.fromJson(response.data);
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
  Future<StateAPI> requestReservation({required CallRequest reservationRequest}) async {
    const api = '/v1/biztotal/cm/drv/requestResvCall';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: reservationRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = DrvResponse.fromJson(response.data);
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
  Future<StateAPI> changeCallFee({required CallFeeChangeRequest callFeeChangeRequest}) async {
    const api = '/v1/biztotal/cm/drv/setCallFee';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: callFeeChangeRequest.toJson(),
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
