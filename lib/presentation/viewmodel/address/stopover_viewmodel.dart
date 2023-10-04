import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';

class StopOverViewModel {
  /// 경유지 리스트
  final ValueNotifier<List<StopOver>> _stopoverList = ValueNotifier<List<StopOver>>(List.empty());

  ValueNotifier<List<StopOver>> get stopoverListNotifier => _stopoverList;

  List<StopOver> get stopoverList => _stopoverList.value;

  set stopoverList(List<StopOver> value) => _stopoverList.value = value;

  addStopoverList(StopOver item) {
    List<StopOver> copyList = List.from(stopoverList);
    copyList.add(item);
    stopoverList = copyList;
  }

  removeStopoverList(int index) {
    List<StopOver> copyList = List.from(stopoverList);
    copyList.removeAt(index);
    stopoverList = copyList;
  }

  /// 상태
  StateAPI state = Loading();
}
