import 'package:kdmp_cm_app/data/model/common/drv_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/call_cancel_request.dart';
import 'package:kdmp_cm_app/data/model/work/call_fee_change_request.dart';
import 'package:kdmp_cm_app/data/model/work/call_request.dart';
import 'package:kdmp_cm_app/data/model/work/confirm_call_cancel_request.dart';
import 'package:kdmp_cm_app/data/model/work/pay_request.dart';

abstract class WorkRepository {
  Future<StateAPI> cancelCall({required CallCancelRequest callCancelRequest});

  Future<StateAPI> cancelConfirmCall({required ConfirmCallCancelRequest confirmCallCancelRequest});

  Future<StateAPI> setPay({required PayRequest payRequest});

  Future<StateAPI> getCallInfo({required DrvRequest getCallInfoRequest});

  Future<StateAPI> getReservationInfo({required DrvRequest getReservationInfoRequest});

  Future<StateAPI> requestCall({required CallRequest callRequest});

  Future<StateAPI> requestReservation({required CallRequest reservationRequest});

  Future<StateAPI> changeCallFee({required CallFeeChangeRequest callFeeChangeRequest});
}
