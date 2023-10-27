import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
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
import 'package:kdmp_cm_app/data/model/work/driving_request.dart';
import 'package:kdmp_cm_app/data/model/work/driving_response.dart';
import 'package:kdmp_cm_app/data/model/work/pay_request.dart';
import 'package:kdmp_cm_app/data/model/work/reservation_info_response.dart';
import 'package:kdmp_cm_app/data/model/work/review_write_request.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class WorkRepositoryImpl extends WorkRepository {
  final Dio _dio;

  WorkRepositoryImpl(this._dio);

  @override
  Future<StateAPI> cancelCall({required CallCancelRequest callCancelRequest}) async {
    const api = '/v1/biztotal/cm/drv/cancelCall';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.post(
        url,
        data: callCancelRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final responseObject = DrvResponse.fromJson(response.data);
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
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    } catch (e) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }

  @override
  Future<StateAPI> cancelConfirmCall({required ConfirmCallCancelRequest confirmCallCancelRequest}) async {
    const api = '/v1/biztotal/cm/drv/cancelConfirmCall';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.post(
        url,
        data: confirmCallCancelRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final responseObject = DrvResponse.fromJson(response.data);
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
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    } catch (e) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }

  @override
  Future<StateAPI> setPay({required PayRequest payRequest}) async {
    const api = '/v1/biztotal/cm/drv/donePaym';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.post(
        url,
        data: payRequest.toJson(),
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
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    } catch (e) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }

  @override
  Future<StateAPI> getCallInfo({required DrvRequest getCallInfoRequest}) async {
    const api = '/v1/biztotal/cm/drv/getCallInfo';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: getCallInfoRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final responseObject = CallInfoResponse.fromJson(response.data);
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
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    } catch (e) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }

  @override
  Future<StateAPI> getReservationInfo({required DrvRequest getReservationInfoRequest}) async {
    const api = '/v1/biztotal/cm/drv/listResvCall';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.post(
        url,
        data: getReservationInfoRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final responseObject = ReservationInfoResponse.fromJson(response.data);
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
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    } catch (e) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }

  @override
  Future<StateAPI> requestCall({required CallRequest callRequest}) async {
    const api = '/v1/biztotal/cm/drv/requestCall';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.post(
        url,
        data: callRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final responseObject = DrvResponse.fromJson(response.data);
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
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    } catch (e) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }

  @override
  Future<StateAPI> requestReservation({required CallRequest reservationRequest}) async {
    const api = '/v1/biztotal/cm/drv/requestResvCall';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.post(
        url,
        data: reservationRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final responseObject = DrvResponse.fromJson(response.data);
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
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    } catch (e) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }

  @override
  Future<StateAPI> changeCallFee({required CallFeeChangeRequest callFeeChangeRequest}) async {
    const api = '/v1/biztotal/cm/drv/setCallFee';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.post(
        url,
        data: callFeeChangeRequest.toJson(),
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
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    } catch (e) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }

  @override
  Future<StateAPI> writeReview({required ReviewWriteRequest reviewWriteRequest}) async {
    const api = '/v1/biztotal/cm/drv/regReviewCall';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.post(
        url,
        data: reviewWriteRequest.toJson(),
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
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    } catch (e) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }

  @override
  Future<StateAPI> getDriving({required DrivingRequest drivingRequest}) async {
    const api = '/v1/biztotal/cm/drv/getNowDriving';
    final url = '${AppConstants.API}$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: drivingRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      /// bizErrCode 없으면 정상 데이터 파싱
      if (!response.data.containsKey("bizErrCode")) {
        final responseObject = DrivingResponse.fromJson(response.data);
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
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    } catch (e) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }
}
