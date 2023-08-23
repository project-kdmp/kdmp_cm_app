import 'package:flutter/foundation.dart';

/// 전화번호 인증 관련 뷰모델
class VerificationViewModel {

  /// 휴대폰번호
  final ValueNotifier<String> _phoneNumber = ValueNotifier<String>("");
  ValueNotifier<String> get phoneNumberNotifier => _phoneNumber;
  String get phoneNumber => _phoneNumber.value;

  setPhoneNumber({required String phoneNumber}) {
    _phoneNumber.value = phoneNumber;
  }

  /// 인증번호 전송
  /// true == 전송함, false == 아직 전송 안함
  final ValueNotifier<bool> _isSentVerificationNumber = ValueNotifier<bool>(false);
  ValueNotifier<bool> get isSentVerificationNumberNotifier => _isSentVerificationNumber;
  bool get isSentVerificationNumber => _isSentVerificationNumber.value;

  setIsSentVerificationNumber({required bool isSent}) {
    _isSentVerificationNumber.value = isSent;
  }

  /// 인증번호
  final ValueNotifier<String> _verificationNumber = ValueNotifier<String>("");
  ValueNotifier<String> get verificationNumberNotifier => _verificationNumber;
  String get verificationNumber => _verificationNumber.value;

  setVerificationNumber({required String verificationNumber}) {
    _verificationNumber.value = verificationNumber;
  }

}