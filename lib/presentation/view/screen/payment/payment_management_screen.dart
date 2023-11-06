import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/payment/payment_model.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_payment_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_payment_list_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/payment/add_payment_management_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/payment/payment_management_viewmodel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initPageController();
    initData();
  }

  /// Create
  void initViewModel() {
    _paymentManagementViewModel = PaymentManagementViewModel(
      getPaymentListUseCase: GetIt.instance<GetPaymentListUseCase>(),
      deletePaymentUseCase: GetIt.instance<DeletePaymentUseCase>(),
    );
  }

  void initPageController() {
    _pageController = PageController(viewportFraction: 0.70);
  }

  void initData() async {
    /// 결제수단 리스트 조회
    await _paymentManagementViewModel.getPaymentList();
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

                    ValueListenableBuilder<List<Payment>>(
                      valueListenable: _paymentManagementViewModel.paymentListNotifier,
                      builder: (context, value, _) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: getPageView(value),
                            ),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: SmoothPageIndicator(
                                controller: _pageController,
                                count: value.length,
                                effect: ScrollingDotsEffect(
                                  activeDotColor: Theme.of(context).colorScheme.secondary,
                                  activeStrokeWidth: 10,
                                  activeDotScale: 1.7,
                                  maxVisibleDots: 5,
                                  radius: 8,
                                  spacing: 14,
                                  dotHeight: 5,
                                  dotWidth: 5,
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            /// 하단 버튼
            widget.isPay
                ? ValueListenableBuilder<Payment?>(
                    valueListenable: _paymentManagementViewModel.currentPaymentNotifier,
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: CustomElevatedButton(
                          text: StringCommon.confirm,
                          isEnabled: value != null && value.cardId != "ADD",
                          onPressed: () async {
                            /// 화면 닫기, 선택한 결제수단 전달
                            if (_paymentManagementViewModel.currentPayment?.cardId != "ADD") {
                              // if (_paymentManagementViewModel.currentPayment?.cardId != "CASH") {
                              //   /// 결제 비밀번호 입력 화면으로 이동
                              //   final result = await context.pushNamed(PaymentPasswordScreen.routeName);
                              //   if (result != true) {
                              //     return;
                              //   }
                              // }
                              context.pop(_paymentManagementViewModel.currentPayment);
                            } else {
                              context.pop();
                            }
                          },
                        ),
                      );
                    },
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  /// 결제수단 리스트
  Widget getPageView(List<Payment> value) {
    return PageView.builder(
      itemCount: value.length,
      controller: _pageController,
      onPageChanged: (index) {
        _paymentManagementViewModel.currentPayment = value[index];
      },
      itemBuilder: (context, index) {
        final cardId = value[index].cardId;
        late final Widget cardWidget;
        if (cardId == "CASH") {
          /// 현금 UI
          cardWidget = Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Text(
                    value[index].paymentNm,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.start,
                  ),
                ),
                Image.asset(ImageCommon.imgMoney, width: 104, height: 104),
              ],
            ),
          );
        } else if (cardId == "ADD") {
          /// 결제수단 추가 UI
          cardWidget = GestureDetector(
            onTap: () async {
              /// 결제수단 등록 화면으로 이동
              final result = await context.pushNamed(AddPaymentManagementScreen.routeName);
              if (result == true) {
                /// 결제수단 리스트 갱신
                initData();

                /// 등록한 결제수단 보이도록 첫번재 페이지로 이동
                _pageController.jumpToPage(0);
              }
            },
            child: Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_rounded, color: Theme.of(context).dividerColor, size: 30),
                  const SizedBox(height: 12),
                  Text(
                    value[index].paymentNm,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else {
          /// 카드 UI
          cardWidget = Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 결제수단 별칭
                Expanded(
                  child: Text(
                    value[index].paymentNm,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ),

                /// 결제수단 삭제 버튼
                GestureDetector(
                  child: const Icon(
                    Icons.close,
                    size: 22,
                    color: Colors.white,
                  ),
                  onTap: () async {
                    /// 결제수단 삭제 확인 팝업
                    final result = await _showConfirmDialog(
                      content: StringPaymentManagement.paymentDeleteConfirm,
                      onConfirm: () async {
                        /// 결제수단 삭제
                        final deleteResult = await _paymentManagementViewModel.deletePayment();
                        context.pop(deleteResult);
                      },
                    );
                    if (result == true) {
                      /// 결제수단 삭제 성공 팝업
                      await _showAlertDialog(content: StringPaymentManagement.paymentDeleteSuccess, isCanceled: false);

                      /// 결제수단 리스트 갱신
                      initData();
                    }
                  },
                ),
              ],
            ),
          );
        }
        return cardWidget;
      },
    );
  }

  _showConfirmDialog({String? title, String? content, bool isWarning = false, required Function() onConfirm}) {
    return showDialog(
      context: context,
      barrierDismissible: true, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CustomConfirmDialog(
          title: title,
          content: content,
          isWarning: isWarning,
          onConfirm: onConfirm,
        );
      },
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
