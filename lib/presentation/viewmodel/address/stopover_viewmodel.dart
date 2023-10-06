import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';

class StopOverViewModel {
  /// 경유지 리스트
  final ValueNotifier<List<StopOver>> _stopOverList = ValueNotifier<List<StopOver>>(List.empty());

  ValueNotifier<List<StopOver>> get stopOverListNotifier => _stopOverList;

  List<StopOver> get stopOverList => _stopOverList.value;

  set stopOverList(List<StopOver> value) => _stopOverList.value = value;

  addStopOverList(StopOver item) {
    List<StopOver> copyList = List.from(stopOverList);
    copyList.add(item);
    stopOverList = copyList;
  }

  removeStopOverList(int index) {
    List<StopOver> copyList = List.from(stopOverList);
    copyList.removeAt(index);
    stopOverList = copyList;
  }

  /// 상태
  StateAPI state = Loading();
}
