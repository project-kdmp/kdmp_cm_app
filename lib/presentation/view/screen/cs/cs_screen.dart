import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/cs/inquiry_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/cs/notice_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/menu/custom_move_button.dart';

/// 고객센터 화면
class CSScreen extends StatefulWidget {
  const CSScreen({Key? key}) : super(key: key);

  static const String routeName = "cs";
  static const String routeURL = "/cs";

  @override
  State<CSScreen> createState() => _CSScreenState();
}

class _CSScreenState extends State<CSScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: StringMenu.cs,
      ),

      /// 화면
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// 공지사항 버튼
                CustomMoveButton(
                  text: StringNotice.title,
                  onPressed: () {
                    context.pushNamed(NoticeScreen.routeName);
                  },
                ),

                /// 고객센터 버튼
                CustomMoveButton(
                  text: StringInquiry.title,
                  onPressed: () {
                    context.pushNamed(InquiryScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
