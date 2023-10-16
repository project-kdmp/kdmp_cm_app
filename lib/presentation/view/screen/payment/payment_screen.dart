import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/presentation/theme/custom_theme_mode.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/menu/custom_move_button.dart';

/// 결제 관리 화면
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  static const String routeName = "pay";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: StringPayment.title,
      ),

      /// 화면
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: SingleChildScrollView(
            child: ValueListenableBuilder<ThemeMode>(
              valueListenable: CustomThemeMode.themeMode,
              builder: (context, themeMode, child) {
                return Column(
                  children: [
                    const SizedBox(height: 20),

                    /// 결제수단 관리 버튼
                    CustomMoveButton(
                      text: StringPayment.paymentManagement,
                      onPressed: () {
                        // context.pushNamed(PaymentManagement.routeName);
                      },
                    ),

                    /// 결제 비밀번호 설정 버튼
                    CustomMoveButton(
                      text: StringPayment.paymentPassword,
                      onPressed: () {
                        // context.pushNamed(PaymentPassword.routeName);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
