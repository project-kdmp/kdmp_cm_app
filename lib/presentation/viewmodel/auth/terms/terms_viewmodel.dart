import 'package:flutter/foundation.dart';

/// 이용약관 관련 뷰모델
///
/// 상태는 기본적으로 모두 뷰모델 내부에 위치합니다
/// 뷰모델 외부에선 뷰모델의 Getter/Setter 를 통해서 뷰모델의 상태에 접근합니다
class TermsViewModel {

  /// 서비스 이용약관
  final ValueNotifier<bool> _isAgreeToTerms = ValueNotifier<bool>(false);
  ValueNotifier<bool> get isAgreeToTermsNotifier => _isAgreeToTerms;
  bool get isAgreeToTerms => _isAgreeToTerms.value;

  setIsAgreeToTerms({required bool value}) {
    _isAgreeToTerms.value = value;
    checkIsValid();
  }

  /// 위치 기반 서비스 이용약관
  final ValueNotifier<bool> _isAgreeToLocation = ValueNotifier<bool>(false);
  ValueNotifier<bool> get isAgreeToLocationNotifier => _isAgreeToLocation;
  bool get isAgreeToLocation => _isAgreeToLocation.value;

  setIsAgreeToLocation({required bool value}) {
    _isAgreeToLocation.value = value;
    checkIsValid();
  }

  /// 모든 이용약관
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);
  ValueNotifier<bool> get isValidNotifier => _isValid;
  bool get isValid => _isValid.value;

  _setIsValid({required bool value}) {
    _isValid.value = value;
  }

  checkIsValid() {
    final valid = isAgreeToTerms && isAgreeToLocation;
    _setIsValid(value: valid);
  }

}