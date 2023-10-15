import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/drv_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/data/model/fcm/fcm_push_request.dart';
import 'package:kdmp_cm_app/data/model/work/call_cancel_request.dart';
import 'package:kdmp_cm_app/data/model/work/confirm_call_cancel_request.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_push_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_call_detail_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_confirm_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';

class CallDetailViewModel {
  CallDetailViewModel({
    required this.getMbrSqUseCase,
    required this.getCallDetailUseCase,
    required this.setCallCancelUseCase,
    required this.setConfirmCallCancelUseCase,
    required this.setFCMPushUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetCallDetailUseCase getCallDetailUseCase;
  final SetCallCancelUseCase setCallCancelUseCase;
  final SetConfirmCallCancelUseCase setConfirmCallCancelUseCase;
  final SetFCMPushUseCase setFCMPushUseCase;

  /// 운행기사 번호
  int _mbrDmSq = 0;

  /// 일시
  final ValueNotifier<String> _date = ValueNotifier<String>("");

  ValueNotifier<String> get dateNotifier => _date;

  String get date => _date.value;

  set date(String value) => _date.value = value;

  /// 호출유형
  final ValueNotifier<String> _callType = ValueNotifier<String>("");

  ValueNotifier<String> get callTypeNotifier => _callType;

  String get callType => _callType.value;

  set callType(String value) => _callType.value = value;

  /// 상태
  final ValueNotifier<String> _drvReqSt = ValueNotifier<String>("");

  ValueNotifier<String> get drvReqStNotifier => _drvReqSt;

  String get drvReqSt => _drvReqSt.value;

  set drvReqSt(String value) => _drvReqSt.value = value;

  /// 결제수단
  final ValueNotifier<String> _payment = ValueNotifier<String>("");

  ValueNotifier<String> get paymentNotifier => _payment;

  String get payment => _payment.value;

  set payment(String value) => _payment.value = value;

  /// 결제금액
  final ValueNotifier<int> _amount = ValueNotifier<int>(0);

  ValueNotifier<int> get amountNotifier => _amount;

  int get amount => _amount.value;

  set amount(int value) => _amount.value = value;

  /// 출발지 장소명
  final ValueNotifier<String> _startPlace = ValueNotifier<String>("");

  ValueNotifier<String> get startPlaceNotifier => _startPlace;

  String get startPlace => _startPlace.value;

  set startPlace(String value) => _startPlace.value = value;

  /// 경유지 리스트
  final ValueNotifier<List<StopOver>> _stopoverList = ValueNotifier<List<StopOver>>(List.empty());

  ValueNotifier<List<StopOver>> get stopoverListNotifier => _stopoverList;

  List<StopOver> get stopoverList => _stopoverList.value;

  set stopoverList(List<StopOver> value) => _stopoverList.value = value;

  /// 도착지 장소명
  final ValueNotifier<String> _endPlace = ValueNotifier<String>("");

  ValueNotifier<String> get endPlaceNotifier => _endPlace;

  String get endPlace => _endPlace.value;

  set endPlace(String value) => _endPlace.value = value;

  /// 기사이름
  final ValueNotifier<String> _driver = ValueNotifier<String>("");

  ValueNotifier<String> get driverNotifier => _driver;

  String get driver => _driver.value;

  set driver(String value) => _driver.value = value;

  /// 차량
  final ValueNotifier<String> _carNumId = ValueNotifier<String>("");

  ValueNotifier<String> get carNumIdNotifier => _carNumId;

  String get carNumId => _carNumId.value;

  set carNumId(String value) => _carNumId.value = value;

  /// 예약 상태값 체크
  bool isReservation() {
    return drvReqSt == DrvReqSt.res || drvReqSt == DrvReqSt.rco || drvReqSt == DrvReqSt.rwt || drvReqSt == DrvReqSt.rst || drvReqSt == DrvReqSt.rcd || drvReqSt == DrvReqSt.ren || drvReqSt == DrvReqSt.rdl;
  }

  /// 상태
  StateAPI state = Loading();

  /// 미완료 이용 정보 조회 API
  Future<StateAPI> getCallDetail(int drvReqSq) async {
    state = Loading();

    final request = DrvRequest(drvReqSq: drvReqSq);
    final result = await getCallDetailUseCase.execute(callDetailRequest: request);
    state = result;

    if (result is Success) {
      final response = result.callDetailResponse;
      date = getDateAndTimeFormat(startDate: response.drvStartDt, endDate: response.drvEndDt);
      drvReqSt = response.drvReqSt ?? "";
      startPlace = response.reqStartPlaceNm;
      endPlace = response.reqEndPlaceNm;
      stopoverList = response.stopOverLst;
      payment = response.paymKind ?? "";
      amount = response.drvPaymPrice ?? 0;
      driver = response.dmMbrNm ?? "";
      carNumId = response.carNumId ?? "";
      // TODO: 서버에서 mbrDmSq 내려줘야함
      // _mbrDmSq = response.mbrDmSq ?? 0;
    }

    return result;
  }

  /// 미확정 호출취소 API
  Future<StateAPI> cancelCall({required int drvReqSq}) async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = CallCancelRequest(
      mbrCmSq: mbrSq,
      drvReqSq: drvReqSq,
    );

    final result = await setCallCancelUseCase.execute(callCancelRequest: request);
    state = result;

    return result;
  }

  /// 확정 호출취소 API
  Future<StateAPI> cancelConfirmCall({required int drvReqSq, required String drvCancelTp}) async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = ConfirmCallCancelRequest(
      mbrCmSq: mbrSq,
      drvReqSq: drvReqSq,
      drvCancelTp: drvCancelTp,
    );

    final result = await setConfirmCallCancelUseCase.execute(confirmCallCancelRequest: request);
    state = result;

    if (result is Success) {
      await _sendPush(title: StringPush.reservationTitle, body: StringPush.cancelBody, type: DrvReqSt.rdl);
    }

    return result;
  }

  /// 푸시 알림 전송 API
  Future<void> _sendPush({required String title, required String body, String? type}) async {
    if (title.isEmpty || body.isEmpty) {
      return;
    }

    final request = FCMPushRequest(
      mbrSqTarget: _mbrDmSq,
      title: title,
      body: body,
      type: type,
    );
    await setFCMPushUseCase.execute(fcmPushRequest: request);
  }
}
