import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/drv_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_called_detail_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';

class CalledDetailViewModel {
  CalledDetailViewModel({
    required this.getCalledDetailUseCase,
  });

  final GetCalledDetailUseCase getCalledDetailUseCase;

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

  /// 출발지 장소명
  final ValueNotifier<String> _startPlace = ValueNotifier<String>("");

  ValueNotifier<String> get startPlaceNotifier => _startPlace;

  String get startPlace => _startPlace.value;

  set startPlace(String value) => _startPlace.value = value;

  /// 경유지 리스트
  final ValueNotifier<List<StopOver>> _stopoverList = ValueNotifier<List<StopOver>>(List.empty());

  ValueNotifier<List<StopOver>> get stopoverListNotifier => _stopoverList;

  List<StopOver> get stopoverList => _stopoverList.value;

  set stopoverList(List<StopOver> value) => _stopoverList.value = value;

  /// 도착지 장소명
  final ValueNotifier<String> _endPlace = ValueNotifier<String>("");

  ValueNotifier<String> get endPlaceNotifier => _endPlace;

  String get endPlace => _endPlace.value;

  set endPlace(String value) => _endPlace.value = value;

  /// 기사이름
  final ValueNotifier<String> _driver = ValueNotifier<String>("");

  ValueNotifier<String> get driverNotifier => _driver;

  String get driver => _driver.value;

  set driver(String value) => _driver.value = value;

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
      DateTime.parse(startDate).isAfter(DateTime.now().subtract(const Duration(days: 7)));
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
      startDate = response.drvStartDt ?? "";
      date = getDateAndTimeFormat(startDate: response.drvStartDt, endDate: response.drvEndDt);
      drvReqSt = response.drvReqSt ?? "";
      startPlace = response.reqStartPlaceNm.isNotEmpty ? response.reqStartPlaceNm : response.reqStartAddress;
      endPlace = response.reqEndPlaceNm.isNotEmpty ? response.reqEndPlaceNm : response.reqEndAddress;
      stopoverList = response.stopOverLst;

      /// TODO: 결제수단 paymKind 안내려옴
      // payment = response.paymKind ?? "";
      amount = response.drvPaymPrice ?? 0;
      driver = response.dmMbrNm ?? "";
      carNumId = response.carNumId ?? "";
      star = response.starPoint ?? 0;
      review = response.reviewContent ?? "";
    }

    return result;
  }
}
