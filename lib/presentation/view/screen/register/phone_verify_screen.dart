import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/verify/get_verify_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrci_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_text_field.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/register/phone_verify_viewmodel.dart';
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

  @override
  void initState() {
    super.initState();
    initWebViewController();
    initViewModel();
    initLoadUrl();
  }

  /// Create
  void initViewModel() {
    _phoneVerifyViewModel = PhoneVerifyViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getMbrCIUseCase: GetIt.instance<GetMbrCiUseCase>(),
      getVerifyInfoUseCase: GetIt.instance<GetVerifyInfoUseCase>(),
    );
  }

  void initLoadUrl() async {
    final mbrSq = await _phoneVerifyViewModel.getMbrSq();
    _webController.loadRequest(
      Uri.parse(AppConstants.PHONE_VERIFY_URL),
      method: LoadRequestMethod.get,
      body: Uint8List.fromList(
        utf8.encode("mbrSq=$mbrSq"),
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
          final result = await _phoneVerifyViewModel.getVerifyInfo(impUid: impUid);
          if (result is Success) {
            final response = result.verifyResponse;

            final name = response.name ?? "";
            final phone = response.phone ?? "";
            final mbrCi = response.uniqueKey!.isNotEmpty ? response.uniqueKey! : "ci_test_${phone.substring(7, 11)}"; // TODO: null 일 경우 임시값
            final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(response.birth) * 1000);
            final birth = DateFormat("yyMMdd").format(dateTime);
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
      )
      ..setOnConsoleMessage((message) {
        debugPrint("console message: ${message.message}");
      })
      ..clearCache();
  }

  /// ========== TEST 코드, 본인인증 정보 직접 입력 ==========

  String mbrNm = "김유현";
  String mbrMobilePhone = "01087092739";
  String identityNumber = "990907";

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
