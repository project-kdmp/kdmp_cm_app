import 'package:flutter/foundation.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kdmp_cm_app/data/model/common/drv_request.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/data/model/fcm/fcm_push_request.dart';
import 'package:kdmp_cm_app/data/model/naver/geocoding_request.dart';
import 'package:kdmp_cm_app/data/model/work/review_write_request.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_push_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_called_detail_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_address_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_review_write_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';

class CalledDetailViewModel {
  CalledDetailViewModel({
    required this.getMbrSqUseCase,
    required this.getCalledDetailUseCase,
    required this.setReviewWriteUseCase,
    required this.setFCMPushUseCase,
    required this.getNaverAddressInfoUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetCalledDetailUseCase getCalledDetailUseCase;
  final SetReviewWriteUseCase setReviewWriteUseCase;
  final SetFCMPushUseCase setFCMPushUseCase;
  final GetNaverAddressInfoUseCase getNaverAddressInfoUseCase;

  String clientId = "";
  String clientSecret = "";

  /// 운행기사 번호
  int _mbrDmSq = 0;

  /// 코드
  final ValueNotifier<String> _code = ValueNotifier<String>("");

  ValueNotifier<String> get codeNotifier => _code;

  String get code => _code.value;

  set code(String value) => _code.value = value;

  /// 일시
  final ValueNotifier<String> _date = ValueNotifier<String>("");

  ValueNotifier<String> get dateNotifier => _date;

  String get date => _date.value;

  set date(String value) => _date.value = value;

  /// 운행 시작일
  final ValueNotifier<String> _startDate = ValueNotifier<String>("");

  ValueNotifier<String> get startDateNotifier => _startDate;

  String get startDate => _startDate.value;

  set startDate(String value) {
    _startDate.value = value;
    _checkIsReviewEnabled();
  }

  /// 호출유형
  final ValueNotifier<String> _callType = ValueNotifier<String>("");

  ValueNotifier<String> get callTypeNotifier => _callType;

  String get callType => _callType.value;

  set callType(String value) => _callType.value = value;

  /// 상태
  final ValueNotifier<String> _drvReqSt = ValueNotifier<String>("");

  ValueNotifier<String> get drvReqStNotifier => _drvReqSt;

  String get drvReqSt => _drvReqSt.value;

  set drvReqSt(String value) => _drvReqSt.value = value;

  /// 결제수단
  final ValueNotifier<String> _payment = ValueNotifier<String>("");

  ValueNotifier<String> get paymentNotifier => _payment;

  String get payment => _payment.value;

  set payment(String value) => _payment.value = value;

  /// 결제금액
  final ValueNotifier<int> _amount = ValueNotifier<int>(0);

  ValueNotifier<int> get amountNotifier => _amount;

  int get amount => _amount.value;

  set amount(int value) => _amount.value = value;

  /// 출발지 데이터 모델
  final ValueNotifier<MapData?> _startMapData = ValueNotifier<MapData?>(null);

  ValueNotifier<MapData?> get startMapDataNotifier => _startMapData;

  MapData? get startMapData => _startMapData.value;

  set startMapData(MapData? value) => _startMapData.value = value;

  /// 도착지 데이터 모델
  final ValueNotifier<MapData?> _endMapData = ValueNotifier<MapData?>(null);

  ValueNotifier<MapData?> get endMapDataNotifier => _endMapData;

  MapData? get endMapData => _endMapData.value;

  set endMapData(MapData? value) => _endMapData.value = value;

  /// 경유지 리스트
  final ValueNotifier<List<StopOver>> _stopoverList = ValueNotifier<List<StopOver>>(List.empty());

  ValueNotifier<List<StopOver>> get stopoverListNotifier => _stopoverList;

  List<StopOver> get stopoverList => _stopoverList.value;

  set stopoverList(List<StopOver> value) => _stopoverList.value = value;

  /// 기사이름
  final ValueNotifier<String> _driver = ValueNotifier<String>("");

  ValueNotifier<String> get driverNotifier => _driver;

  String get driver => _driver.value;

  set driver(String value) => _driver.value = value;

  /// 기사아이디
  final ValueNotifier<String> _driverId = ValueNotifier<String>("");

  ValueNotifier<String> get driverIdNotifier => _driverId;

  String get driverId => _driverId.value;

  set driverId(String value) => _driverId.value = value;

  /// 차량
  final ValueNotifier<String> _carNumId = ValueNotifier<String>("");

  ValueNotifier<String> get carNumIdNotifier => _carNumId;

  String get carNumId => _carNumId.value;

  set carNumId(String value) => _carNumId.value = value;

  /// 리뷰 점수
  final ValueNotifier<int> _star = ValueNotifier<int>(0);

  ValueNotifier<int> get starNotifier => _star;

  int get star => _star.value;

  set star(int value) => _star.value = value;

  /// 리뷰 메세지
  final ValueNotifier<String> _review = ValueNotifier<String>("");

  ValueNotifier<String> get reviewNotifier => _review;

  String get review => _review.value;

  set review(String value) => _review.value = value;

  /// 리뷰 수정 버튼 활성화 여부
  final ValueNotifier<bool> _isReviewEnabled = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isReviewEnabledNotifier => _isReviewEnabled;

  bool get isReviewEnabled => _isReviewEnabled.value;

  _setIsReviewEnabled({required bool value}) {
    _isReviewEnabled.value = value;
  }

  _checkIsReviewEnabled() {
    var valid = false;
    if (startDate.isNotEmpty) {
      valid = DateTime.parse(startDate).isAfter(DateTime.now().subtract(const Duration(days: 30)));
    }
    _setIsReviewEnabled(value: valid);
  }

  /// 상태
  StateAPI state = Loading();

  /// 이용 정보 조회 API
  Future<StateAPI> getCalledDetail(int drvReqSq) async {
    state = Loading();

    final request = DrvRequest(drvReqSq: drvReqSq);
    final result = await getCalledDetailUseCase.execute(calledDetailRequest: request);
    state = result;

    if (result is Success) {
      final response = result.calledDetailResponse;
      code = response.drvReqEndId ?? "";
      startDate = response.drvStartDt ?? "";
      date = response.drvStartDt != null ? getDateAndTimeFormat(startDate: response.drvStartDt, endDate: response.drvEndDt) : getDateAndTimeFormat(startDate: response.reqRegDt);
      drvReqSt = response.drvReqSt ?? "";
      startMapData = MapData(
        latLng: const NLatLng(0, 0),
        place: response.reqStartPlaceNm,
        address: response.reqStartAddress,
        drivingAddress: DrivingAddress(legalDong: "", sigungu: "", sido: ""),
      );
      endMapData = MapData(
        latLng: const NLatLng(0, 0),
        place: response.reqEndPlaceNm,
        address: response.reqEndAddress,
        drivingAddress: DrivingAddress(legalDong: "", sigungu: "", sido: ""),
      );
      stopoverList = response.stopOverLst;

      payment = response.paymKind ?? "";
      amount = response.drvPaymPrice ?? 0;
      driver = response.dmMbrNm ?? "";
      driverId = response.dmMbrId ?? "";
      carNumId = response.carNumId ?? "";
      star = response.starPoint ?? 0;
      review = response.reviewContent ?? "";
      _mbrDmSq = response.mbrDmSq ?? 0;
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

  Future<Map<String, dynamic>?> getDrivingData() async {
    if (startMapData == null || endMapData == null) {
      return null;
    }
    Map<String, dynamic> drivingData = Map.from({});
    final start = await getMapData(
      address: startMapData!.address,
      place: startMapData!.place,
    );
    final end = await getMapData(
      address: endMapData!.address,
      place: endMapData!.place,
    );
    final List<StopOver> stopOver = List.from(stopoverList);
    for (int i = 0; i < stopOver.length; i++) {
      final stopOverMapData = await getMapData(
        address: stopOver[i].address,
        place: stopOver[i].placeName,
      );
      if (stopOverMapData == null) {
        return null;
      }
      stopOver[i].drivingAddress = stopOverMapData.drivingAddress;
    }
    drivingData["startMapData"] = start;
    drivingData["endMapData"] = end;
    drivingData["stopOverList"] = stopOver;
    return drivingData;
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

  /// 장소 정보 검색 후 전 화면으로 값 전달
  Future<MapData?> getMapData({required String address, required String place}) async {
    /// 검색된 주소로 장소 정보 검색
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

      /// 장소 정보 전달
      final mapData = MapData(
        latLng: NLatLng(double.parse(addressInfo.y), double.parse(addressInfo.x)),
        address: address,
        place: place,
        drivingAddress: drivingAddress,
      );
      return mapData;
    }
    return null;
  }
}
