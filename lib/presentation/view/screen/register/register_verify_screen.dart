import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/register/register_request.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/login/get_login_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_token_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/register/set_register_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/fcm/get_fcm_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_onboarding_check_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_user_data_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/home/home_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/onboarding/onboarding_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/register/register_car_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/cm_term_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_text_field.dart';
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

  String mbrNm = "김유현";
  String mbrMobilePhone = "01088889999";
  String mbrCi = "ci8888";

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  void initViewModel() {
    _registerVerifyViewModel = RegisterVerifyViewModel(
      setRegisterUseCase: GetIt.instance<SetRegisterUseCase>(),
      getLoginUseCase: GetIt.instance<GetLoginUseCase>(),
      setUserDataUseCase: GetIt.instance<SetUserDataUseCase>(),
      getOnBoardingCheckUseCase: GetIt.instance<GetOnBoardingCheckUseCase>(),
      getFCMUseCase: GetIt.instance<GetFCMUseCase>(),
      setFCMTokenUseCase: GetIt.instance<SetFCMTokenUseCase>(),
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

            CustomTextField(hint: "이름 입력", onChanged: (value) => mbrNm = value, text: mbrNm),
            CustomTextField(hint: "휴대폰번호 입력", onChanged: (value) => mbrMobilePhone = value, text: mbrMobilePhone),
            CustomTextField(hint: "CI 입력", onChanged: (value) => mbrCi = value, text: mbrCi),

            CustomElevatedButton(
              onPressed: () async {
                /// 회원가입 처리
                /// TODO: mbrNm, mbrDeviceId, mbrCi, mbrMobilePhone 임시값. 본인인증 후 가져와야함
                // final mbrNm = "김민수";
                // final mbrMobilePhone = "01011113334";
                // final mbrCi = "ci_yuhyeon_test2";

                final registerResult = await _registerVerifyViewModel.register(
                  mbrNm: mbrNm,
                  mbrMobilePhone: mbrMobilePhone,
                  mbrCi: mbrCi,
                  tempAgreeTermList: widget.agreeTermList,
                );

                if (registerResult is Success) {
                  /// 회원가입 - 성공시 처리
                  final registerResponse = registerResult.registerResponse;

                  /// 로그인 처리
                  final loginResult = await _registerVerifyViewModel.login(
                    mbrId: registerResponse.mbrId,
                    mbrPw: registerResponse.mbrPwd,
                    mbrCi: mbrCi,
                  );

                  if (loginResult is Success) {
                    /// 로그인 - 성공시 처리
                    final loginResponse = loginResult.loginResponse;

                    /// 회원구분
                    switch (loginResponse.mbrPrivilegeTp) {
                      case MbrPrivilegeTp.driver:
                        await _showAlertDialog(content: StringLogin.mbrPrivilegeTpDMMB, isCanceled: false);
                        SystemNavigator.pop();
                        return;
                      case MbrPrivilegeTp.admin:
                        await _showAlertDialog(content: StringLogin.mbrPrivilegeTpADMN, isCanceled: false);
                        SystemNavigator.pop();
                        return;
                      case MbrPrivilegeTp.customer:
                        {
                          /// 가입상태
                          switch (loginResponse.mbrSt) {
                            case MbrSt.temp:
                              break;
                            case MbrSt.reject: // 심사 거절이나 기사용 상태
                              break;
                            case MbrSt.registerComplete:
                              if (loginResponse.mbrCarCount == 0) {
                                /// 차량등록 화면으로 이동
                                await context.pushNamed(RegisterCarScreen.routeName);
                              }

                              /// 이용약관 갱신 여부 확인
                              if (loginResponse.bagreeTrmUpdate) {
                                /// 미동의 필수 약관 갱신 필요
                                context.goNamed(CMTermScreen.routeName);
                              } else {
                                /// 필수 약관 모두 동의
                                final isOnBoardingCheck = await _registerVerifyViewModel.isOnBoardingCheck();
                                if (!isOnBoardingCheck) {
                                  await context.pushNamed(OnBoardingScreen.routeName);
                                }
                                context.goNamed(HomeScreen.routeName);
                              }
                              break;
                            case MbrSt.withdrawal:
                              await _showAlertDialog(content: StringLogin.mbrStW, isCanceled: false);
                              SystemNavigator.pop();
                              break;
                            case MbrSt.registerDormant:
                              await _showAlertDialog(content: StringLogin.mbrStD, isCanceled: false);
                              SystemNavigator.pop();
                              break;
                          }
                        }
                        break;
                      default:
                        await _showAlertDialog(content: StringLogin.mbrPrivilegeTpUNKNOWN, isCanceled: false);
                        SystemNavigator.pop();
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

  _showAlertDialog({String? title, String? content, bool isWarning = false, bool isCanceled = true}) {
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
