import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/payment/set_toss_billingkey_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/add_payment_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_payment_password_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/register/phone_verify_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_text_field.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/payment/add_payment_management_viewmodel.dart';

/// 결제수단 등록 화면
class AddPaymentManagementScreen extends StatefulWidget {
  const AddPaymentManagementScreen({Key? key}) : super(key: key);

  static const String routeName = "add_payment_management";

  @override
  State<AddPaymentManagementScreen> createState() => _AddPaymentManagementScreenState();
}

class _AddPaymentManagementScreenState extends State<AddPaymentManagementScreen> {
  late final AddPaymentManagementViewModel _addPaymentManagementViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  void initViewModel() {
    _addPaymentManagementViewModel = AddPaymentManagementViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getPaymentPasswordUseCase: GetIt.instance<GetPaymentPasswordUseCase>(),
      addPaymentUseCase: GetIt.instance<AddPaymentUseCase>(),
      setTossBillingKeyUseCase: GetIt.instance<SetTossBillingKeyUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: StringSetPaymentManagement.title,
      ),

      /// 화면
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 28),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            StringSetPaymentManagement.payContent1,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            StringSetPaymentManagement.payContent2,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: 30),

                        /// 비밀번호 앞 2자리 입력
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            StringSetPaymentManagement.password,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ValueListenableBuilder<String>(
                          valueListenable: _addPaymentManagementViewModel.passwordNotifier,
                          builder: (context, value, _) {
                            return CustomTextField(
                              isPassword: true,
                              maxLength: 2,
                              inputType: TextInputType.number,
                              hint: StringSetPaymentManagement.passwordHint,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {
                                _addPaymentManagementViewModel.password = value;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        /// CVC 입력
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            StringSetPaymentManagement.cvc,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ValueListenableBuilder<String>(
                          valueListenable: _addPaymentManagementViewModel.cvcNotifier,
                          builder: (context, value, _) {
                            return CustomTextField(
                              isPassword: true,
                              maxLength: 3,
                              inputType: TextInputType.number,
                              hint: StringSetPaymentManagement.cvcHint,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {
                                _addPaymentManagementViewModel.cvc = value;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        /// 유효기간 입력
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            StringSetPaymentManagement.mmyy,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 6),

                        ValueListenableBuilder<String>(
                          valueListenable: _addPaymentManagementViewModel.mmyyNotifier,
                          builder: (context, value, _) {
                            return CustomTextField(
                              isPassword: true,
                              maxLength: 4,
                              inputType: TextInputType.number,
                              hint: StringSetPaymentManagement.mmyyHint,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {
                                _addPaymentManagementViewModel.mmyy = value;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        /// 카드번호 입력
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            StringSetPaymentManagement.card,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Row(
                          children: [
                            /// 카드번호1
                            ValueListenableBuilder<String>(
                              valueListenable: _addPaymentManagementViewModel.card1Notifier,
                              builder: (context, value, _) {
                                return Expanded(
                                  child: CustomTextField(
                                    maxLength: 4,
                                    inputType: TextInputType.number,
                                    hint: StringSetPaymentManagement.cardHint,
                                    textAlign: TextAlign.center,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (value) {
                                      _addPaymentManagementViewModel.card1 = value;
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),

                            /// 카드번호2
                            ValueListenableBuilder<String>(
                              valueListenable: _addPaymentManagementViewModel.card2Notifier,
                              builder: (context, value, _) {
                                return Expanded(
                                  child: CustomTextField(
                                    maxLength: 4,
                                    inputType: TextInputType.number,
                                    hint: StringSetPaymentManagement.cardHint,
                                    textAlign: TextAlign.center,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (value) {
                                      _addPaymentManagementViewModel.card2 = value;
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),

                            /// 카드번호3
                            ValueListenableBuilder<String>(
                              valueListenable: _addPaymentManagementViewModel.card3Notifier,
                              builder: (context, value, _) {
                                return Expanded(
                                  child: CustomTextField(
                                    isPassword: true,
                                    maxLength: 4,
                                    inputType: TextInputType.number,
                                    hint: StringSetPaymentManagement.cardHint,
                                    textAlign: TextAlign.center,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (value) {
                                      _addPaymentManagementViewModel.card3 = value;
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),

                            /// 카드번호4
                            ValueListenableBuilder<String>(
                              valueListenable: _addPaymentManagementViewModel.card4Notifier,
                              builder: (context, value, _) {
                                return Expanded(
                                  child: CustomTextField(
                                    isPassword: true,
                                    maxLength: 4,
                                    inputType: TextInputType.number,
                                    hint: StringSetPaymentManagement.cardHint,
                                    textAlign: TextAlign.center,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (value) {
                                      _addPaymentManagementViewModel.card4 = value;
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        /// 카드별칭 입력
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            StringSetPaymentManagement.cardNm,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 6),

                        ValueListenableBuilder<String>(
                          valueListenable: _addPaymentManagementViewModel.paymentNmNotifier,
                          builder: (context, value, _) {
                            return CustomTextField(
                              hint: StringSetPaymentManagement.cardNmHint,
                              onChanged: (value) {
                                _addPaymentManagementViewModel.paymentNm = value;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// 하단 버튼
            ValueListenableBuilder<bool>(
              valueListenable: _addPaymentManagementViewModel.isValidNotifier,
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: CustomElevatedButton(
                    isEnabled: value,
                    text: StringSetPaymentManagement.bottomButton,
                    onPressed: () async {
                      /// 본인인증 화면으로 이동
                      final identityNumber = await context.pushNamed(PhoneVerifyScreen.routeName);
                      if (identityNumber is String && identityNumber.length == 6) {
                        /// 본인인증 성공

                        // /// 결제 비밀번호 설정 여부 확인
                        // if (!await _addPaymentManagementViewModel.isSetPaymentPassword()) {
                        //   /// 결제 비밀번호 설정 화면으로 이동
                        //   final passwordResult = await context.pushNamed(SetPaymentPasswordScreen.routeName);
                        //   if (passwordResult == true) {
                        //     /// 결제 비밀번호 설정 성공
                        //   } else {
                        //     return;
                        //   }
                        // }

                        /// 결제수단 등록
                        final addResult = await _addPaymentManagementViewModel.addPayment(identityNumber: identityNumber);
                        if (addResult is Success) {
                          /// 결제수단 등록 성공 팝업
                          await _showAlertDialog(content: StringPaymentManagement.paymentAddSuccess, isCanceled: false);

                          /// 화면 닫기
                          context.pop(true);
                        }
                      } else {
                        /// 본인인증 실패
                      }
                    },
                  ),
                );
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
}
