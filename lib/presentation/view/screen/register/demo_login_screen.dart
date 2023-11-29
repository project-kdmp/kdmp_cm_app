import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/login/get_login_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_token_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/fcm/get_fcm_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_user_data_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_onboarding_check_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_user_data_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/home/home_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/onboarding/onboarding_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/register/no_permission_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/register/register_car_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/cm_term_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_text_field.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/register/demo_login_viewmodel.dart';

/// 데모 계정 로그인 화면
class DemoLoginScreen extends StatefulWidget {
  const DemoLoginScreen({Key? key}) : super(key: key);

  static const String routeName = "demo_login";
  static const String routeURL = "/demo_login";

  @override
  State<DemoLoginScreen> createState() => _DemoLoginScreenState();
}

class _DemoLoginScreenState extends State<DemoLoginScreen> {
  late final DemoLoginViewModel _demoLoginViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  void initViewModel() {
    _demoLoginViewModel = DemoLoginViewModel(
      getLoginUseCase: GetIt.instance<GetLoginUseCase>(),
      setUserDataUseCase: GetIt.instance<SetUserDataUseCase>(),
      getOnBoardingCheckUseCase: GetIt.instance<GetOnBoardingCheckUseCase>(),
      getFCMUseCase: GetIt.instance<GetFCMUseCase>(),
      setFCMTokenUseCase: GetIt.instance<SetFCMTokenUseCase>(),
      deleteUserDataUseCase: GetIt.instance<DeleteUserDataUseCase>(),
    );
  }

  String mbrId = "";
  String mbrPw = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: "데모 계정 로그인",
        backButtonVisible: false,
      ),

      /// 화면
      body: SafeArea(
        child: Column(
          children: [
            CustomTextField(hint: "아이디 입력", onChanged: (value) => mbrId = value, text: mbrId),
            CustomTextField(hint: "비밀번호 입력", onChanged: (value) => mbrPw = value, text: mbrPw),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomElevatedButton(
                onPressed: () async {
                  if (mbrId.trim().isEmpty) {
                    Fluttertoast.showToast(msg: "데모 계정 아이디를 입력해주세요.\nPlease enter your demo account ID.");
                    return;
                  }
                  if (mbrPw.trim().isEmpty) {
                    Fluttertoast.showToast(msg: "데모 계정 비밀번호를 입력해주세요.\nPlease enter your demo account password.");
                    return;
                  }

                  /// 로그인 처리
                  final loginResult = await _demoLoginViewModel.login(
                    mbrId: mbrId,
                    mbrPw: mbrPw,
                  );

                  if (loginResult is Success) {
                    /// 로그인 - 성공시 처리
                    final loginResponse = loginResult.loginResponse;

                    /// 회원구분
                    switch (loginResponse.mbrPrivilegeTp) {
                      case MbrPrivilegeTp.driver:
                        _demoLoginViewModel.logout();
                        await _showAlertDialog(content: StringLogin.mbrPrivilegeTpDMMB, isCanceled: false);
                        SystemNavigator.pop();
                        return;
                      case MbrPrivilegeTp.admin:
                        _demoLoginViewModel.logout();
                        await _showAlertDialog(content: StringLogin.mbrPrivilegeTpADMN, isCanceled: false);
                        SystemNavigator.pop();
                        return;
                      case MbrPrivilegeTp.customer:
                        {
                          /// 이용정지 회원 체크
                          if (loginResponse.serviceYn != "Y") {
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
                                await context.pushNamed(RegisterCarScreen.routeName);
                              }

                              /// 이용약관 갱신 여부 확인
                              if (loginResponse.bagreeTrmUpdate) {
                                /// 미동의 필수 약관 갱신 필요
                                await context.pushNamed(CMTermScreen.routeName);
                              }

                              /// 필수 약관 모두 동의
                              final isOnBoardingCheck = await _demoLoginViewModel.isOnBoardingCheck();
                              if (!isOnBoardingCheck) {
                                await context.pushNamed(OnBoardingScreen.routeName);
                              }
                              context.goNamed(HomeScreen.routeName);
                              break;
                            case MbrSt.withdrawal:
                              _demoLoginViewModel.logout();
                              await _showAlertDialog(content: StringLogin.mbrStW, isCanceled: false);
                              SystemNavigator.pop();
                              break;
                            case MbrSt.registerDormant:
                              _demoLoginViewModel.logout();
                              await _showAlertDialog(content: StringLogin.mbrStD, isCanceled: false);
                              SystemNavigator.pop();
                              break;
                          }
                        }
                        break;
                      default:
                        _demoLoginViewModel.logout();
                        await _showAlertDialog(content: StringLogin.mbrPrivilegeTpUNKNOWN, isCanceled: false);
                        SystemNavigator.pop();
                    }
                  }
                },
                text: "확인",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "이 화면은 데모 계정 로그인을 위한 화면입니다.\nThis screen is for logging in to your demo account.",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.red),
              ),
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
