import 'package:kdmp_cm_app/data/model/auth/login_response.dart';
import 'package:kdmp_cm_app/data/model/auth/refresh_response.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
import 'package:kdmp_cm_app/data/model/common/default_response.dart';
import 'package:kdmp_cm_app/data/model/common/drv_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/call_detail_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/call_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/called_detail_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/called_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/profile_detail_response.dart';
import 'package:kdmp_cm_app/data/model/register/register_response.dart';
import 'package:kdmp_cm_app/data/model/term/cm_term_list_response.dart';
import 'package:kdmp_cm_app/data/model/term/term_detail_response.dart';
import 'package:kdmp_cm_app/data/model/term/term_list_response.dart';
import 'package:kdmp_cm_app/data/model/work/call_info_response.dart';
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

  LoginResponse get loginResponse => _response;

  RefreshResponse get refreshResponse => _response;

  RegisterResponse get registerResponse => _response;

  TermDetailResponse get termDetailResponse => _response;

  TermListResponse get termListResponse => _response;

  CMTermListResponse get cmTermListResponse => _response;

  ProfileDetailResponse get profileDetailResponse => _response;

  CallDetailResponse get callDetailResponse => _response;

  CallListResponse get callListResponse => _response;

  CalledDetailResponse get calledDetailResponse => _response;

  CalledListResponse get calledListResponse => _response;

  CarListResponse get carListResponse => _response;

  PlaceListResponse get placeListResponse => _response;

  PlaceResponse get placeResponse => _response;

  CallInfoResponse get callInfoResponse => _response;

  ReservationInfoResponse get reservationInfoResponse => _response;
}
