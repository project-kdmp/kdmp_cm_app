import 'package:flutter/services.dart';

/// 전화번호 포맷터
/// 입력 받은 숫자를 '010-1234-5678' 포맷으로 변환
class PhoneNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {

    final cleanedText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    String formattedText = '';
    if (cleanedText.isNotEmpty) {

      final rangeOne = cleanedText.length < 3 ? cleanedText.length : 3;
      formattedText = cleanedText.substring(0, rangeOne);

      if (cleanedText.length > 3) {
        final rangeTwo = cleanedText.length < 7 ? cleanedText.length : 7;
        formattedText += '-${cleanedText.substring(3, rangeTwo)}';
      }

      if (cleanedText.length > 7) {
        final rangeThree = cleanedText.length < 11 ? cleanedText.length : 11;
        formattedText += '-${cleanedText.substring(7, rangeThree)}';
      }
    }

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}