import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/register/register_request.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/login/get_login_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/register/set_register_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/set_jwt_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_onboarding_check_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_firstlogin_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrid_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrpw_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/home/home_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/onboarding/onboarding_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/register/register_car_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/register/phone_verify_viewmodel.dart';

/// 본인인증 화면
class PhoneVerifyScreen extends StatefulWidget {
  const PhoneVerifyScreen({
    Key? key,
    required this.agreeTermList,
  }) : super(key: key);

  static const String routeName = "phone_verify";
  static const String routeURL = "/phone_verify";

  final List<TempAgreeTerm> agreeTermList;

  @override
  State<PhoneVerifyScreen> createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  late final PhoneVerifyViewModel _phoneVerifyViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  void initViewModel() {
    _phoneVerifyViewModel = PhoneVerifyViewModel(
      setRegisterUseCase: GetIt.instance<SetRegisterUseCase>(),
      getLoginUseCase: GetIt.instance<GetLoginUseCase>(),
      setJwtUseCase: GetIt.instance<SetJwtUseCase>(),
      setMbrSqUseCase: GetIt.instance<SetMbrSqUseCase>(),
      setMbrIdUseCase: GetIt.instance<SetMbrIdUseCase>(),
      setMbrPwUseCase: GetIt.instance<SetMbrPwUseCase>(),
      setFirstLoginUseCase: GetIt.instance<SetFirstLoginUseCase>(),
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
            Text("본인인증 WebView\n\n이용약관 목록 개수 : ${widget.agreeTermList.length}"),
            // TODO: 임시 버튼. 본인인증 기능 구현 후 제거
            CustomElevatedButton(
              onPressed: () async {
                /// 회원가입 처리
                /// TODO: mbrNm, mbrDeviceId, mbrCi, mbrMobilePhone 임시값. 본인인증 후 가져와야함
                final mbrNm = "김유현";
                final mbrMobilePhone = "01012341234";
                final mbrCi = "yuhyeon_test_ci23";

                final registerResult = await _phoneVerifyViewModel.register(
                  mbrNm: mbrNm,
                  mbrMobilePhone: mbrMobilePhone,
                  mbrCi: mbrCi,
                  tempAgreeTermList: widget.agreeTermList,
                );

                if (registerResult is Success) {
                  /// 회원가입 - 성공시 처리
                  final registerResponse = registerResult.registerResponse;

                  final password = mbrMobilePhone.substring(mbrMobilePhone.length - 4, mbrMobilePhone.length);

                  /// 로그인 처리
                  final loginResult = await _phoneVerifyViewModel.login(
                    mbrId: registerResponse.mbrId,
                    password: registerResponse.mbrPwd,
                  );

                  if (loginResult is Success) {
                    /// 로그인 - 성공시 처리
                    final loginResponse = loginResult.loginResponse;

                    /// 회원구분
                    switch (loginResponse.mbrPrivilegeTp) {
                      case MbrPrivilegeTp.customer:
                        Fluttertoast.showToast(msg: StringLogin.mbrPrivilegeTpCMMB);
                        return;
                      case MbrPrivilegeTp.admin:
                        Fluttertoast.showToast(msg: StringLogin.mbrPrivilegeTpADMN);
                        return;
                      case MbrPrivilegeTp.driver:
                        {
                          /// 가입상태
                          switch (loginResponse.mbrSt) {
                            case MbrSt.temp:
                              if (loginResponse.mbrCarCount > 0) {
                                /// 홈 화면으로 이동
                                context.goNamed(HomeScreen.routeName);
                              } else {
                                /// 차량등록 화면으로 이동
                                context.goNamed(RegisterCarScreen.routeName);
                              }
                              break;
                            case MbrSt.reject:
                              // 심사 거절이나 기사용 상태
                              break;
                            case MbrSt.registerComplete:
                              // TODO: 이용약관 갱신?
                              final isOnBoardingCheck = await _phoneVerifyViewModel.isOnBoardingCheck();
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
                  } else if (loginResult is Bad) {
                    // TODO: 로그인 - 에러코드 처리
                    switch (loginResult.badResponse.bizErrCode) {
                      case 22001:
                    }
                    Fluttertoast.showToast(msg: StringLogin.loginFail);
                  } else if (loginResult is Fail) {
                    Fluttertoast.showToast(msg: "${loginResult.errorMessage}");
                  }
                } else if (registerResult is Bad) {
                  // TODO: 회원가입 - 에러코드 처리
                  switch (registerResult.badResponse.bizErrCode) {
                    // case 22001:
                  }
                  Fluttertoast.showToast(msg: StringRegister.registerFail);
                } else if (registerResult is Fail) {
                  Fluttertoast.showToast(msg: "${registerResult.errorMessage}");
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
