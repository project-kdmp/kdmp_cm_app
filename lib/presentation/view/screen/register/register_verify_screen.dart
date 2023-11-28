import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/register/register_request.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/login/get_login_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/verify/get_verify_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_token_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/register/set_register_usecase.dart';
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
import 'package:kdmp_cm_app/presentation/viewmodel/register/register_verify_viewmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  late final WebViewController _webController;

  @override
  void initState() {
    super.initState();
    initWebViewController();
    initViewModel();
    initLoadUrl();
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
      deleteUserDataUseCase: GetIt.instance<DeleteUserDataUseCase>(),
      getVerifyInfoUseCase: GetIt.instance<GetVerifyInfoUseCase>(),
    );
  }

  void initLoadUrl() async {
    _webController.loadRequest(
      Uri.parse(AppConstants.PHONE_VERIFY_URL),
      method: LoadRequestMethod.get,
      body: Uint8List.fromList(
        utf8.encode("mbrSq=0"),
      ),
    );
  }

  void initWebViewController() {
    _webController = WebViewController()
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            debugPrint("onPageStarted > url: $url");
          },
          onPageFinished: (String url) {
            debugPrint("onPageFinished > url: $url");
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("onWebResourceError > error url: ${error.url}");
            debugPrint("onWebResourceError > error code: ${error.errorCode}");
            debugPrint("onWebResourceError > error description: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        "appClose",
        onMessageReceived: (message) async {
          debugPrint("addJavaScriptChannel appClose message: ${message.message}");
          await _showAlertDialog(content: StringPhoneVerify.verifyFail, isCanceled: false);
          initLoadUrl();
        },
      )
      ..addJavaScriptChannel(
        "verifySuccess",
        onMessageReceived: (message) async {
          debugPrint("addJavaScriptChannel verifySuccess message: ${message.message}");
          final impUid = message.message;
          final result = await _registerVerifyViewModel.getVerifyInfo(impUid: impUid);
          if (result is Success) {
            final response = result.verifyResponse;

            final name = response.name ?? "";
            final phone = response.phone ?? "";
            final mbrCi = response.uniqueKey!.isNotEmpty ? response.uniqueKey! : "ci_test_${phone.substring(7, 11)}"; // TODO: null 일 경우 임시값
            final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(response.birth) * 1000);
            final birth = DateFormat("yyMMdd").format(dateTime);
            debugPrint("verifyInfo birth format: $birth");

            final registerResult = await _registerVerifyViewModel.register(
              mbrNm: name,
              mbrMobilePhone: phone,
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
                          final isOnBoardingCheck = await _registerVerifyViewModel.isOnBoardingCheck();
                          if (!isOnBoardingCheck) {
                            await context.pushNamed(OnBoardingScreen.routeName);
                          }
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
            }
          }
        },
      )
      ..setOnConsoleMessage((message) {
        debugPrint("console message: ${message.message}");
      })
      ..clearCache();
  }

  /// ========== TEST 코드, 본인인증 정보 직접 입력 ==========

  String mbrNm = "김유현";
  String mbrMobilePhone = "01087092739";

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
            AppConstants.isDev ? CustomTextField(hint: "이름 입력", onChanged: (value) => mbrNm = value, text: mbrNm) : const SizedBox(),
            AppConstants.isDev ? CustomTextField(hint: "휴대폰번호 입력", maxLength: 11, inputType: TextInputType.number, onChanged: (value) => mbrMobilePhone = value, text: mbrMobilePhone) : const SizedBox(),
            AppConstants.isDev
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomElevatedButton(
                      onPressed: () async {
                        /// 회원가입 처리

                        if (mbrNm.trim().isEmpty || mbrMobilePhone.trim().isEmpty) {
                          Fluttertoast.showToast(msg: "정보를 입력해주세요.");
                          return;
                        } else if (mbrMobilePhone.trim().length < 11) {
                          Fluttertoast.showToast(msg: "휴대폰번호 11자리를 입력해주세요.");
                          return;
                        }

                        final mbrCi = "ci_test_${mbrMobilePhone.substring(7, 11)}";

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
                                      final isOnBoardingCheck = await _registerVerifyViewModel.isOnBoardingCheck();
                                      if (!isOnBoardingCheck) {
                                        await context.pushNamed(OnBoardingScreen.routeName);
                                      }
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
                        }
                      },
                      text: "다음",
                    ),
                  )
                : const SizedBox(),
            AppConstants.isDev
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "위 정보 입력란, 다음 버튼은 본인인증 없이 로그인하기 위한 화면이므로 실제 앱에 적용되지 않습니다.",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.red),
                    ),
                  )
                : const SizedBox(),
            Expanded(child: WebViewWidget(controller: _webController)),
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
