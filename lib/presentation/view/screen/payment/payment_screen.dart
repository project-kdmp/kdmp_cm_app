import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_payment_password_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/payment/payment_management_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/menu/custom_move_button.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/payment/payment_viewmodel.dart';

/// 결제 관리 화면
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  static const String routeName = "payment";

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final PaymentViewModel _paymentViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  void initViewModel() {
    _paymentViewModel = PaymentViewModel(
      getPaymentPasswordUseCase: GetIt.instance<GetPaymentPasswordUseCase>(),
    );
  }

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
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// 결제수단 관리 버튼
                CustomMoveButton(
                  text: StringPayment.paymentManagement,
                  onPressed: () {
                    context.pushNamed(PaymentManagementScreen.routeName);
                  },
                ),

                // /// 결제 비밀번호 설정 버튼
                // CustomMoveButton(
                //   text: StringPayment.paymentSetPassword,
                //   onPressed: () async {
                //     context.pushNamed(SetPaymentPasswordScreen.routeName);
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
