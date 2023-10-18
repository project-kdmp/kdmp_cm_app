import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrci_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_text_field.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/register/phone_verify_viewmodel.dart';

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

  String mbrNm = "김유현";
  String mbrMobilePhone = "01088889999";
  String mbrCi = "ci8888";
  String identityNumber = "800808";

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  void initViewModel() {
    _phoneVerifyViewModel = PhoneVerifyViewModel(
      getMbrCIUseCase: GetIt.instance<GetMbrCiUseCase>(),
    );
  }

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
            const Text("본인인증 WebView"),
            // TODO: 임시 버튼. 본인인증 기능 구현 후 제거

            CustomTextField(hint: "이름 입력", onChanged: (value) => mbrNm = value, text: mbrNm),
            CustomTextField(hint: "휴대폰번호 입력", onChanged: (value) => mbrMobilePhone = value, text: mbrMobilePhone),
            CustomTextField(hint: "CI 입력", onChanged: (value) => mbrCi = value, text: mbrCi),
            CustomTextField(hint: "주민번호 앞 6자리 입력", maxLength: 6, onChanged: (value) => identityNumber = value, text: identityNumber),

            CustomElevatedButton(
              onPressed: () async {
                /// 본인인증 처리
                /// TODO: mbrNm, mbrDeviceId, mbrCi, mbrMobilePhone 임시값. 본인인증 후 가져와야함
                // final mbrNm = "김민수";
                // final mbrMobilePhone = "01011113334";
                // final mbrCi = "ci_yuhyeon_test2";

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
