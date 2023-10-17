import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/payment/payment_model.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_payment_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_payment_list_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custon_confirm_dialog.dart';
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
      getPaymentListUseCase: GetIt.instance<GetPaymentListUseCase>(),
      deletePaymentUseCase: GetIt.instance<DeletePaymentUseCase>(),
    );
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
                        /// 화면 닫기, 선택한 결제수단 전달
                        if (_paymentManagementViewModel.currentPayment?.customKey != "ADD") {
                          context.pop(_paymentManagementViewModel.currentPayment);
                        } else {
                          context.pop();
                        }
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
  Widget getPageView(List<Payment> value) {
    return PageView.builder(
      itemCount: value.length,
      controller: PageController(viewportFraction: 0.85),
      onPageChanged: (index) {
        _paymentManagementViewModel.currentPayment = value[index];
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 결제수단 별칭
                    Expanded(
                      child: Text(
                        value[index].paymentNm,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                    ),

                    value[index].customKey != "CASH"
                        ?

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
                          )
                        : const SizedBox(),
                  ],
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
                    value[index].paymentNm,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
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
