import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/verify/get_verify_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrci_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/device_info_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_text_field.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/register/phone_verify_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 본인인증 화면
class PhoneVerifyScreen extends StatefulWidget {
  const PhoneVerifyScreen({Key? key}) : super(key: key);

  static const String routeName = "phone_verify";
  static const String routeURL = "/phone_verify";

  @override
  State<PhoneVerifyScreen> createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  late final PhoneVerifyViewModel _phoneVerifyViewModel;
  late final WebViewController _webController;

  final GlobalKey webViewKey = GlobalKey();
  late final InAppWebViewController _webViewController;

  /// 디바이스 아이디
  final ValueNotifier<String> _deviceId = ValueNotifier<String>("");

  ValueNotifier<String> get deviceIdNotifier => _deviceId;

  String get deviceId => _deviceId.value;

  set deviceId(String value) {
    _deviceId.value = value;
  }

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _phoneVerifyViewModel = PhoneVerifyViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getMbrCIUseCase: GetIt.instance<GetMbrCiUseCase>(),
      getVerifyInfoUseCase: GetIt.instance<GetVerifyInfoUseCase>(),
    );
  }

  void initData() async {
    deviceId = await getDeviceId();
  }

  /// ========== TEST 코드, 본인인증 정보 직접 입력 ==========

  String mbrNm = "";
  String mbrMobilePhone = "";
  String identityNumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: StringPhoneVerify.title,
      ),

      /// 화면
      body: SafeArea(
        child: Column(
          children: [
            AppConstants.isDev ? CustomTextField(hint: "이름 입력", onChanged: (value) => mbrNm = value, text: mbrNm) : const SizedBox(),
            AppConstants.isDev ? CustomTextField(hint: "휴대폰번호 입력", maxLength: 11, inputType: TextInputType.number, onChanged: (value) => mbrMobilePhone = value, text: mbrMobilePhone) : const SizedBox(),
            AppConstants.isDev ? CustomTextField(hint: "주민번호 앞 6자리 입력", maxLength: 6, inputType: TextInputType.number, onChanged: (value) => identityNumber = value, text: identityNumber) : const SizedBox(),
            AppConstants.isDev
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomElevatedButton(
                      onPressed: () async {
                        /// 본인인증 처리

                        if (mbrNm.trim().isEmpty || mbrMobilePhone.trim().isEmpty || identityNumber.trim().isEmpty) {
                          Fluttertoast.showToast(msg: "정보를 입력해주세요.");
                          return;
                        } else if (mbrMobilePhone.trim().length < 11) {
                          Fluttertoast.showToast(msg: "휴대폰번호 11자리를 입력해주세요.");
                          return;
                        } else if (identityNumber.trim().length < 6) {
                          Fluttertoast.showToast(msg: "주민번호 앞 6자리를 입력해주세요.");
                          return;
                        }

                        final mbrCi = "ci_test_${mbrMobilePhone.substring(7, 11)}";

                        /// 본인확인
                        final registerResult = await _phoneVerifyViewModel.verify(
                          mbrCi: mbrCi,
                        );
                        if (registerResult == true) {
                          /// 본인확인 성공
                          /// 화면 닫기, 주민등록번호 앞 6자리 전달
                          context.pop(identityNumber);
                        } else {
                          /// 본인확인 실패
                          await _showAlertDialog(content: StringPhoneVerify.verifyFail, isCanceled: false);
                          context.pop();
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

            /// WebView
            ValueListenableBuilder(
              valueListenable: deviceIdNotifier,
              builder: (context, value, child) {
                return value.isNotEmpty
                    ? Expanded(
                        child: InAppWebView(
                          key: webViewKey,
                          initialUrlRequest: URLRequest(
                            url: WebUri(AppConstants.PHONE_VERIFY_URL),
                            body: Uint8List.fromList(
                              utf8.encode("deviceId=$value"),
                            ),
                          ),
                          initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(
                              javaScriptCanOpenWindowsAutomatically: true,
                              javaScriptEnabled: true,
                              useOnDownloadStart: true,
                              useOnLoadResource: true,
                              useShouldOverrideUrlLoading: true,
                              mediaPlaybackRequiresUserGesture: true,
                              allowFileAccessFromFileURLs: true,
                              allowUniversalAccessFromFileURLs: true,
                              verticalScrollBarEnabled: true,
                            ),
                            android: AndroidInAppWebViewOptions(
                              useHybridComposition: true,
                              allowContentAccess: true,
                              builtInZoomControls: true,
                              thirdPartyCookiesEnabled: true,
                              allowFileAccess: true,
                              supportMultipleWindows: true,
                            ),
                            ios: IOSInAppWebViewOptions(
                              allowsInlineMediaPlayback: true,
                              allowsBackForwardNavigationGestures: true,
                            ),
                          ),
                          onLoadStart: (InAppWebViewController controller, uri) {
                            debugPrint("onLoadStart: uri=$uri");
                          },
                          onProgressChanged: (controller, progress) {
                            debugPrint("onProgressChanged: progress=${progress.toString()}");
                          },
                          onLoadStop: (InAppWebViewController controller, uri) {
                            debugPrint("onLoadStop: uri=$uri");
                          },
                          onLoadError: (controller, url, code, message) async {
                            debugPrint("onLoadError: url=$url, code=$code, message=$message");
                          },
                          onConsoleMessage: (controller, consoleMessage) {
                            debugPrint("onConsoleMessage: ${consoleMessage.message}");
                          },
                          onWebViewCreated: (InAppWebViewController controller) {
                            /// 엡 브릿지 함수 추가
                            controller.addJavaScriptHandler(
                              handlerName: "verifySuccess",
                              callback: (arguments) async {
                                debugPrint("[APP]verifySuccess: ${arguments.toString()}");

                                if (arguments.isEmpty) {
                                  Fluttertoast.showToast(msg: "전달된 인자값이 없습니다.");
                                  return;
                                }
                                final value = arguments[0];
                                debugPrint("verifySuccess value: $value");

                                final result = await _phoneVerifyViewModel.getVerifyInfo(value: value);
                                if (result is Success) {
                                  final response = result.verifyResponse;

                                  final name = response.name ?? "";
                                  final phone = response.phone ?? "";
                                  final mbrCi = response.uniqueKey!.isNotEmpty ? response.uniqueKey! : "ci_test_${phone.substring(7, 11)}"; // TODO: null 일 경우 임시값
                                  final birth = response.birth.substring(2, 8);
                                  debugPrint("verifyInfo birth format: $birth");

                                  /// 본인확인
                                  final registerResult = await _phoneVerifyViewModel.verify(
                                    mbrCi: mbrCi,
                                  );
                                  if (registerResult == true) {
                                    /// 본인확인 성공
                                    /// 화면 닫기, 주민등록번호 앞 6자리 전달
                                    context.pop(birth);
                                  } else {
                                    /// 본인확인 실패
                                    await _showAlertDialog(content: StringPhoneVerify.verifyFail, isCanceled: false);
                                    context.pop();
                                  }
                                }
                              },
                            );
                          },
                          shouldOverrideUrlLoading: (controller, navigationAction) async {
                            debugPrint("shouldOverrideUrlLoading: ${navigationAction.toString()}");
                            final url = navigationAction.request.url;
                            if (url == null) {
                              return NavigationActionPolicy.CANCEL;
                            }
                            if (isAppLink(url)) {
                              await controller.stopLoading();
                              final scheme = url.scheme;

                              if (scheme == "intent") {
                                if (Platform.isAndroid) {
                                  try {
                                    final String launchUrl = await AppConstants.methodChannel.invokeMethod("getAppUrl", {"url": url.toString()});
                                    if (await canLaunchUrlString(launchUrl)) {
                                      launchUrlString(launchUrl);
                                    } else {
                                      final marketUrl = await AppConstants.methodChannel.invokeMethod("getMarketUrl", {"url": url.toString()});
                                      launchUrlString(marketUrl);
                                    }
                                  } catch (e) {
                                    debugPrint("shouldOverrideUrlLoading: error=$e");
                                  }
                                }
                              } else if (scheme == "market") {
                                if (Platform.isAndroid) {
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    Fluttertoast.showToast(msg: "외부 앱을 실행할 수 없습니다.");
                                  }
                                }
                              } else if (scheme == "tel") {
                                String telUrl = url.toString();
                                if (Platform.isIOS) {
                                  telUrl = telUrl.replaceAll((RegExp(r'-')), "");
                                }
                                if (await canLaunchUrl(Uri.parse(telUrl))) {
                                  await launchUrl(Uri.parse(telUrl));
                                } else {
                                  Fluttertoast.showToast(msg: "외부 앱을 실행할 수 없습니다.");
                                }
                              } else if (scheme == "sms") {
                                String smsUrl = url.toString();
                                if (Platform.isIOS) {
                                  smsUrl = smsUrl.replaceAll((RegExp(r'-')), "");
                                }
                                if (await canLaunchUrl(Uri.parse(smsUrl))) {
                                  await launchUrl(Uri.parse(smsUrl));
                                } else {
                                  Fluttertoast.showToast(msg: "외부 앱을 실행할 수 없습니다.");
                                }
                              }
                              return NavigationActionPolicy.CANCEL;
                            } else {
                              return NavigationActionPolicy.ALLOW;
                            }
                          },
                        ),
                      )
                    : const SizedBox();
              },
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

  /// URL String 의 Scheme 이 http, https 인지 확인
  bool isAppLink(Uri url) {
    final appScheme = url.scheme;
    return appScheme != 'http' && appScheme != 'https' && appScheme != 'about:blank' && appScheme != 'data';
  }
}
