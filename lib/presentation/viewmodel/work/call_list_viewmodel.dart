import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/driving_request.dart';
import 'package:kdmp_cm_app/data/model/work/now_driving_response.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_now_driving_list_usecase.dart';

/// 진행 중인 콜 목록(SCR-LIST) 뷰모델.
/// 한 고객이 동시에 진행 중인 콜 전체를 조회해 보여준다.
class CallListViewModel {
  CallListViewModel({
    required this.getMbrSqUseCase,
    required this.getNowDrivingListUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetNowDrivingListUseCase getNowDrivingListUseCase;

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

  /// 진행 중인 콜 목록 조회
  Future<void> getCallList() async {
    state = Loading();

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
}
