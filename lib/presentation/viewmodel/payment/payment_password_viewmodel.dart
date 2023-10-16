import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_payment_password_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';

class PaymentPasswordViewModel {
  PaymentPasswordViewModel({
    required this.getPaymentPasswordUseCase,
  });

  final GetPaymentPasswordUseCase getPaymentPasswordUseCase;

  /// 결제 비밀번호 안내 텍스트
  final ValueNotifier<String> _message = ValueNotifier<String>(StringPaymentPassword.inputPassword);

  ValueNotifier<String> get messageNotifier => _message;

  String get message => _message.value;

  set message(String value) => _message.value = value;

  /// 결제 비밀번호 입력
  final ValueNotifier<String> _inputPassword = ValueNotifier<String>("");

  ValueNotifier<String> get inputPasswordNotifier => _inputPassword;

  String get inputPassword => _inputPassword.value;

  set inputPassword(String value) => _inputPassword.value = value;

  addPasswordChar(int num) {
    if (inputPassword.length < 6) {
      inputPassword += num.toString();
    }
  }

  removePasswordLastChar() {
    if (inputPassword.isNotEmpty) {
      inputPassword = inputPassword.substring(0, inputPassword.length - 1);
    }
  }

  /// 상태
  StateAPI state = Loading();

  /// 결제 비밀번호 확인
  Future<bool> checkPassword() async {
    final password = await getPaymentPasswordUseCase.execute();
    final result = password == inputPassword;
    if (result == false) {
      message = StringPaymentPassword.inputPasswordError;
      inputPassword = "";
    }
    return result;
  }
}
