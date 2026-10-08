import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/driving_request.dart';
import 'package:kdmp_cm_app/data/model/work/now_driving_response.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_call_alias_map_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_call_alias_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_now_driving_list_usecase.dart';

/// 진행 중인 콜 목록(SCR-LIST) 뷰모델.
/// 한 고객이 동시에 진행 중인 콜 전체를 조회해 보여준다.
class CallListViewModel {
  CallListViewModel({
    required this.getMbrSqUseCase,
    required this.getNowDrivingListUseCase,
    required this.getCallAliasMapUseCase,
    required this.setCallAliasUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetNowDrivingListUseCase getNowDrivingListUseCase;
  final GetCallAliasMapUseCase getCallAliasMapUseCase;
  final SetCallAliasUseCase setCallAliasUseCase;

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
