import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_mapdata_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mapdata_list_usecase.dart';

class RecentSearchViewModel {
  RecentSearchViewModel({
    required this.getMapDataListUseCase,
    required this.deleteMapDataUseCase,
  });

  final GetMapDataListUseCase getMapDataListUseCase;
  final DeleteMapDataUseCase deleteMapDataUseCase;

  /// 전체 선택
  final ValueNotifier<bool> _isAllCheck = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isAllCheckNotifier => _isAllCheck;

  bool get isAllCheck => _isAllCheck.value;

  /// 체크 리스트
  final ValueNotifier<List<bool>> _checkList = ValueNotifier<List<bool>>(List.empty());

  ValueNotifier<List<bool>> get checkListNotifier => _checkList;

  List<bool> get checkList => _checkList.value;

  set checkList(List<bool> value) {
    _checkList.value = value;
    checkAllCheck();
    _checkIsValid();
  }

  _setAllCheck({required bool value}) {
    _isAllCheck.value = value;
  }

  checkAllCheck() {
    var valid = true;
    for (var item in checkList) {
      if (!item) valid = false;
    }
    _setAllCheck(value: valid);
  }

  setCheckToIndex({required int index, required bool isChecked}) {
    var newCheckList = List<bool>.from([]);
    newCheckList.addAll(checkList);
    newCheckList[index] = isChecked;
    checkList = newCheckList;
  }

  setCheckToAll({required bool isCheck}) {
    checkList = List<bool>.filled(checkList.length, isCheck);
  }

  /// 최근 검색 리스트
  final ValueNotifier<List<MapData>> _recentList = ValueNotifier<List<MapData>>(List.empty());

  ValueNotifier<List<MapData>> get recentListNotifier => _recentList;

  List<MapData> get recentList => _recentList.value;

  set recentList(List<MapData> value) {
    _recentList.value = value;
    checkList = List.filled(value.length, false);
  }

  /// 하단 버튼 활성화 여부
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isValidNotifier => _isValid;

  bool get isValid => _isValid.value;

  _setIsValid({required bool value}) {
    _isValid.value = value;
  }

  _checkIsValid() {
    bool valid = false;
    if (checkList.isNotEmpty) {
      for (int i = 0; i < checkList.length; i++) {
        if (checkList[i]) {
          valid = true;
          break;
        }
      }
    }
    _setIsValid(value: valid);
  }

  /// 최근 검색 장소 리스트 조회
  Future<void> getRecentList() async {
    recentList = await getMapDataListUseCase.execute();
  }

  /// 최근 검색 장소 삭제
  Future<void> deleteRecentMapData() async {
    List<MapData> deleteMapDataList = List.from({});
    for (int i = 0; i < checkList.length; i++) {
      if (checkList[i]) {
        deleteMapDataList.add(recentList[i]);
      }
    }
    await deleteMapDataUseCase.execute(deleteMapDataList: deleteMapDataList);
    await getRecentList();
  }
}
