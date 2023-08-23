import 'package:flutter/material.dart';

import '../../../../../data/constant/text/common.dart';
import '../../../../../data/constant/text/terms.dart';
import '../../../widget/common/button/custom_animated_button.dart';

/// 위치 서비스 이용약관 상세 화면
class TermsLocationScreen extends StatelessWidget {
  const TermsLocationScreen({Key? key}) : super(key: key);

  static const String routeName = "termsLocation";
  static const String routeURL = "/termsLocation";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /// 상단 앱바
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          termsForLocation,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      /// 화면
      body: SafeArea(
        child: Column(
          children: [
            // TODO : 나중에 여기에 상세 이용약관 추가해주세요
            /// 상세 위치 서비스 이용약관 본문
            const Expanded(
              child: Text(
                "나중에 여기에 상세 이용약관 추가해주세요",
              ),
            ),

            /// 하단 버튼
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomAnimatedButton(
                text: agree,
                onPressed: () {
                  if (context.mounted) Navigator.pop(context, true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
