import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/payment/add_payment_management_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/payment/payment_management_viewmodel.dart';

/// 결제수단 화면
class PaymentManagementScreen extends StatefulWidget {
  const PaymentManagementScreen({
    Key? key,
    this.isPay = false,
  }) : super(key: key);

  final bool isPay;

  static const String routeName = "payment_management";

  @override
  State<PaymentManagementScreen> createState() => _PaymentManagementScreenState();
}

class _PaymentManagementScreenState extends State<PaymentManagementScreen> {
  late final PaymentManagementViewModel _paymentManagementViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _paymentManagementViewModel = PaymentManagementViewModel(
        // getPaymentManagementUseCase: GetIt.instance<GetPaymentManagementUseCase>(),
        );
  }

  void initData() async {
    // TODO: 결제수단 리스트 조회
    // await _paymentManagementViewModel.getPaymentList();
    _paymentManagementViewModel.paymentList = List.from({"신한", "우리"});

    /// 결제수단 추가 버튼
    _paymentManagementViewModel.paymentList = List.from({"+ 신용/체크카드 결제수단 추가"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: widget.isPay ? StringPayment.selectPaymentManagement : StringPayment.paymentManagement,
      ),

      /// 화면
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    /// 결제 정보
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Text(widget.isPay ? StringPaymentManagement.payTitle : StringPaymentManagement.paymentTitle, style: Theme.of(context).textTheme.displaySmall),
                      ),
                    ),
                    const SizedBox(height: 28),

                    ValueListenableBuilder<List<String>>(
                      valueListenable: _paymentManagementViewModel.paymentListNotifier,
                      builder: (context, value, _) {
                        /// 자주 가는 장소 리스트 없음
                        return SizedBox(
                          height: 230,
                          child: value.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(ImageCommon.imgWarning, width: 72, height: 72),
                                    const SizedBox(height: 20),
                                    Text(
                                      StringPlace.noList,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).disabledColor,
                                          ),
                                    )
                                  ],
                                )
                              : getPageView(value),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            /// 하단 버튼
            widget.isPay
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomElevatedButton(
                      text: StringCommon.confirm,
                      onPressed: () async {
                        // TODO: 이전 화면으로 선택한 결제수단 전달
                        context.pop(true);
                      },
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  /// 결제수단 리스트
  Widget getPageView(List<String> value) {
    return PageView.builder(
      itemCount: value.length,
      controller: PageController(viewportFraction: 0.85),
      onPageChanged: (index) {
        _paymentManagementViewModel.current = index;
      },
      itemBuilder: (context, index) {
        return index < value.length - 1
            ? Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                ),
                child: Text(
                  value[index],
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                  textAlign: TextAlign.start,
                ),
              )
            : GestureDetector(
                onTap: () async {
                  /// 결제수단 등록 화면으로 이동
                  final result = await context.pushNamed(AddPaymentManagementScreen.routeName);
                  if (result == true) {
                    /// 결제수단 리스트 갱신
                    initData();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor,
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    value[index],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
      },
    );
  }
}
