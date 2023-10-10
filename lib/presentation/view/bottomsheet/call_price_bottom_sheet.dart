import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_text_field.dart';

class CallPriceBottomSheet extends StatefulWidget {
  const CallPriceBottomSheet({
    Key? key,
    required this.minPrice,
    this.initPrice = "",
  }) : super(key: key);

  final int minPrice;
  final String initPrice;

  @override
  State<CallPriceBottomSheet> createState() => _CallPriceBottomSheetState();
}

class _CallPriceBottomSheetState extends State<CallPriceBottomSheet> {
  /// 요금
  final ValueNotifier<int> _price = ValueNotifier<int>(0);

  ValueNotifier<int> get priceNotifier => _price;

  int get price => _price.value;

  set price(int value) {
    _price.value = value;
    _checkErrorMessage();
    _checkIsValid();
  }

  /// 에러 메세지
  final ValueNotifier<String> _errorMessage = ValueNotifier<String>(StringCallPrice.inputGuide1);

  ValueNotifier<String> get errorMessageNotifier => _errorMessage;

  String get errorMessage => _errorMessage.value;

  _setErrorMessage({required String value}) {
    _errorMessage.value = value;
  }

  _checkErrorMessage() {
    String errorMessage;
    if (price == 0) {
      errorMessage = StringCallPrice.inputGuide1;
    } else if (price < widget.minPrice) {
      errorMessage = "${getPrice(widget.minPrice)} ${StringCallPrice.inputGuide2}";
    } else {
      errorMessage = " ";
    }
    _setErrorMessage(value: errorMessage);
  }

  /// 하단 버튼 활성화 여부
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isValidNotifier => _isValid;

  bool get isValid => _isValid.value;

  _setIsValid({required bool value}) {
    _isValid.value = value;
  }

  _checkIsValid() {
    bool valid;
    if (price > 0 && price >= widget.minPrice) {
      valid = true;
    } else {
      valid = false;
    }
    _setIsValid(value: valid);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            /// 상단 타이틀
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// 타이틀
                  Text(
                    widget.initPrice.isEmpty ? StringCallPrice.title : StringCallPrice.titleChange,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Divider(thickness: 1),
                ],
              ),
            ),

            /// 요금
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Text(StringCallPrice.amount),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 요금 입력
                        CustomTextField(
                          text: widget.initPrice,
                          inputType: TextInputType.number,
                          suffixText: StringCommon.won,
                          textAlign: TextAlign.right,
                          onChanged: (value) {
                            debugPrint("======$value");
                            price = value.isEmpty ? 0 : int.parse(value);
                          },
                        ),
                        const SizedBox(height: 8),

                        /// 입력값 에러 표시
                        ValueListenableBuilder(
                          valueListenable: errorMessageNotifier,
                          builder: (context, value, child) {
                            return Text(
                              value,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// 신청 버튼
            ValueListenableBuilder<bool>(
              valueListenable: isValidNotifier,
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: CustomElevatedButton(
                    isEnabled: value,
                    text: StringCallPrice.bottomButton,
                    onPressed: () {
                      context.pop(price);
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
}
