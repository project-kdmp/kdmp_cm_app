import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_add_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_modify_request.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_place_add_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_place_modify_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class ModifyPlaceViewModel {
  ModifyPlaceViewModel({
    required this.getMbrSqUseCase,
    required this.setPlaceAddUseCase,
    required this.setPlaceModifyUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final SetPlaceAddUseCase setPlaceAddUseCase;
  final SetPlaceModifyUseCase setPlaceModifyUseCase;

  /// 장소 별명
  final ValueNotifier<String> _placeNicknm = ValueNotifier<String>("");

  ValueNotifier<String> get placeNicknmNotifier => _placeNicknm;

  String get placeNicknm => _placeNicknm.value;

  set placeNicknm(String value) {
    _placeNicknm.value = value;
    _checkIsValid();
  }

  /// 장소 주소
  final ValueNotifier<String> _placeAddress = ValueNotifier<String>("");

  ValueNotifier<String> get placeAddressNotifier => _placeAddress;

  String get placeAddress => _placeAddress.value;

  set placeAddress(String value) {
    _placeAddress.value = value;
    _checkIsValid();
  }

  /// 장소 데이터 모델
  final ValueNotifier<MapData?> _placeMapData = ValueNotifier<MapData?>(null);

  ValueNotifier<MapData?> get placeMapDataNotifier => _placeMapData;

  MapData? get placeMapData => _placeMapData.value;

  set placeMapData(MapData? value) {
    _placeMapData.value = value;
    placeAddress = value != null ? value.address : "";
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
    bool valid;
    debugPrint("$placeNicknm, $placeMapData");
    if (placeNicknm.isNotEmpty && placeMapData != null && placeMapData!.address.isNotEmpty) {
      valid = true;
    } else {
      valid = false;
    }
    _setIsValid(value: valid);
  }

  /// 상태
  StateAPI state = Loading();

  /// 자주 가는 장소 수정 API
  Future<StateAPI> modifyPlace({required int fplaceSq}) async {
    state = Loading();

    final request = PlaceModifyRequest(
      fplaceSq: fplaceSq,
      fplaceNicknm: placeNicknm,
      fplacePlaceNm: placeMapData!.place,
      fplaceAddress: placeMapData!.address,
      gpsLat: placeMapData!.latLng.latitude,
      gpsLong: placeMapData!.latLng.longitude,
    );
    final result = await setPlaceModifyUseCase.execute(placeModifyRequest: request);
    state = result;

    return result;
  }

  /// 자주 가는 장소 등록 API
  Future<StateAPI> addPlace() async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = PlaceAddRequest(
      mbrSq: mbrSq,
      fplaceNicknm: placeNicknm,
      fplacePlaceNm: placeMapData!.place,
      fplaceAddress: placeMapData!.address,
      gpsLat: placeMapData!.latLng.latitude,
      gpsLong: placeMapData!.latLng.longitude,
    );
    final result = await setPlaceAddUseCase.execute(placeAddRequest: request);
    state = result;

    return result;
  }
}
