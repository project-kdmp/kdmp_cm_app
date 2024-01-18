import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/drv_request.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/data/model/fcm/fcm_push_request.dart';
import 'package:kdmp_cm_app/data/model/naver/directions_request.dart';
import 'package:kdmp_cm_app/data/model/naver/geocoding_request.dart';
import 'package:kdmp_cm_app/data/model/work/call_cancel_request.dart';
import 'package:kdmp_cm_app/data/model/work/call_fee_change_request.dart';
import 'package:kdmp_cm_app/data/model/work/call_info_change_request.dart';
import 'package:kdmp_cm_app/data/model/work/confirm_call_cancel_request.dart';
import 'package:kdmp_cm_app/data/model/work/driving_price_request.dart';
import 'package:kdmp_cm_app/data/model/work/review_write_request.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_push_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_address_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_driving_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_call_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_driving_price_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_fee_change_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_info_change_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_confirm_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_review_write_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';

class WorkViewModel {
  WorkViewModel({
    required this.getMbrSqUseCase,
    required this.getCallInfoUseCase,
    required this.setCallCancelUseCase,
    required this.setConfirmCallCancelUseCase,
    required this.setCallFeeChangeUseCase,
    required this.setCallInfoChangeUseCase,
    required this.setReviewWriteUseCase,
    required this.setFCMPushUseCase,
    required this.getDrivingPriceUseCase,
    required this.getNaverDrivingUseCase,
    required this.getNaverAddressInfoUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetCallInfoUseCase getCallInfoUseCase;
  final SetCallCancelUseCase setCallCancelUseCase;
  final SetConfirmCallCancelUseCase setConfirmCallCancelUseCase;
  final SetCallFeeChangeUseCase setCallFeeChangeUseCase;
  final SetCallInfoChangeUseCase setCallInfoChangeUseCase;
  final SetReviewWriteUseCase setReviewWriteUseCase;
  final SetFCMPushUseCase setFCMPushUseCase;
  final GetDrivingPriceUseCase getDrivingPriceUseCase;
  final GetNaverDrivingUseCase getNaverDrivingUseCase;
  final GetNaverAddressInfoUseCase getNaverAddressInfoUseCase;

  String clientId = "";
  String clientSecret = "";

  /// 전화
  final ValueNotifier<String> _callNumber = ValueNotifier<String>("");

  ValueNotifier<String> get callNumberNotifier => _callNumber;

  String get callNumber => _callNumber.value;

  set callNumber(String value) => _callNumber.value = value;

  /// 기사명
  final ValueNotifier<String> _name = ValueNotifier<String>("");

  ValueNotifier<String> get nameNotifier => _name;

  String get name => _name.value;

  set name(String value) => _name.value = value;

  /// 프로필 사진
  final ValueNotifier<String> _imagePath = ValueNotifier<String>("");

  ValueNotifier<String> get imagePathNotifier => _imagePath;

  String get imagePath => _imagePath.value;

  set imagePath(String value) => _imagePath.value = value;

  /// 결제수단
  final ValueNotifier<String> _paymKind = ValueNotifier<String>("");

  ValueNotifier<String> get paymKindNotifier => _paymKind;

  String get paymKind => _paymKind.value;

  set paymKind(String value) => _paymKind.value = value;

  /// 요금
  final ValueNotifier<int> _price = ValueNotifier<int>(0);

  ValueNotifier<int> get priceNotifier => _price;

  int get price => _price.value;

  set price(int value) => _price.value = value;

  /// 요청상태
  final ValueNotifier<String> _drvReqSt = ValueNotifier<String>(DrvReqSt.cal);

  ValueNotifier<String> get drvReqStNotifier => _drvReqSt;

  String get drvReqSt => _drvReqSt.value;

  set drvReqSt(String value) {
    _drvReqSt.value = value;
    setCancelVisible = value == DrvReqSt.cal || value == DrvReqSt.cco;
    setPriceInputVisible = value == DrvReqSt.cal || value == DrvReqSt.cco;
    setCallInfoChangeVisible = value == DrvReqSt.cco || value == DrvReqSt.rco || value == DrvReqSt.wat || value == DrvReqSt.rwt || value == DrvReqSt.rst || value == DrvReqSt.sta;
  }

  /// 출발지
  final ValueNotifier<String> _start = ValueNotifier<String>("");

  ValueNotifier<String> get startNotifier => _start;

  String get start => _start.value;

  set start(String value) => _start.value = value;

  /// 도착지
  final ValueNotifier<String> _end = ValueNotifier<String>("");

  ValueNotifier<String> get endNotifier => _end;

  String get end => _end.value;

  set end(String value) => _end.value = value;

  /// 일시
  final ValueNotifier<String> _date = ValueNotifier<String>("");

  ValueNotifier<String> get dateNotifier => _date;

  String get date => _date.value;

  set date(String value) => _date.value = value;

  /// 경유지 리스트
  final ValueNotifier<List<StopOver>> _stopOverList = ValueNotifier<List<StopOver>>(List.empty());

  ValueNotifier<List<StopOver>> get stopOverListNotifier => _stopOverList;

  List<StopOver> get stopOverList => _stopOverList.value;

  set stopOverList(List<StopOver> value) => _stopOverList.value = value;

  /// 호출취소 버튼 활성화 여부
  final ValueNotifier<bool> _isCancelVisible = ValueNotifier<bool>(true);

  ValueNotifier<bool> get isCancelVisibleNotifier => _isCancelVisible;

  bool get isCancelVisible => _isCancelVisible.value;

  set setCancelVisible(bool value) => _isCancelVisible.value = value;

  /// 요금변경 버튼 활성화 여부
  final ValueNotifier<bool> _isPriceInputVisible = ValueNotifier<bool>(true);

  ValueNotifier<bool> get isPriceInputVisibleNotifier => _isPriceInputVisible;

  bool get isPriceInputVisible => _isPriceInputVisible.value;

  set setPriceInputVisible(bool value) => _isPriceInputVisible.value = value;

  /// 도착지, 경유지 변경 버튼 활성화 여부
  final ValueNotifier<bool> _isCallInfoChangeVisible = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isCallInfoChangeVisibleNotifier => _isCallInfoChangeVisible;

  bool get isCallInfoChangeVisible => _isCallInfoChangeVisible.value;

  set setCallInfoChangeVisible(bool value) => _isCallInfoChangeVisible.value = value;

  /// 운행기사 번호
  int _mbrDmSq = 0;

  /// 상태
  final ValueNotifier<StateAPI> _state = ValueNotifier<StateAPI>(Loading());

  ValueNotifier<StateAPI> get stateNotifier => _state;

  StateAPI get state => _state.value;

  set state(StateAPI value) => _state.value = value;

  /// 호출정보 조회 API
  Future<StateAPI> getCallInfo({required int drvReqSq, bool isSearchMapData = false}) async {
    state = Loading();

    final request = DrvRequest(drvReqSq: drvReqSq);

    final result = await getCallInfoUseCase.execute(getCallInfoRequest: request);

    if (result is Success) {
      final response = result.callInfoResponse;
      paymKind = response.paymKind;
      price = response.drvPaymPrice;
      drvReqSt = response.drvReqSt;
      start = response.reqStartPlaceNm.isNotEmpty ? response.reqStartPlaceNm : response.reqStartAddress;
      end = response.reqEndPlaceNm.isNotEmpty ? response.reqEndPlaceNm : response.reqEndAddress;
      stopOverList = response.stopOverLst;
      name = response.mbrDmNm ?? "";
      imagePath = response.mbrProfilePic ?? "";
      // callNumber = response.drvSafeCall ?? "";
      callNumber = response.dmMbrMobilePhone ?? "";
      _mbrDmSq = response.mbrDmSq ?? 0;

      if (isSearchMapData) {
        startMapData = await getSearchMapData(address: response.reqStartAddress, place: response.reqStartPlaceNm);
        endMapData = await getSearchMapData(address: response.reqEndAddress, place: response.reqEndPlaceNm);

        debugPrint("startMapData json: ${jsonEncode(startMapData)}");
        debugPrint("endMapData json: ${jsonEncode(endMapData)}");
        debugPrint("stopOverList json: ${jsonEncode(stopOverList)}");
      }
    }

    state = result;
    return result;
  }

  /// 장소 정보 검색
  Future<MapData?> getSearchMapData({required String address, required String place}) async {
    /// 검색된 주소로 장소 정보 검색 (도로명)
    final result = await getAddressInfo(address: address);
    if (result is Success) {
      final addressInfo = result.geocodingResponse.addresses![0];
      String sido = "";
      String sigugun = "";
      String dongmyun = "";
      for (int i = 0; i < addressInfo.addressElements.length; i++) {
        final types = addressInfo.addressElements[i].types[0];
        if (types == "SIDO") {
          sido = addressInfo.addressElements[i].longName;
        } else if (types == "SIGUGUN") {
          sigugun = addressInfo.addressElements[i].longName;
        } else if (types == "DONGMYUN") {
          dongmyun = addressInfo.addressElements[i].longName;
        }
      }
      final drivingAddress = DrivingAddress(
        sido: sido,
        sigungu: sigugun,
        legalDong: dongmyun,
      );

      /// 선택 장소 정보 최근 검색 기록에 저장 후, 이전 화면에 장소 정보 전달
      final mapData = MapData(
        latLng: NLatLng(double.parse(addressInfo.y), double.parse(addressInfo.x)),
        addressRoad: address,
        addressJibun: address,
        place: place,
        drivingAddress: drivingAddress,
      );
      return mapData;
    }
    Fluttertoast.showToast(msg: "장소를 조회할 수 없습니다.");
    return null;
  }

  /// 검색한 장소 정보 조회 API
  Future<StateAPI> getAddressInfo({required String address}) async {
    final request = GeocodingRequest(
      query: address,
      page: 1,
      count: 1,
    );
    final result = await getNaverAddressInfoUseCase.execute(
      clientId: clientId,
      clientSecret: clientSecret,
      geocodingRequest: request,
    );

    if (result is Success && result.geocodingResponse.addresses != null && result.geocodingResponse.addresses!.isNotEmpty) {
      return result;
    }
    return Fail(errorMessage: "해당 장소 정보를 조회할 수 없습니다.");
  }

  /// 미확정 호출취소 API
  Future<StateAPI> cancelCall({required int drvReqSq}) async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = CallCancelRequest(
      mbrCmSq: mbrSq,
      drvReqSq: drvReqSq,
    );

    final result = await setCallCancelUseCase.execute(callCancelRequest: request);
    state = result;

    return result;
  }

  /// 확정 호출취소 API
  Future<StateAPI> cancelConfirmCall({required int drvReqSq, required String drvCancelTp}) async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = ConfirmCallCancelRequest(
      mbrCmSq: mbrSq,
      drvReqSq: drvReqSq,
      drvCancelTp: drvCancelTp,
    );

    final result = await setConfirmCallCancelUseCase.execute(confirmCallCancelRequest: request);
    state = result;

    if (result is Success) {
      await _sendPush(title: StringPush.callTitle, body: StringPush.cancelBody, type: DrvReqSt.del);
    }

    return result;
  }

  /// 호출요금 변경 API
  Future<StateAPI> changeCallFee({required int drvReqSq, required int newPrice}) async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = CallFeeChangeRequest(
      mbrSq: mbrSq,
      drvReqSq: drvReqSq,
      beforPrice: price,
      price: newPrice,
    );

    final result = await setCallFeeChangeUseCase.execute(callFeeChangeRequest: request);
    state = result;

    if (result is Success) {
      price = newPrice;

      await _sendPush(
        title: StringPush.callTitle,
        body: "${StringPush.feeBody1} ${getPrice(newPrice)}${StringPush.feeBody2}",
        type: "fee",
      );
    }

    return result;
  }

  /// 리뷰 작성 API
  Future<StateAPI> writeReview({required int drvReqSq, required String reviewContent, required int starPoint}) async {
    state = Loading();

    final request = ReviewWriteRequest(
      drvReqSq: drvReqSq,
      reviewContent: reviewContent,
      starPoint: starPoint,
    );

    final result = await setReviewWriteUseCase.execute(reviewWriteRequest: request);
    state = result;

    if (result is Success) {
      await _sendPush(title: StringPush.callTitle, body: StringPush.reviewBody, type: "review");
    }

    return result;
  }

  /// 푸시 알림 전송 API
  Future<void> _sendPush({required String title, required String body, required String type}) async {
    if (title.isEmpty || body.isEmpty) {
      return;
    }

    final request = FCMPushRequest(
      mbrSqTarget: _mbrDmSq,
      title: title,
      body: body,
      type: type,
    );
    await setFCMPushUseCase.execute(fcmPushRequest: request);
  }

  /// ================ 도착지, 경유지 변경 ================

  /// 출발지 데이터 모델
  MapData? startMapData;

  /// 도착지 데이터 모델
  MapData? endMapData;

  /// 운행거리 및 요금 조회 API
  Future<Map<String, int>> _getDrivingCalculate({
    required MapData startMapData,
    required MapData endMapData,
    required List<StopOver> stopOverList,
  }) async {
    /// 운행거리 및 요금 재조회 시 요금 값 초기화
    int basicPrice = 0;
    int distance = 0;

    final result = await _getDrivingDistance(
      startMapData: startMapData,
      endMapData: endMapData,
      stopOverList: stopOverList,
    );
    if (result is Success) {
      final response = result.directionsResponse;
      distance = response.route!.traoptimal[0].summary.distance; // 운행거리

      final priceResult = await _getDrivingPrice(
        startMapData: startMapData,
        endMapData: endMapData,
        stopOverList: stopOverList,
      );
      if (priceResult is Success) {
        final priceResponse = priceResult.drivingPriceResponse;
        if (priceResponse.price > 0) {
          /// 요금표에 해당 지역이 있는 경우
          basicPrice = priceResponse.price;
        } else {
          /// 없는 경우
          final km = (distance / 1000).floor(); // m 단위 절삭
          if (startMapData.drivingAddress.sido == "경기도" && endMapData.drivingAddress.sido == "경기도") {
            basicPrice = ((15000 + (km * 1000)) / 1000).floor() * 1000; // 1000원 단위 이하 절삭
          } else {
            final taxiFare = response.route!.traoptimal[0].summary.taxiFare; // 택시 요금
            final tollFare = response.route!.traoptimal[0].summary.tollFare; // 통행 요금(톨게이트)
            basicPrice = ((15000 + taxiFare + tollFare + (km * 1000)) / 1000).floor() * 1000; // 1000원 단위 이하 절삭
          }
        }
      }
    }
    return Map<String, int>.from({
      "distance": distance,
      "price": basicPrice,
    });
  }

  /// 운행거리 조회 API
  Future<StateAPI> _getDrivingDistance({
    required MapData startMapData,
    required MapData endMapData,
    required List<StopOver> stopOverList,
  }) async {
    final start = "${startMapData.latLng.longitude},${startMapData.latLng.latitude}";
    final goal = "${endMapData.latLng.longitude},${endMapData.latLng.latitude}";
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

    return result;
  }

  /// 운행 요금 조회 API
  Future<StateAPI> _getDrivingPrice({
    required MapData startMapData,
    required MapData endMapData,
    required List<StopOver> stopOverList,
  }) async {
    List<DrivingAddress> drivingAddressList = List.from({});
    for (int i = 0; i < stopOverList.length; i++) {
      drivingAddressList.add(stopOverList[i].drivingAddress);
    }

    final request = DrivingPriceRequest(
      start: startMapData.drivingAddress,
      end: endMapData.drivingAddress,
      stopoverList: drivingAddressList,
    );
    final result = await getDrivingPriceUseCase.execute(drivingPriceRequest: request);

    return result;
  }

  /// 호출요금 변경 API
  Future<StateAPI> changeCallInfo({
    required int drvReqSq,
    MapData? changeEndMapData,
    List<StopOver>? changeStopOverList,
  }) async {
    state = Loading();

    final getCallInfoRequest = DrvRequest(drvReqSq: drvReqSq);
    final callInfoResult = await getCallInfoUseCase.execute(getCallInfoRequest: getCallInfoRequest);

    if (callInfoResult is Success) {
      /// 요금 조회
      Map<String, int> distanceAndPriceMap = await _getDrivingCalculate(
        startMapData: startMapData!,
        endMapData: changeEndMapData ?? endMapData!,
        stopOverList: changeStopOverList ?? stopOverList,
      );

      int changeDistance = distanceAndPriceMap["distance"] ?? 0;
      int changePrice = distanceAndPriceMap["price"] ?? 0;

      if (changeDistance == 0 || changePrice == 0) {
        return Fail();
      }

      final request = CallInfoChangeRequest(
        drvReqSq: drvReqSq,
        reqEndAddress: (changeEndMapData ?? endMapData!).addressRoad,
        reqEndPlaceNm: (changeEndMapData ?? endMapData!).place,
        stopOverLst: changeStopOverList ?? stopOverList,
        drvDistance: changeDistance,
        drvPaymPrice: changePrice,
        gpsEndLat: (changeEndMapData ?? endMapData!).latLng.latitude,
        gpsEndLong: (changeEndMapData ?? endMapData!).latLng.longitude,
      );

      final result = await setCallInfoChangeUseCase.execute(callInfoChangeRequest: request);
      state = result;

      if (result is Success) {
        await _sendPush(
          title: StringPush.callTitle,
          body: StringPush.changeInfoBody,
          type: "changeInfo",
        );

        /// 변경 정보 UI 반영
        if (changeEndMapData != null) {
          endMapData = changeEndMapData;
          end = changeEndMapData.place.isNotEmpty ? changeEndMapData.place : changeEndMapData.addressRoad;
        }
        if (changeStopOverList != null) {
          stopOverList = changeStopOverList;
        }
        price = changePrice;
        return result;
      }
      return Fail();
    }
    return Fail();
  }
}
