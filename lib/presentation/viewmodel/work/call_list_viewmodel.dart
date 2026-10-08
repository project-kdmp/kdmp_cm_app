import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/fcm/fcm_push_request.dart';
import 'package:kdmp_cm_app/data/model/work/call_cancel_request.dart';
import 'package:kdmp_cm_app/data/model/work/confirm_call_cancel_request.dart';
import 'package:kdmp_cm_app/data/model/work/driving_request.dart';
import 'package:kdmp_cm_app/data/model/work/now_driving_response.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_push_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_call_alias_map_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_call_alias_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_now_driving_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_confirm_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';

/// 진행 중인 콜 목록(SCR-LIST) 뷰모델.
/// 한 고객이 동시에 진행 중인 콜 전체를 조회해 보여준다.
class CallListViewModel {
  CallListViewModel({
    required this.getMbrSqUseCase,
    required this.getNowDrivingListUseCase,
    required this.getCallAliasMapUseCase,
    required this.setCallAliasUseCase,
    required this.setCallCancelUseCase,
    required this.setConfirmCallCancelUseCase,
    required this.setFCMPushUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetNowDrivingListUseCase getNowDrivingListUseCase;
  final GetCallAliasMapUseCase getCallAliasMapUseCase;
  final SetCallAliasUseCase setCallAliasUseCase;
  final SetCallCancelUseCase setCallCancelUseCase;
  final SetConfirmCallCancelUseCase setConfirmCallCancelUseCase;
  final SetFCMPushUseCase setFCMPushUseCase;

  /// 조회 상태
  final ValueNotifier<StateAPI> _state = ValueNotifier<StateAPI>(Loading());

  ValueNotifier<StateAPI> get stateNotifier => _state;

  StateAPI get state => _state.value;

  set state(StateAPI value) => _state.value = value;

  /// 진행 중인 콜 목록
  final ValueNotifier<List<NowDrivingCall>> _callList =
      ValueNotifier<List<NowDrivingCall>>(List.empty());

  ValueNotifier<List<NowDrivingCall>> get callListNotifier => _callList;

  List<NowDrivingCall> get callList => _callList.value;

  set callList(List<NowDrivingCall> value) => _callList.value = value;

  /// 콜별 사용자 지정 별칭 (키: drvReqSq). 로컬에만 저장한다.
  final ValueNotifier<Map<int, String>> _aliasMap =
      ValueNotifier<Map<int, String>>(const {});

  ValueNotifier<Map<int, String>> get aliasMapNotifier => _aliasMap;

  /// 콜에 보여줄 별칭. 사용자가 지정했으면 그 값, 없으면 도착지 기준 자동 별칭.
  String aliasOf(NowDrivingCall call) {
    final custom = _aliasMap.value[call.drvReqSq];
    if (custom != null && custom.isNotEmpty) return custom;
    return autoAliasOf(call);
  }

  /// 도착지 기준 자동 별칭.
  String autoAliasOf(NowDrivingCall call) {
    if (call.reqEndPlaceNm?.isNotEmpty == true) return call.reqEndPlaceNm!;
    return call.reqEndAddress ?? "도착지";
  }

  /// 진행 중인 콜 목록 조회
  Future<void> getCallList() async {
    state = Loading();

    _aliasMap.value = await getCallAliasMapUseCase.execute();

    final mbrSq = await getMbrSqUseCase.execute();
    final request = DrivingRequest(cmMbrSq: mbrSq);
    final result = await getNowDrivingListUseCase.execute(drivingRequest: request);

    if (result is Success) {
      callList = result.nowDrivingResponse.resultList;
    } else {
      callList = [];
    }
    state = result;
  }

  /// 취소 가능 여부. 호출중(CAL)·배차확정(CCO)만 취소할 수 있다(운행 화면과 동일).
  bool canCancel(NowDrivingCall call) =>
      call.drvReqSt == DrvReqSt.cal || call.drvReqSt == DrvReqSt.cco;

  /// 콜 취소. 미확정(CAL)은 cancelCall, 확정(CCO)은 cancelConfirmCall + 배정 기사에게 취소 푸시.
  /// 운행 화면 _handleCancelPress 와 같은 분기를 쓴다.
  Future<StateAPI> cancelCall({
    required NowDrivingCall call,
    required String drvCancelTp,
    required String cancelReason,
  }) async {
    final mbrSq = await getMbrSqUseCase.execute();

    if (call.drvReqSt == DrvReqSt.cal) {
      return await setCallCancelUseCase.execute(
        callCancelRequest: CallCancelRequest(
          mbrCmSq: mbrSq,
          drvReqSq: call.drvReqSq,
          drvCancelTp: drvCancelTp,
          cancelReason: cancelReason,
        ),
      );
    }

    final result = await setConfirmCallCancelUseCase.execute(
      confirmCallCancelRequest: ConfirmCallCancelRequest(
        mbrCmSq: mbrSq,
        drvReqSq: call.drvReqSq,
        drvCancelTp: drvCancelTp,
        cancelReason: cancelReason,
      ),
    );

    /// 확정 콜 취소는 배정된 기사에게 취소 푸시를 보낸다.
    if (result is Success && call.mbrDmSq != null) {
      await setFCMPushUseCase.execute(
        fcmPushRequest: FCMPushRequest(
          mbrSqTarget: call.mbrDmSq!,
          title: StringPush.callTitle,
          body: StringPush.cancelBody,
          type: DrvReqSt.del,
        ),
      );
    }

    return result;
  }

  /// 콜 한 건의 별칭을 저장한다. 빈 값이면 자동 별칭으로 되돌린다.
  Future<void> saveAlias({required int drvReqSq, required String alias}) async {
    final trimmed = alias.trim();
    await setCallAliasUseCase.execute(drvReqSq: drvReqSq, alias: trimmed);

    /// 알림을 위해 새 맵 인스턴스로 교체한다.
    final next = Map<int, String>.from(_aliasMap.value);
    next[drvReqSq] = trimmed;
    _aliasMap.value = next;
  }
}
