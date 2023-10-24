import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/auth/login_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/fcm/fcm_token_request.dart';
import 'package:kdmp_cm_app/data/model/register/register_request.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/login/get_login_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_token_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/register/set_register_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/fcm/get_fcm_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_user_data_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_onboarding_check_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_user_data_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/device_info_util.dart';

class RegisterVerifyViewModel {
  RegisterVerifyViewModel({
    required this.setRegisterUseCase,
    required this.getLoginUseCase,
    required this.setUserDataUseCase,
    required this.getOnBoardingCheckUseCase,
    required this.getFCMUseCase,
    required this.setFCMTokenUseCase,
    required this.deleteUserDataUseCase,
  });

  final SetRegisterUseCase setRegisterUseCase;
  final GetLoginUseCase getLoginUseCase;
  final SetUserDataUseCase setUserDataUseCase;
  final GetOnBoardingCheckUseCase getOnBoardingCheckUseCase;
  final GetFCMUseCase getFCMUseCase;
  final SetFCMTokenUseCase setFCMTokenUseCase;
  final DeleteUserDataUseCase deleteUserDataUseCase;

  /// 상태
  StateAPI state = Loading();

  /// 회원가입 API
  Future<StateAPI> register({
    required String mbrNm,
    required String mbrMobilePhone,
    required String mbrCi,
    required List<TempAgreeTerm> tempAgreeTermList,
  }) async {
    state = Loading();

    final mbrDeviceId = await getDeviceId();
    final agreeTermList = List<AgreeTerm>.from({});
    for (int i = 0; i < tempAgreeTermList.length; i++) {
      agreeTermList.add(AgreeTerm(trmSq: tempAgreeTermList[i].trmSq, agreeYn: tempAgreeTermList[i].agreeYn));
    }
    final request = RegisterRequest(
      mbrNm: mbrNm,
      mbrDeviceId: mbrDeviceId,
      mbrMobilePhone: mbrMobilePhone,
      mbrCi: mbrCi,
      agreeTermList: agreeTermList,
    );
    final result = await setRegisterUseCase.execute(registerRequest: request);
    state = result;

    return result;
  }

  /// 로그인 API
  Future<StateAPI> login({
    required String mbrId,
    required String mbrPw,
    required String mbrCi,
  }) async {
    state = Loading();

    final mbrDeviceId = await getDeviceId();
    final request = LoginRequest(mbrId: mbrId, mbrDeviceId: mbrDeviceId, password: mbrPw);
    final result = await getLoginUseCase.execute(loginRequest: request);
    state = result;

    if (result is Success) {
      /// 회원 유형
      final mbrPrivilegeTp = result.loginResponse.mbrPrivilegeTp;

      if (mbrPrivilegeTp == MbrPrivilegeTp.customer) {
        // 회원 유형이 고객일 경우에만 저장
        await setUserDataUseCase.login(
          jwt: result.loginResponse.jwt,
          autoRefresh: result.loginResponse.autoRefresh,
          mbrSq: result.loginResponse.mbrSq,
          mbrId: mbrId,
          mbrPw: mbrPw,
          mbrCi: mbrCi,
          isFirstLogin: false,
        );

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

  /// 로그아웃
  Future<void> logout() async {
    await deleteUserDataUseCase.withdrawal();
  }
}
