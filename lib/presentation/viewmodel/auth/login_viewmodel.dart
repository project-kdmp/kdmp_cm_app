import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/auth/login_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/fcm/fcm_token_request.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/login/get_login_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_token_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/fcm/get_fcm_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/set_auto_refresh_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/set_jwt_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_onboarding_check_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrid_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrpw_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/device_info_util.dart';

class LoginViewModel {
  LoginViewModel({
    required this.getLoginUseCase,
    required this.setJwtUseCase,
    required this.setAutoRefreshUseCase,
    required this.setMbrSqUseCase,
    required this.setMbrIdUseCase,
    required this.setMbrPwUseCase,
    required this.getOnBoardingCheckUseCase,
    required this.getFCMUseCase,
    required this.setFCMTokenUseCase,
  });

  final GetLoginUseCase getLoginUseCase;
  final SetJwtUseCase setJwtUseCase;
  final SetAutoRefreshUseCase setAutoRefreshUseCase;
  final SetMbrSqUseCase setMbrSqUseCase;
  final SetMbrIdUseCase setMbrIdUseCase;
  final SetMbrPwUseCase setMbrPwUseCase;
  final GetOnBoardingCheckUseCase getOnBoardingCheckUseCase;
  final GetFCMUseCase getFCMUseCase;
  final SetFCMTokenUseCase setFCMTokenUseCase;

  /// 상태
  StateAPI state = Loading();

  /// 아이디
  final ValueNotifier<String> _mbrId = ValueNotifier<String>("");

  ValueNotifier<String> get mbrIdNotifier => _mbrId;

  String get mbrId => _mbrId.value;

  set mbrId(String value) {
    _mbrId.value = value;
    _checkIsValid();
  }

  /// 비밀번호
  final ValueNotifier<String> _password = ValueNotifier<String>("");

  ValueNotifier<String> get passwordNotifier => _password;

  String get password => _password.value;

  set password(String value) {
    _password.value = value;
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
    debugPrint("$mbrId, $password");
    if (mbrId.trim().isNotEmpty && password.trim().isNotEmpty) {
      valid = true;
    } else {
      valid = false;
    }
    _setIsValid(value: valid);
  }

  /// 로그인 API
  Future<StateAPI> login() async {
    state = Loading();

    final mbrId = _mbrId.value.trim();
    final password = _password.value.trim();
    final mbrDeviceId = await getDeviceId();
    // final mbrDeviceId = "TP1A.220624.014"; // TODO: 임시값
    final request = LoginRequest(mbrId: mbrId, password: password, mbrDeviceId: mbrDeviceId);
    final result = await getLoginUseCase.execute(loginRequest: request);
    state = result;

    if (result is Success) {
      /// 회원 유형
      final mbrPrivilegeTp = result.loginResponse.mbrPrivilegeTp;

      if (mbrPrivilegeTp == MbrPrivilegeTp.customer) {
        // 회원 유형이 고객일 경우에만 저장
        await setJwtUseCase.execute(jwt: result.loginResponse.jwt);
        await setMbrSqUseCase.execute(mbrSq: result.loginResponse.mbrSq);
        await setMbrIdUseCase.execute(mbrId: mbrId);
        await setMbrPwUseCase.execute(mbrPw: password);

        await _setFcmToken(mbrSq: result.loginResponse.mbrSq);
      }
    }
    return result;
  }

  /// FCM 토큰 등록 API
  Future<StateAPI> _setFcmToken({required int mbrSq}) async {
    state = Loading();

    final fcmToken = await getFCMUseCase.execute();

    final request = FCMTokenRequest(
      mbrSq: mbrSq,
      mbrFcmToken: fcmToken,
    );
    final result = await setFCMTokenUseCase.execute(fcmTokenRequest: request);
    state = result;

    return result;
  }

  /// 온보딩 확인 여부 가져오기
  Future<bool> isOnBoardingCheck() async {
    return await getOnBoardingCheckUseCase.execute();
  }
}
