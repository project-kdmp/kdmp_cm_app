import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_payment_password_usecase.dart';

class AddPaymentManagementViewModel {
  AddPaymentManagementViewModel({
    required this.getPaymentPasswordUseCase,
  });

  final GetPaymentPasswordUseCase getPaymentPasswordUseCase;

  /// 비밀번호
  final ValueNotifier<String> _password = ValueNotifier<String>("");

  ValueNotifier<String> get passwordNotifier => _password;

  String get password => _password.value;

  set password(String value) {
    _password.value = value;
    _checkIsValid();
  }

  /// CVC
  final ValueNotifier<String> _cvc = ValueNotifier<String>("");

  ValueNotifier<String> get cvcNotifier => _cvc;

  String get cvc => _cvc.value;

  set cvc(String value) {
    _cvc.value = value;
    _checkIsValid();
  }

  /// 유효기간
  final ValueNotifier<String> _mmyy = ValueNotifier<String>("");

  ValueNotifier<String> get mmyyNotifier => _mmyy;

  String get mmyy => _mmyy.value;

  set mmyy(String value) {
    _mmyy.value = value;
    _checkIsValid();
  }

  /// 카드번호1
  final ValueNotifier<String> _card1 = ValueNotifier<String>("");

  ValueNotifier<String> get card1Notifier => _card1;

  String get card1 => _card1.value;

  set card1(String value) {
    _card1.value = value;
    _checkIsValid();
  }

  /// 카드번호2
  final ValueNotifier<String> _card2 = ValueNotifier<String>("");

  ValueNotifier<String> get card2Notifier => _card2;

  String get card2 => _card2.value;

  set card2(String value) {
    _card2.value = value;
    _checkIsValid();
  }

  /// 카드번호3
  final ValueNotifier<String> _card3 = ValueNotifier<String>("");

  ValueNotifier<String> get card3Notifier => _card3;

  String get card3 => _card3.value;

  set card3(String value) {
    _card3.value = value;
    _checkIsValid();
  }

  /// 카드번호4
  final ValueNotifier<String> _card4 = ValueNotifier<String>("");

  ValueNotifier<String> get card4Notifier => _card4;

  String get card4 => _card4.value;

  set card4(String value) {
    _card4.value = value;
    _checkIsValid();
  }

  /// 카드별칭
  final ValueNotifier<String> _cardNm = ValueNotifier<String>("");

  ValueNotifier<String> get cardNmNotifier => _cardNm;

  String get cardNm => _cardNm.value;

  set cardNm(String value) {
    _cardNm.value = value;
    _checkIsValid();
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
    debugPrint("$password, $cvc, $mmyy, $card1$card2$card3$card4, $cardNm");
    if (password.length == 2 && cvc.length == 3 && mmyy.length == 4 && card1.length == 4 && card2.length == 4 && card3.length == 4 && card4.length == 4 && cardNm.isNotEmpty) {
      valid = true;
    } else {
      valid = false;
    }
    _setIsValid(value: valid);
  }

  /// 상태
  StateAPI state = Loading();

  /// 결제 비밀번호 설정 여부
  Future<bool> isSetPaymentPassword() async {
    final password = await getPaymentPasswordUseCase.execute();
    return password.isNotEmpty;
  }
}
