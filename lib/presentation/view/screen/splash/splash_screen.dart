import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/login/get_login_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/set_jwt_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrid_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrpw_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_onboarding_check_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrid_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrpw_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/auth/login_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/home/home_screen.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/splash/splash_viewmodel.dart';

/// 스플래시 화면
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = "splash";
  static const String routeURL = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashViewModel _splashViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    Future.delayed(const Duration(milliseconds: 1000), () {
      _login();
    });
  }

  /// Create
  void initViewModel() {
    _splashViewModel = SplashViewModel(
      getLoginUseCase: GetIt.instance<GetLoginUseCase>(),
      setJwtUseCase: GetIt.instance<SetJwtUseCase>(),
      setMbrSqUseCase: GetIt.instance<SetMbrSqUseCase>(),
      setMbrIdUseCase: GetIt.instance<SetMbrIdUseCase>(),
      getMbrIdUseCase: GetIt.instance<GetMbrIdUseCase>(),
      setMbrPwUseCase: GetIt.instance<SetMbrPwUseCase>(),
      getMbrPwUseCase: GetIt.instance<GetMbrPwUseCase>(),
      getOnBoardingCheckUseCase: GetIt.instance<GetOnBoardingCheckUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Center(
          child: Image.asset(ImageCommon.appLogo, width: 200, height: 200),
        ),
      ),
    );
  }

  _login() async {
    /// 로그인 처리
    final result = await _splashViewModel.login();

    if (result is Success) {
      /// 로그인 - 성공시 처리
      final response = result.loginResponse;

      /// 회원구분
      switch (response.mbrPrivilegeTp) {
        case MbrPrivilegeTp.customer:
          Fluttertoast.showToast(msg: StringLogin.mbrPrivilegeTpCMMB);
          context.goNamed(LoginScreen.routeName);
          return;
        case MbrPrivilegeTp.admin:
          Fluttertoast.showToast(msg: StringLogin.mbrPrivilegeTpADMN);
          context.goNamed(LoginScreen.routeName);
          return;
        case MbrPrivilegeTp.driver:
          {
            /// 가입상태
            switch (response.mbrSt) {
              case MbrSt.temp:
                // TODO: 차량등록 화면으로 이동
                break;
              case MbrSt.reject:
                // 심사 거절이나 기사용 상태
                break;
              case MbrSt.registerComplete:

                /// 이용약관 갱신 여부 확인
                // if (response.bagreeTrmUpdate) {
                //   /// 필수 약관 모두 동의
                //   final isOnBoardingCheck = await _splashViewModel.isOnBoardingCheck();
                //   if (!isOnBoardingCheck) {
                //     await context.pushNamed(OnBoardingScreen.routeName);
                //   }
                context.goNamed(HomeScreen.routeName);
                // } else {
                //   /// 미동의 필수 약관 갱신 필요
                //   context.goNamed(CMTermScreen.routeName);
                // }
                break;
              case MbrSt.withdrawal:
                Fluttertoast.showToast(msg: StringLogin.mbrStW);
                break;
              case MbrSt.registerDormant:
                Fluttertoast.showToast(msg: StringLogin.mbrStD);
                break;
            }
          }
      }
    } else if (result is Bad) {
      // TODO: 로그인 - 에러코드 처리
      switch (result.badResponse.bizErrCode) {
        case 22001:
      }
      Fluttertoast.showToast(msg: StringLogin.loginFail);
    } else if (result is Fail) {
      context.goNamed(LoginScreen.routeName);
    }
  }

  /// 앱 뒤로가기
  Future<bool> _onBackPressed() async {
    SystemNavigator.pop();
    return true;
  }
}
