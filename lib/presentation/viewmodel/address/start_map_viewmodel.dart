import "package:flutter/cupertino.dart";
import "package:flutter_naver_map/flutter_naver_map.dart";
import "package:kdmp_cm_app/data/model/common/map_data_model.dart";
import "package:kdmp_cm_app/data/model/common/state.dart";
import "package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart";

class StartMapViewModel {
  StartMapViewModel({
    required this.getMbrSqUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;

  /// 장소 데이터
  final ValueNotifier<MapData> _mapData = ValueNotifier<MapData>(
    MapData(
      latLng: const NLatLng(37.5666103, 126.9783882),
      place: "",
      address: "",
    ),
  );

  ValueNotifier<MapData> get mapDataNotifier => _mapData;

  MapData get mapData => _mapData.value;

  set mapData(MapData value) {
    _mapData.value = value;
    _checkIsValid();
  }

  /// 하단 버튼 활성화 여부
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isValidNotifier => _isValid;

  bool get isValid => _isValid.value;

  _setIsValid({required bool value}) {
    _isValid.value = value;
  }

  _checkIsValid() {
    var valid = mapData.address.isNotEmpty;
    _setIsValid(value: valid);
  }

  /// 상태
  StateAPI state = Loading();
}
