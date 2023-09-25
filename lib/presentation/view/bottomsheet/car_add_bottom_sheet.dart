import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_text_field.dart';

/// 차량번호 입력 팝업
class CarAddBottomSheet extends StatelessWidget {
  CarAddBottomSheet({Key? key}) : super(key: key);

  /// 차량번호 네자리
  final ValueNotifier<String> _carNumber = ValueNotifier<String>("");

  ValueNotifier<String> get carNumberNotifier => _carNumber;

  String get carNumber => _carNumber.value;

  set carNumber(String value) {
    _carNumber.value = value;
    _checkErrorMessage();
    _checkIsValid();
  }

  /// 에러 메세지
  final ValueNotifier<String> _errorMessage = ValueNotifier<String>(StringCarAdd.inputGuide1);

  ValueNotifier<String> get errorMessageNotifier => _errorMessage;

  String get errorMessage => _errorMessage.value;

  _setErrorMessage({required String value}) {
    _errorMessage.value = value;
  }

  _checkErrorMessage() {
    String errorMessage;
    if (carNumber.length != 4) {
      errorMessage = StringCarAdd.inputGuide1;
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
    if (carNumber.length == 4) {
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),

                  /// 타이틀
                  Text(
                    StringCarAdd.title,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Divider(thickness: 1),
                ],
              ),
            ),

            /// 차량번호
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Text(StringCarAdd.carNumber),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 차량번호 입력
                        CustomTextField(
                          inputType: TextInputType.number,
                          maxLength: 4,
                          onChanged: (value) {
                            carNumber = value;
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

            /// 확인 버튼
            ValueListenableBuilder<bool>(
              valueListenable: isValidNotifier,
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: CustomElevatedButton(
                    isEnabled: value,
                    text: StringCommon.confirm,
                    onPressed: () {
                      context.pop(carNumber);
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
