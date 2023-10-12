import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_list_response.dart';
import 'package:kdmp_cm_app/data/model/naver/directions_request.dart';
import 'package:kdmp_cm_app/data/model/work/call_request.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_car_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_price_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_request_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_reservation_request_usecase.dart';

class HomeViewModel {
  HomeViewModel({
    required this.getMbrSqUseCase,
    required this.getCarListUseCase,
    required this.getNaverPriceUseCase,
    required this.setCallRequestUseCase,
    required this.setReservationRequestUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetCarListUseCase getCarListUseCase;
  final GetNaverPriceUseCase getNaverPriceUseCase;
  final SetCallRequestUseCase setCallRequestUseCase;
  final SetReservationRequestUseCase setReservationRequestUseCase;

  String clientId = "";
  String clientSecret = "";

  /// 현위치 좌표
  final ValueNotifier<NLatLng> _currentLatLng = ValueNotifier<NLatLng>(const NLatLng(37.5666103, 126.9783882));

  ValueNotifier<NLatLng> get currentLatLngNotifier => _currentLatLng;

  NLatLng get currentLatLng => _currentLatLng.value;

  set currentLatLng(NLatLng value) => _currentLatLng.value = value;

  /// 출발지 데이터 모델
  final ValueNotifier<MapData?> _startMapData = ValueNotifier<MapData?>(null);

  ValueNotifier<MapData?> get startMapDataNotifier => _startMapData;

  MapData? get startMapData => _startMapData.value;

  set startMapData(MapData? value) {
    _startMapData.value = value;
    getCallPrice();
  }

  /// 경유지 리스트
  final ValueNotifier<List<StopOver>> _stopOverList = ValueNotifier<List<StopOver>>(List.empty());

  ValueNotifier<List<StopOver>> get stopOverListNotifier => _stopOverList;

  List<StopOver> get stopOverList => _stopOverList.value;

  set stopOverList(List<StopOver> value) {
    _stopOverList.value = value;
    getCallPrice();
  }

  addStopOverList(StopOver item) {
    List<StopOver> copyList = List.from(stopOverList);
    copyList.add(item);
    stopOverList = copyList;
  }

  /// 도착지 데이터 모델
  final ValueNotifier<MapData?> _endMapData = ValueNotifier<MapData?>(null);

  ValueNotifier<MapData?> get endMapDataNotifier => _endMapData;

  MapData? get endMapData => _endMapData.value;

  set endMapData(MapData? value) {
    _endMapData.value = value;
    getCallPrice();
  }

  /// 도착지 검색 내 경유 버튼 활성화 여부
  final ValueNotifier<bool> _isStopOverButtonValid = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isStopOverButtonValidNotifier => _isStopOverButtonValid;

  bool get isStopOverButtonValid => _isStopOverButtonValid.value;

  set isStopOverButtonValid(bool value) => _isStopOverButtonValid.value = value;

  _checkStopOverButtonValid() {
    bool valid;
    debugPrint("경유지 버튼 ${startMapData != null} ${endMapData != null} ${stopOverList.isEmpty}");
    if (startMapData != null && endMapData != null && stopOverList.isEmpty) {
      valid = true;
    } else {
      valid = false;
    }
    isStopOverButtonValid = valid;
  }

  /// 요금 선택 버튼 활성화 여부
  final ValueNotifier<bool> _isPriceButtonValid = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isPriceButtonValidNotifier => _isPriceButtonValid;

  bool get isPriceButtonValid => _isPriceButtonValid.value;

  set isPriceButtonValid(bool value) => _isPriceButtonValid.value = value;

  _checkPriceButtonValid() {
    bool valid;
    if (startMapData != null && endMapData != null && basicPrice != 0) {
      valid = true;
    } else {
      valid = false;
    }
    isPriceButtonValid = valid;
  }

  /// 요금 유형
  final ValueNotifier<PriceType> _priceType = ValueNotifier<PriceType>(PriceType.basic);

  ValueNotifier<PriceType> get priceTypeNotifier => _priceType;

  PriceType get priceType => _priceType.value;

  set priceType(PriceType value) => _priceType.value = value;

  /// 일반요금
  final ValueNotifier<int> _basicPrice = ValueNotifier<int>(0);

  ValueNotifier<int> get basicPriceNotifier => _basicPrice;

  int get basicPrice => _basicPrice.value;

  set basicPrice(int value) {
    _basicPrice.value = value;
    _inputPrice.value = value;
    priceType = PriceType.basic;
    _checkCallButtonValid();
    _checkPriceButtonValid();
  }

  /// 요금 직접 입력
  final ValueNotifier<int> _inputPrice = ValueNotifier<int>(0);

  ValueNotifier<int> get inputPriceNotifier => _inputPrice;

  int get inputPrice => _inputPrice.value;

  set inputPrice(int value) {
    _inputPrice.value = value;
    priceType = PriceType.input;
  }

  /// 일반요금
  int get price => priceType == PriceType.basic ? basicPrice : inputPrice;

  /// 결제수단
  final ValueNotifier<String> _paymKind = ValueNotifier<String>("");

  ValueNotifier<String> get paymKindNotifier => _paymKind;

  String get paymKind => _paymKind.value;

  set paymKind(String value) {
    _paymKind.value = value;
    _checkCallButtonValid();
  }

  /// 결제수단
  final ValueNotifier<String> _payment = ValueNotifier<String>("");

  ValueNotifier<String> get paymentNotifier => _payment;

  String get payment => _payment.value;

  set payment(String value) {
    _payment.value = value;
  }

  /// 운행거리
  final ValueNotifier<int> _distance = ValueNotifier<int>(0);

  ValueNotifier<int> get distanceNotifier => _distance;

  int get distance => _distance.value;

  set distance(int value) => _distance.value = value;

  /// 예약하기, 호출하기 버튼 활성화 여부
  final ValueNotifier<bool> _isCallButtonValid = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isCallButtonValidNotifier => _isCallButtonValid;

  bool get isCallButtonValid => _isCallButtonValid.value;

  set isCallButtonValid(bool value) => _isCallButtonValid.value = value;

  _checkCallButtonValid() {
    bool valid;
    if (startMapData != null && endMapData != null && payment.isNotEmpty && paymKind.isNotEmpty && basicPrice != 0) {
      valid = true;
    } else {
      valid = false;
    }
    isCallButtonValid = valid;
  }

  bool isPriceValid() {
    bool valid;
    if (startMapData != null && endMapData != null) {
      valid = true;
    } else {
      valid = false;
    }
    return valid;
  }

  void clearData() {
    startMapData = null;
    endMapData = null;
    stopOverList = List.empty();
    payment = "";
    paymKind = "";
    distance = 0;
    basicPrice = 0;
    _checkStopOverButtonValid();
  }

  /// 상태
  StateAPI state = Loading();

  /// 차량정보 리스트 조회 API
  Future<List<Car>> getCarList() async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = DefaultRequest(mbrSq: mbrSq);
    final result = await getCarListUseCase.execute(getCarListRequest: request);
    state = result;

    if (result is Success) {
      return result.carListResponse.resultList;
    }

    return List.empty();
  }

  /// 요금 조회
  getCallPrice() async {
    if (startMapData == null || endMapData == null) {
      return;
    }

    final result = await _getCallPrice();
    if (result is Success) {
      final response = result.directionsResponse;
      basicPrice = response.route.traoptimal[0].summary.taxiFare + response.route.traoptimal[0].summary.tollFare; // 택시 요금 + 통행 요금(톨게이트)
      distance = response.route.traoptimal[0].summary.distance; // 운행거리
    }
    _checkStopOverButtonValid();
    _checkCallButtonValid();
  }

  /// 요금 조회 API
  Future<StateAPI> _getCallPrice() async {
    state = Loading();

    final start = "${startMapData!.latLng.longitude},${startMapData!.latLng.latitude}";
    final goal = "${endMapData!.latLng.longitude},${endMapData!.latLng.latitude}";
    String waypoints = "";
    for (int i = 0; i < stopOverList.length; i++) {
      waypoints += "${stopOverList[i].long},${stopOverList[i].lat}";
      if (i < stopOverList.length - 1) waypoints += "|";
    }

    final request = DirectionsRequest(
      start: start,
      goal: goal,
      waypoints: waypoints,
    );
    final result = await getNaverPriceUseCase.execute(
      clientId: clientId,
      clientSecret: clientSecret,
      directionsRequest: request,
    );
    state = result;

    return result;
  }

  // TODO: 콜 호출하기 API
  Future<StateAPI> requestCall({required String carNumId}) async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = CallRequest(
      mbrCmSq: mbrSq,
      paymKind: paymKind,
      carNumId: carNumId,
      drvReqSt: DrvReqSt.cal,
      reqRegDt: DateTime.now().toIso8601String(),
      reqStartAddress: startMapData!.address,
      reqStartPlaceNm: startMapData!.place,
      reqEndAddress: endMapData!.address,
      reqEndPlaceNm: endMapData!.place,
      stopOverLst: stopOverList,
      drvPaymPrice: price,
      drvDistance: distance,
      gpsStartLat: startMapData!.latLng.latitude,
      gpsStartLong: startMapData!.latLng.longitude,
      gpsEndLat: endMapData!.latLng.latitude,
      gpsEndLong: endMapData!.latLng.longitude,
    );
    final result = await setCallRequestUseCase.execute(callRequest: request);
    state = result;

    return result;
  }

  // TODO: 예약콜 호출하기 API
  Future<StateAPI> requestReservation({required String carNumId, required String date}) async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();
    final drvReserveDt = DateTime.parse(date);

    final request = CallRequest(
      mbrCmSq: mbrSq,
      paymKind: paymKind,
      carNumId: carNumId,
      drvReqSt: DrvReqSt.res,
      reqRegDt: DateTime.now().toIso8601String(),
      drvReserveDt: drvReserveDt.toIso8601String(),
      reqStartAddress: startMapData!.address,
      reqStartPlaceNm: startMapData!.place,
      reqEndAddress: endMapData!.address,
      reqEndPlaceNm: endMapData!.place,
      stopOverLst: stopOverList,
      drvPaymPrice: price,
      drvDistance: distance,
      gpsStartLat: startMapData!.latLng.latitude,
      gpsStartLong: startMapData!.latLng.longitude,
      gpsEndLat: endMapData!.latLng.latitude,
      gpsEndLong: endMapData!.latLng.longitude,
    );
    final result = await setReservationRequestUseCase.execute(reservationRequest: request);
    state = result;

    return result;
  }
}

enum PriceType {
  basic,
  input,
}
