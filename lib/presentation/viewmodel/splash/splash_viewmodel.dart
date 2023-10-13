import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/auth/login_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/fcm/fcm_token_request.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/login/get_login_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_token_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/fcm/get_fcm_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/set_jwt_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrid_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrpw_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_onboarding_check_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrid_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrpw_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/device_info_util.dart';

class SplashViewModel {
  SplashViewModel({
    required this.getLoginUseCase,
    required this.setJwtUseCase,
    required this.setMbrSqUseCase,
    required this.setMbrIdUseCase,
    required this.getMbrIdUseCase,
    required this.setMbrPwUseCase,
    required this.getMbrPwUseCase,
    required this.getOnBoardingCheckUseCase,
    required this.getFCMUseCase,
    required this.setFCMTokenUseCase,
  });

  final GetLoginUseCase getLoginUseCase;
  final SetJwtUseCase setJwtUseCase;
  final SetMbrSqUseCase setMbrSqUseCase;
  final SetMbrIdUseCase setMbrIdUseCase;
  final GetMbrIdUseCase getMbrIdUseCase;
  final SetMbrPwUseCase setMbrPwUseCase;
  final GetMbrPwUseCase getMbrPwUseCase;
  final GetOnBoardingCheckUseCase getOnBoardingCheckUseCase;
  final GetFCMUseCase getFCMUseCase;
  final SetFCMTokenUseCase setFCMTokenUseCase;

  /// 상태
  StateAPI state = Loading();

  /// 로그인 API
  Future<StateAPI> login() async {
    state = Loading();

    final mbrId = await getMbrIdUseCase.execute();
    final password = await getMbrPwUseCase.execute();
    final mbrDeviceId = await getDeviceId();

    if (mbrId.isEmpty || password.isEmpty) {
      state = Fail(errorMessage: "아이디 비밀번호가 존재하지 않습니다.");
      return state;
    }

    final request = LoginRequest(mbrId: mbrId, mbrDeviceId: mbrDeviceId, password: password);
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
