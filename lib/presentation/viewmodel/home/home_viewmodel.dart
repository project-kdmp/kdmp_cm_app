import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/data/model/naver/directions_request.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_price_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class HomeViewModel {
  HomeViewModel({
    required this.getMbrSqUseCase,
    required this.getNaverPriceUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetNaverPriceUseCase getNaverPriceUseCase;

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
  final ValueNotifier<List<StopOver>> _stopoverList = ValueNotifier<List<StopOver>>(List.empty());

  ValueNotifier<List<StopOver>> get stopoverListNotifier => _stopoverList;

  List<StopOver> get stopoverList => _stopoverList.value;

  set stopoverList(List<StopOver> value) {
    _stopoverList.value = value;
    getCallPrice();
  }

  addStopoverList(StopOver item) {
    List<StopOver> copyList = List.from(stopoverList);
    copyList.add(item);
    stopoverList = copyList;
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
  final ValueNotifier<bool> _isStopoverButtonValid = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isStopoverButtonValidNotifier => _isStopoverButtonValid;

  bool get isStopoverButtonValid => _isStopoverButtonValid.value;

  set isStopoverButtonValid(bool value) => _isStopoverButtonValid.value = value;

  _checkStopoverButtonValid() {
    bool valid;
    debugPrint("경유지 버튼 ${startMapData != null} ${endMapData != null} ${stopoverList.isEmpty}");
    if (startMapData != null && endMapData != null && stopoverList.isEmpty) {
      valid = true;
    } else {
      valid = false;
    }
    isStopoverButtonValid = valid;
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

  /// 결제수단
  final ValueNotifier<String> _paymKind = ValueNotifier<String>("");

  ValueNotifier<String> get paymKindNotifier => _paymKind;

  String get paymKind => _paymKind.value;

  set paymKind(String value) {
    _paymKind.value = value;
    _checkCallButtonValid();
  }

  /// 예약하기, 호출하기 버튼 활성화 여부
  final ValueNotifier<bool> _isCallButtonValid = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isCallButtonValidNotifier => _isCallButtonValid;

  bool get isCallButtonValid => _isCallButtonValid.value;

  set isCallButtonValid(bool value) => _isCallButtonValid.value = value;

  _checkCallButtonValid() {
    bool valid;
    if (startMapData != null && endMapData != null && paymKind.isNotEmpty && basicPrice != 0) {
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

  /// 상태
  StateAPI state = Loading();

  /// 요금 조회
  getCallPrice() async {
    if (startMapData == null || endMapData == null) {
      return;
    }

    final result = await _getCallPrice();
    if (result is Success) {
      final response = result.directionsResponse;
      basicPrice = response.route.traoptimal[0].summary.taxiFare + response.route.traoptimal[0].summary.tollFare; // 택시 요금 + 통행 요금(톨게이트)
    }
    _checkStopoverButtonValid();
    _checkCallButtonValid();
  }

  /// 요금 조회 API
  Future<StateAPI> _getCallPrice() async {
    state = Loading();

    final start = "${startMapData!.latLng.longitude},${startMapData!.latLng.latitude}";
    final goal = "${endMapData!.latLng.longitude},${endMapData!.latLng.latitude}";
    String waypoints = "";
    for (int i = 0; i < stopoverList.length; i++) {
      waypoints += "${stopoverList[i].long},${stopoverList[i].lat}";
      if (i < stopoverList.length - 1) waypoints += "|";
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
  Future<StateAPI> requestCall() async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    // final request = CallRequest(
    //   mbrCmSq: mbrSq,
    //   paymKind: paymKind,
    //   carNumId: carNumId,
    //   drvReqNm: drvReqNm,
    //   drvReqSt: drvReqSt,
    //   reqRegDt: reqRegDt,
    //   drvReserveDt: drvReserveDt,
    //   drvEndDt: drvEndDt,
    //   drvStartDt: drvStartDt,
    //   reqStartAddress: reqStartAddress,
    //   reqStartPlaceNm: reqStartPlaceNm,
    //   reqEndAddress: reqEndAddress,
    //   reqEndPlaceNm: reqEndPlaceNm,
    //   stopOverLst: stopOverLst,
    //   drvPaymPrice: drvPaymPrice,
    //   drvDistance: drvDistance,
    //   reqAsk: reqAsk,
    //   gpsStartLat: gpsStartLat,
    //   gpsStartLong: gpsStartLong,
    //   gpsEndLat: gpsEndLat,
    //   gpsEndLong: gpsEndLong,
    // );
    // final result = await setCallRequestUseCase.execute(callRequestUseCase: request);
    // state = result;
    //
    // return result;
    return Fail(); // TODO: 임시값
  }

  // TODO: 예약콜 호출하기 API
  Future<StateAPI> requestReservation() async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    // final request = CallRequest(
    //   mbrCmSq: mbrSq,
    //   paymKind: paymKind,
    //   carNumId: carNumId,
    //   drvReqNm: drvReqNm,
    //   drvReqSt: drvReqSt,
    //   reqRegDt: reqRegDt,
    //   drvReserveDt: drvReserveDt,
    //   drvEndDt: drvEndDt,
    //   drvStartDt: drvStartDt,
    //   reqStartAddress: reqStartAddress,
    //   reqStartPlaceNm: reqStartPlaceNm,
    //   reqEndAddress: reqEndAddress,
    //   reqEndPlaceNm: reqEndPlaceNm,
    //   stopOverLst: stopOverLst,
    //   drvPaymPrice: drvPaymPrice,
    //   drvDistance: drvDistance,
    //   reqAsk: reqAsk,
    //   gpsStartLat: gpsStartLat,
    //   gpsStartLong: gpsStartLong,
    //   gpsEndLat: gpsEndLat,
    //   gpsEndLong: gpsEndLong,
    // );
    // final result = await setReservationRequestUseCase.execute(reservationRequestUseCase: request);
    // state = result;
    //
    // return result;
    return Fail(); // TODO: 임시값
  }
}

enum PriceType {
  basic,
  input,
}
