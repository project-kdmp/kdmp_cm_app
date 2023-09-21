import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/auth/login_request.dart';
import 'package:kdmp_cm_app/data/model/register/register_request.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/login/get_login_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/register/set_register_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/set_jwt_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_onboarding_check_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_firstlogin_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrid_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrpw_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/device_info_util.dart';

class PhoneVerifyViewModel {
  PhoneVerifyViewModel({
    required this.setRegisterUseCase,
    required this.getLoginUseCase,
    required this.setJwtUseCase,
    required this.setMbrSqUseCase,
    required this.setMbrIdUseCase,
    required this.setMbrPwUseCase,
    required this.setFirstLoginUseCase,
    required this.getOnBoardingCheckUseCase,
  });

  final SetRegisterUseCase setRegisterUseCase;
  final GetLoginUseCase getLoginUseCase;
  final SetJwtUseCase setJwtUseCase;
  final SetMbrSqUseCase setMbrSqUseCase;
  final SetMbrIdUseCase setMbrIdUseCase;
  final SetMbrPwUseCase setMbrPwUseCase;
  final SetFirstLoginUseCase setFirstLoginUseCase;
  final GetOnBoardingCheckUseCase getOnBoardingCheckUseCase;

  /// 상태
  StateAPI state = Loading();

  /// 회원가입 API
  Future<StateAPI> register({
    required String mbrNm,
    required String mbrMobilePhone,
    required String mbrCi,
    required List<AgreeTerm> agreeTermList,
  }) async {
    state = Loading();

    final mbrDeviceId = await getDeviceId();
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
    required String password,
  }) async {
    state = Loading();

    final mbrDeviceId = await getDeviceId();
    final request = LoginRequest(mbrId: mbrId, mbrDeviceId: mbrDeviceId, password: password);
    final result = await getLoginUseCase.execute(loginRequest: request);
    state = result;

    if (result is Success) {
      await setJwtUseCase.execute(jwt: result.loginResponse.jwt);
      await setMbrSqUseCase.execute(mbrSq: result.loginResponse.mbrSq);
      await setMbrIdUseCase.execute(mbrId: mbrId);
      await setMbrPwUseCase.execute(mbrPw: password);
      await setFirstLoginUseCase.execute(isFirstLogin: false);
    }
    return result;
  }

  /// 온보딩 확인 여부 가져오기
  Future<bool> isOnBoardingCheck() async {
    return await getOnBoardingCheckUseCase.execute();
  }
}
