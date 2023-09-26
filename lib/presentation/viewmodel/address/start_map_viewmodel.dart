import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class StartMapViewModel {
  StartMapViewModel({
    required this.getMbrSqUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;

  /// 현위치 좌표
  final ValueNotifier<NLatLng> _latLng = ValueNotifier<NLatLng>(const NLatLng(37.5666103, 126.9783882));

  ValueNotifier<NLatLng> get latLngNotifier => _latLng;

  NLatLng get latLng => _latLng.value;

  set latLng(NLatLng value) => _latLng.value = value;

  /// 출발지 장소명
  final ValueNotifier<String> _startPlace = ValueNotifier<String>("");

  ValueNotifier<String> get startPlaceNotifier => _startPlace;

  String get startPlace => _startPlace.value;

  set startPlace(String value) => _startPlace.value = value;

  /// 출발지 좌표
  final ValueNotifier<NLatLng> _startLatLng = ValueNotifier<NLatLng>(const NLatLng(37.5666103, 126.9783882));

  ValueNotifier<NLatLng> get startLatLngNotifier => _startLatLng;

  NLatLng get startLatLng => _startLatLng.value;

  set startLatLng(NLatLng value) => _startLatLng.value = value;
}
