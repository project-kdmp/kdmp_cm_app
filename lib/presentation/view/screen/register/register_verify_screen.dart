import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/register/register_request.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/login/get_login_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_token_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/register/set_register_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/fcm/get_fcm_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_user_data_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_user_data_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/home/home_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/onboarding/onboarding_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/register/demo_login_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/register/no_permission_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/register/phone_inline_verify_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/register/register_car_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/cm_term_screen.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/register/register_verify_viewmodel.dart';

/// 회원가입 본인인증 화면
class RegisterVerifyScreen extends StatefulWidget {
  const RegisterVerifyScreen({
    Key? key,
    required this.agreeTermList,
  }) : super(key: key);

  static const String routeName = "register_verify";
  static const String routeURL = "/register_verify";

  final List<TempAgreeTerm> agreeTermList;

  @override
  State<RegisterVerifyScreen> createState() => _RegisterVerifyScreenState();
}

class _RegisterVerifyScreenState extends State<RegisterVerifyScreen> {
  late final RegisterVerifyViewModel _registerVerifyViewModel;

  int _demoClickCount = 0;

  @override
  void initState() {
    super.initState();
    _registerVerifyViewModel = RegisterVerifyViewModel(
      setRegisterUseCase: GetIt.instance<SetRegisterUseCase>(),
      getLoginUseCase: GetIt.instance<GetLoginUseCase>(),
      setUserDataUseCase: GetIt.instance<SetUserDataUseCase>(),
      getFCMUseCase: GetIt.instance<GetFCMUseCase>(),
      setFCMTokenUseCase: GetIt.instance<SetFCMTokenUseCase>(),
      deleteUserDataUseCase: GetIt.instance<DeleteUserDataUseCase>(),
    );
  }

  /// 인증번호 확인 성공 → 회원가입 → 로그인 → 회원 상태별 분기
  ///
  /// sendSmsVerify는 휴대폰 소유 확인(result: bool)만 해주고 CI(고유식별키)는 내려주지 않음.
  /// TODO: 실제 CI가 필요하면 별도 본인인증(CI 발급) 절차가 필요함 — 서버팀과 협의 필요.
  Future<void> _onVerified(String mbrNm, String mbrMobilePhone) async {
    final mbrCi = "ci_test_${mbrMobilePhone.substring(7, 11)}";

    final registerResult = await _registerVerifyViewModel.register(
      mbrNm: mbrNm,
      mbrMobilePhone: mbrMobilePhone,
      mbrCi: mbrCi,
      tempAgreeTermList: widget.agreeTermList,
    );

    if (registerResult is! Success) return;

    /// 회원가입 - 성공시 처리
    final registerResponse = registerResult.registerResponse;

    /// 로그인 처리
    final loginResult = await _registerVerifyViewModel.login(
      mbrId: registerResponse.mbrId,
      mbrPw: registerResponse.mbrPwd,
      mbrCi: mbrCi,
    );

    if (loginResult is! Success) return;
    if (!mounted) return;

    /// 로그인 - 성공시 처리
    final loginResponse = loginResult.loginResponse;

    /// 회원구분
    switch (loginResponse.mbrPrivilegeTp) {
      case MbrPrivilegeTp.driver:
        _registerVerifyViewModel.logout();
        await _showAlertDialog(content: StringLogin.mbrPrivilegeTpDMMB, isCanceled: false);
        SystemNavigator.pop();
        return;
      case MbrPrivilegeTp.admin:
        _registerVerifyViewModel.logout();
        await _showAlertDialog(content: StringLogin.mbrPrivilegeTpADMN, isCanceled: false);
        SystemNavigator.pop();
        return;
      case MbrPrivilegeTp.customer:
        {
          /// 이용정지 회원 체크
          if (loginResponse.serviceYn != "Y") {
            if (!mounted) return;
            context.goNamed(NoPermissionScreen.routeName);
            return;
          }

          /// 가입상태
          switch (loginResponse.mbrSt) {
            case MbrSt.temp:
              break;
            case MbrSt.reject: // 심사 거절이나 기사용 상태
              break;
            case MbrSt.registerComplete:
              if (loginResponse.mbrCarCount == 0) {
                /// 차량등록 화면으로 이동
                if (!mounted) return;
                await context.pushNamed(RegisterCarScreen.routeName);
              }

              /// 이용약관 갱신 여부 확인
              if (loginResponse.bagreeTrmUpdate) {
                /// 미동의 필수 약관 갱신 필요
                if (!mounted) return;
                await context.pushNamed(CMTermScreen.routeName);
              }

              /// 수동 로그인 시에는 매번 온보딩 화면을 노출
              if (!mounted) return;
              await context.pushNamed(OnBoardingScreen.routeName);
              if (!mounted) return;
              context.goNamed(HomeScreen.routeName);
              break;
            case MbrSt.withdrawal:
              _registerVerifyViewModel.logout();
              await _showAlertDialog(content: StringLogin.mbrStW, isCanceled: false);
              SystemNavigator.pop();
              break;
            case MbrSt.registerDormant:
              _registerVerifyViewModel.logout();
              await _showAlertDialog(content: StringLogin.mbrStD, isCanceled: false);
              SystemNavigator.pop();
              break;
          }
        }
        break;
      default:
        _registerVerifyViewModel.logout();
        await _showAlertDialog(content: StringLogin.mbrPrivilegeTpUNKNOWN, isCanceled: false);
        SystemNavigator.pop();
    }
  }

  /// 앱바 10번 클릭 시 데모 로그인 화면으로 이동 (심사용)
  void _onTitleTap() {
    if (AppConstants.isDev) return;

    _demoClickCount++;
    if (_demoClickCount >= 10) {
      _demoClickCount = 0;
      context.goNamed(DemoLoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PhoneInlineVerifyScreen(onVerified: _onVerified, onTitleTap: _onTitleTap);
  }

  Future<void> _showAlertDialog({String? title, String? content, bool isWarning = false, bool isCanceled = true}) {
    return showDialog(
      context: context,
      barrierDismissible: isCanceled, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: content,
          isCanceled: isCanceled,
          isWarning: isWarning,
          onConfirm: () {
            context.pop();
          },
        );
      },
    );
  }
}
