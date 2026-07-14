import 'package:kdmp_cm_app/data/model/auth/login_response.dart';
import 'package:kdmp_cm_app/data/model/auth/refresh_response.dart';
import 'package:kdmp_cm_app/data/model/auth/verify_response.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
import 'package:kdmp_cm_app/data/model/common/default_response.dart';
import 'package:kdmp_cm_app/data/model/common/drv_response.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_detail_response.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_list_response.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_write_response.dart';
import 'package:kdmp_cm_app/data/model/juso/juso_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/call_detail_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/call_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/called_detail_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/called_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/profile_detail_response.dart';
import 'package:kdmp_cm_app/data/model/naver/directions_response.dart';
import 'package:kdmp_cm_app/data/model/naver/geocoding_response.dart';
import 'package:kdmp_cm_app/data/model/naver/reverse_geocoding_response.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_detail_response.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_list_response.dart';
import 'package:kdmp_cm_app/data/model/payment/kgmobil_billingkey_response.dart';
import 'package:kdmp_cm_app/data/model/policy/policy_response.dart';
import 'package:kdmp_cm_app/data/model/register/register_response.dart';
import 'package:kdmp_cm_app/data/model/register/service_stop_response.dart';
import 'package:kdmp_cm_app/data/model/term/cm_term_list_response.dart';
import 'package:kdmp_cm_app/data/model/term/term_detail_response.dart';
import 'package:kdmp_cm_app/data/model/term/term_list_response.dart';
import 'package:kdmp_cm_app/data/model/work/call_info_response.dart';
import 'package:kdmp_cm_app/data/model/work/driving_price_response.dart';
import 'package:kdmp_cm_app/data/model/work/driving_response.dart';
import 'package:kdmp_cm_app/data/model/work/reservation_info_response.dart';

abstract class StateAPI {}

class Loading extends StateAPI {}

class Unauthorized extends StateAPI {}

class Bad extends StateAPI {
  final BadResponse _badResponse;

  Bad(this._badResponse);

  BadResponse get badResponse => _badResponse;
}

class Fail extends StateAPI {
  final String? errorMessage;

  Fail({this.errorMessage});
}

class Success extends StateAPI {
  final dynamic _response;

  Success(this._response);

  DefaultResponse get defaultResponse => _response;

  DrvResponse get drvResponse => _response;

  VerifyResponse get verifyResponse => _response;

  LoginResponse get loginResponse => _response;

  RefreshResponse get refreshResponse => _response;

  RegisterResponse get registerResponse => _response;

  ServiceStopResponse get serviceStopResponse => _response;

  TermDetailResponse get termDetailResponse => _response;

  TermListResponse get termListResponse => _response;

  CMTermListResponse get cmTermListResponse => _response;

  ProfileDetailResponse get profileDetailResponse => _response;

  CallDetailResponse get callDetailResponse => _response;

  CallListResponse get callListResponse => _response;

  CalledDetailResponse get calledDetailResponse => _response;

  CalledListResponse get calledListResponse => _response;

  CarListResponse get carListResponse => _response;

  CallInfoResponse get callInfoResponse => _response;

  ReservationInfoResponse get reservationInfoResponse => _response;

  NoticeListResponse get noticeListResponse => _response;

  NoticeDetailResponse get noticeDetailResponse => _response;

  InquiryListResponse get inquiryListResponse => _response;

  InquiryDetailResponse get inquiryDetailResponse => _response;

  InquiryWriteResponse get inquiryWriteResponse => _response;

  DrivingResponse get drivingResponse => _response;

  DrivingPriceResponse get drivingPriceResponse => _response;

  PolicyResponse get policyResponse => _response;

  /// 결제
  KGMobilBillingKeyResponse get kgMobilBillingKeyResponse => _response;

  /// 네이버 API
  ReverseGeocodingResponse get reverseGeocodingResponse => _response;

  GeocodingResponse get geocodingResponse => _response;

  DirectionsResponse get directionsResponse => _response;

  /// 도로명주소 API
  JusoListResponse get jusoListResponse => _response;
}
