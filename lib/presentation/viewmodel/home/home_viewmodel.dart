import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/common/policy_model.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_list_response.dart';
import 'package:kdmp_cm_app/data/model/naver/directions_request.dart';
import 'package:kdmp_cm_app/data/model/policy/policy_request.dart';
import 'package:kdmp_cm_app/data/model/work/call_request.dart';
import 'package:kdmp_cm_app/data/model/work/driving_request.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_car_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_driving_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/policy/get_policy_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_payment_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_driving_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_request_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_reservation_request_usecase.dart';

class HomeViewModel {
  HomeViewModel({
    required this.getMbrSqUseCase,
    required this.getCarListUseCase,
    required this.getNaverDrivingUseCase,
    required this.setCallRequestUseCase,
    required this.setReservationRequestUseCase,
    required this.getDrivingUseCase,
    required this.getPaymentListUseCase,
    required this.getPolicyUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetCarListUseCase getCarListUseCase;
  final GetNaverDrivingUseCase getNaverDrivingUseCase;
  final SetCallRequestUseCase setCallRequestUseCase;
  final SetReservationRequestUseCase setReservationRequestUseCase;
  final GetDrivingUseCase getDrivingUseCase;
  final GetPaymentListUseCase getPaymentListUseCase;
  final GetPolicyUseCase getPolicyUseCase;

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

  clearStopOverList() {
    stopOverList = List.empty();
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
  final ValueNotifier<String> _paymentNm = ValueNotifier<String>("");

  ValueNotifier<String> get paymentNmNotifier => _paymentNm;

  String get paymentNm => _paymentNm.value;

  set paymentNm(String value) {
    _paymentNm.value = value;
  }

  /// 결제 카드 아이디
  final ValueNotifier<String> _cardId = ValueNotifier<String>("");

  ValueNotifier<String> get cardIdNotifier => _cardId;

  String get cardId => _cardId.value;

  set cardId(String value) {
    _cardId.value = value;
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
    debugPrint("=== $paymentNm, $paymKind, $cardId");
    bool valid;
    if (startMapData != null && endMapData != null && paymentNm.isNotEmpty && paymKind.isNotEmpty && basicPrice != 0) {
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
    paymentNm = "";
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

  /// 결제수단 조회
  getPayment() async {
    final paymentList = await getPaymentListUseCase.execute();
    if (paymentList.isNotEmpty) {
      cardId = paymentList[0].cardId;
      paymentNm = paymentList[0].paymentNm;
      paymKind = "CARD";
    } else {
      cardId = "";
      paymentNm = "";
      paymKind = "CASH";
    }
  }

  /// 운행거리 및 요금 조회 API
  getCallPrice() async {
    if (startMapData == null || endMapData == null) {
      return;
    }

    final result = await _getCallPrice();
    if (result is Success) {
      final response = result.directionsResponse;
      basicPrice = response.route!.traoptimal[0].summary.taxiFare + response.route!.traoptimal[0].summary.tollFare; // 택시 요금 + 통행 요금(톨게이트)
      distance = response.route!.traoptimal[0].summary.distance; // 운행거리
    } else {
      basicPrice = 0;
      distance = 0;
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
    final result = await getNaverDrivingUseCase.execute(
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
      tossCardId: cardId,
    );
    final result = await setCallRequestUseCase.execute(callRequest: request);
    state = result;

    return result;
  }

  /// 예약콜 호출하기 API
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
      tossCardId: cardId,
    );
    final result = await setReservationRequestUseCase.execute(reservationRequest: request);
    state = result;

    return result;
  }

  /// 현재 진행중인 콜 여부 조회 API
  Future<int?> getDriving() async {
    final mbrSq = await getMbrSqUseCase.execute();

    final request = DrivingRequest(cmMbrSq: mbrSq);
    final result = await getDrivingUseCase.execute(drivingRequest: request);

    if (result is Success) {
      final response = result.drivingResponse;
      return response.driving ? response.drvReqSq : null;
    }
    return null;
  }

  /// 정책 조회 API
  Future<Policy?> getPolicy({required String policyTp}) async {
    final request = PolicyRequest(policyTp: policyTp);
    final result = await getPolicyUseCase.execute(policyRequest: request);

    if (result is Success) {
      final response = result.policyResponse;
      return Policy(title: response.policyTitle, content: response.policyContent);
    }
    return null;
  }
}

enum PriceType {
  basic,
  input,
}
