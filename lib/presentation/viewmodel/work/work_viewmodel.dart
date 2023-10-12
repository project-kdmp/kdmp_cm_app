import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/drv_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/data/model/fcm/fcm_push_request.dart';
import 'package:kdmp_cm_app/data/model/work/call_cancel_request.dart';
import 'package:kdmp_cm_app/data/model/work/call_fee_change_request.dart';
import 'package:kdmp_cm_app/data/model/work/confirm_call_cancel_request.dart';
import 'package:kdmp_cm_app/data/model/work/review_write_request.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_push_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_call_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_fee_change_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_confirm_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_review_write_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';

class WorkViewModel {
  WorkViewModel({
    required this.getMbrSqUseCase,
    required this.getCallInfoUseCase,
    required this.setCallCancelUseCase,
    required this.setConfirmCallCancelUseCase,
    required this.setCallFeeChangeUseCase,
    required this.setReviewWriteUseCase,
    required this.setFCMPushUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetCallInfoUseCase getCallInfoUseCase;
  final SetCallCancelUseCase setCallCancelUseCase;
  final SetConfirmCallCancelUseCase setConfirmCallCancelUseCase;
  final SetCallFeeChangeUseCase setCallFeeChangeUseCase;
  final SetReviewWriteUseCase setReviewWriteUseCase;
  final SetFCMPushUseCase setFCMPushUseCase;

  /// 기사명
  final ValueNotifier<String> _name = ValueNotifier<String>("");

  ValueNotifier<String> get nameNotifier => _name;

  String get name => _name.value;

  set name(String value) => _name.value = value;

  /// 프로필 사진
  final ValueNotifier<String> _imagePath = ValueNotifier<String>("");

  ValueNotifier<String> get imagePathNotifier => _imagePath;

  String get imagePath => _imagePath.value;

  set imagePath(String value) => _imagePath.value = value;

  /// 결제수단
  final ValueNotifier<String> _paymKind = ValueNotifier<String>("");

  ValueNotifier<String> get paymKindNotifier => _paymKind;

  String get paymKind => _paymKind.value;

  set paymKind(String value) => _paymKind.value = value;

  /// 요금
  final ValueNotifier<int> _price = ValueNotifier<int>(0);

  ValueNotifier<int> get priceNotifier => _price;

  int get price => _price.value;

  set price(int value) => _price.value = value;

  /// 요청상태
  final ValueNotifier<String> _drvReqSt = ValueNotifier<String>(DrvReqSt.cal);

  ValueNotifier<String> get drvReqStNotifier => _drvReqSt;

  String get drvReqSt => _drvReqSt.value;

  set drvReqSt(String value) {
    _drvReqSt.value = value;
    setCancelVisible = value == DrvReqSt.cal || value == DrvReqSt.cco;
    setPriceInputVisible = value == DrvReqSt.cal || value == DrvReqSt.cco;
  }

  /// 출발지
  final ValueNotifier<String> _start = ValueNotifier<String>("");

  ValueNotifier<String> get startNotifier => _start;

  String get start => _start.value;

  set start(String value) => _start.value = value;

  /// 도착지
  final ValueNotifier<String> _end = ValueNotifier<String>("");

  ValueNotifier<String> get endNotifier => _end;

  String get end => _end.value;

  set end(String value) => _end.value = value;

  /// 일시
  final ValueNotifier<String> _date = ValueNotifier<String>("");

  ValueNotifier<String> get dateNotifier => _date;

  String get date => _date.value;

  set date(String value) => _date.value = value;

  /// 경유지 리스트
  final ValueNotifier<List<StopOver>> _stopOverList = ValueNotifier<List<StopOver>>(List.empty());

  ValueNotifier<List<StopOver>> get stopOverListNotifier => _stopOverList;

  List<StopOver> get stopOverList => _stopOverList.value;

  set stopOverList(List<StopOver> value) => _stopOverList.value = value;

  /// 호출취소 버튼 활성화 여부
  final ValueNotifier<bool> _isCancelVisible = ValueNotifier<bool>(true);

  ValueNotifier<bool> get isCancelVisibleNotifier => _isCancelVisible;

  bool get isCancelVisible => _isCancelVisible.value;

  set setCancelVisible(bool value) => _isCancelVisible.value = value;

  /// 요금변경 버튼 활성화 여부
  final ValueNotifier<bool> _isPriceInputVisible = ValueNotifier<bool>(true);

  ValueNotifier<bool> get isPriceInputVisibleNotifier => _isPriceInputVisible;

  bool get isPriceInputVisible => _isPriceInputVisible.value;

  set setPriceInputVisible(bool value) => _isPriceInputVisible.value = value;

  /// 운행기사 번호
  int _mbrDmSq = 0;

  /// 상태
  StateAPI state = Loading();

  /// 호출정보 조회 API
  Future<StateAPI> getCallInfo({required int drvReqSq}) async {
    state = Loading();

    final request = DrvRequest(drvReqSq: drvReqSq);

    final result = await getCallInfoUseCase.execute(getCallInfoRequest: request);
    state = result;

    if (result is Success) {
      final response = result.callInfoResponse;
      paymKind = response.paymKind;
      price = response.drvPaymPrice;
      drvReqSt = response.drvReqSt;
      start = response.reqStartPlaceNm.isNotEmpty ? response.reqStartPlaceNm : response.reqStartAddress;
      end = response.reqEndPlaceNm.isNotEmpty ? response.reqEndPlaceNm : response.reqEndAddress;
      stopOverList = response.stopOverLst;
      name = response.mbrDmNm ?? "";
      imagePath = response.mbrProfilePic ?? "";
      _mbrDmSq = response.mbrDmSq ?? 0;
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
      await _sendPush(title: StringPush.callTitle, body: StringPush.cancelBody, type: DrvReqSt.del);
    }

    return result;
  }

  /// 호출요금 변경 API
  Future<StateAPI> changeCallFee({required int drvReqSq, required int newPrice}) async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = CallFeeChangeRequest(
      mbrSq: mbrSq,
      drvReqSq: drvReqSq,
      beforPrice: price,
      price: newPrice,
    );

    final result = await setCallFeeChangeUseCase.execute(callFeeChangeRequest: request);
    state = result;

    if (result is Success) {
      price = newPrice;

      await _sendPush(
        title: StringPush.callTitle,
        body: "${StringPush.feeBody1} ${getPrice(newPrice)}${StringPush.feeBody2}",
        type: "fee",
      );
    }

    return result;
  }

  /// 리뷰 작성 API
  Future<StateAPI> writeReview({required int drvReqSq, required String reviewContent, required int starPoint}) async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = ReviewWriteRequest(
      mbrCmSq: mbrSq,
      mbrDmSq: _mbrDmSq,
      drvReqSq: drvReqSq,
      reviewContent: reviewContent,
      starPoint: starPoint,
    );

    final result = await setReviewWriteUseCase.execute(reviewWriteRequest: request);
    state = result;

    if (result is Success) {
      await _sendPush(title: StringPush.callTitle, body: StringPush.reviewBody);
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
