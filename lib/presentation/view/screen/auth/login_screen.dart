import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/login/get_login_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/set_auto_refresh_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/set_jwt_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_onboarding_check_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrid_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrpw_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/home/home_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/onboarding/onboarding_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/auth/login_viewmodel.dart';

/// 로그인 화면 (본인인증)
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = "login";
  static const String routeURL = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginViewModel _loginViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  void initViewModel() {
    _loginViewModel = LoginViewModel(
      getLoginUseCase: GetIt.instance<GetLoginUseCase>(),
      setJwtUseCase: GetIt.instance<SetJwtUseCase>(),
      setAutoRefreshUseCase: GetIt.instance<SetAutoRefreshUseCase>(),
      setMbrSqUseCase: GetIt.instance<SetMbrSqUseCase>(),
      setMbrIdUseCase: GetIt.instance<SetMbrIdUseCase>(),
      setMbrPwUseCase: GetIt.instance<SetMbrPwUseCase>(),
      getOnBoardingCheckUseCase: GetIt.instance<GetOnBoardingCheckUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: StringRegister.phoneVerify,
      ),

      /// 화면
      body: SafeArea(
        child: Column(
          children: [
            Text("본인인증 WebView"),
            // TODO: 임시 버튼. 본인인증 기능 구현 후 제거
            CustomElevatedButton(
              onPressed: () async {
                /// 본인인증 후 로그인 처리
                // TODO: id, pw 임시값
                _loginViewModel.mbrId = "C000E";
                _loginViewModel.password = "ci234938";

                /// 로그인 처리
                final result = await _loginViewModel.login();

                if (result is Success) {
                  /// 로그인 - 성공시 처리
                  final response = result.loginResponse;

                  /// 회원구분
                  switch (response.mbrPrivilegeTp) {
                    case MbrPrivilegeTp.customer:
                      Fluttertoast.showToast(msg: StringLogin.mbrPrivilegeTpCMMB);
                      return;
                    case MbrPrivilegeTp.admin:
                      Fluttertoast.showToast(msg: StringLogin.mbrPrivilegeTpADMN);
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
                            // TODO: 이용약관 갱신?
                            final isOnBoardingCheck = await _loginViewModel.isOnBoardingCheck();
                            if (!isOnBoardingCheck) {
                              await context.pushNamed(OnBoardingScreen.routeName);
                            }
                            context.goNamed(HomeScreen.routeName);
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
                  Fluttertoast.showToast(msg: "${result.errorMessage}");
                }
              },
              text: "다음",
            ),
          ],
        ),
      ),
    );
  }
}
