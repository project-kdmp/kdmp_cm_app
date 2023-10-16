import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_payment_password_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_payment_password_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';

class SetPaymentPasswordViewModel {
  SetPaymentPasswordViewModel({
    required this.setPaymentPasswordUseCase,
  });

  final SetPaymentPasswordUseCase setPaymentPasswordUseCase;

  /// 결제 비밀번호 안내 텍스트
  final ValueNotifier<String> _message = ValueNotifier<String>(StringPaymentPassword.inputNewPassword);

  ValueNotifier<String> get messageNotifier => _message;

  String get message => _message.value;

  set message(String value) => _message.value = value;

  /// 결제 비밀번호 입력
  final ValueNotifier<String> _inputPassword = ValueNotifier<String>("");

  ValueNotifier<String> get inputPasswordNotifier => _inputPassword;

  String get inputPassword => _inputPassword.value;

  set inputPassword(String value) => _inputPassword.value = value;

  Future<bool> addPasswordChar(int num) async {
    if (inputPassword.length < 6) {
      inputPassword += num.toString();
    }
    if (inputPassword.length == 6) {
      if (newPassword.isEmpty) {
        /// 새로운 비밀번호 입력값 저장
        newPassword = inputPassword;
        inputPassword = "";
        message = StringPaymentPassword.inputRePassword;
      } else {
        /// 새로운 비밀번호, 새로운 비밀번호 재입력 값 비교
        if (newPassword == inputPassword) {
          return await setPassword();
        } else {
          inputPassword = "";
          message = StringPaymentPassword.inputPasswordError;
        }
      }
    }
    return false;
  }

  removePasswordLastChar() {
    if (inputPassword.isNotEmpty) {
      inputPassword = inputPassword.substring(0, inputPassword.length - 1);
    }
  }

  /// 새로운 비밀번호
  String newPassword = "";

  /// 상태
  StateAPI state = Loading();

  /// 결제 비밀번호 확인
  Future<bool> setPassword() async {
    await setPaymentPasswordUseCase.execute(paymentPassword: newPassword);
    return true;
  }
}
