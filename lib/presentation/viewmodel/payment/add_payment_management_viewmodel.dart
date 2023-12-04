import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/payment/payment_model.dart';
import 'package:kdmp_cm_app/data/model/payment/kgmobil_billingkey_request.dart';
import 'package:kdmp_cm_app/domain/usecase/payment/set_kgmobil_billingkey_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/add_payment_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_payment_password_usecase.dart';
import 'package:uuid/uuid.dart';

class AddPaymentManagementViewModel {
  AddPaymentManagementViewModel({
    required this.getMbrSqUseCase,
    required this.getPaymentPasswordUseCase,
    required this.setKGMobilBillingKeyUseCase,
    required this.addPaymentUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetPaymentPasswordUseCase getPaymentPasswordUseCase;
  final SetKGMobilBillingKeyUseCase setKGMobilBillingKeyUseCase;
  final AddPaymentUseCase addPaymentUseCase;

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
  final ValueNotifier<String> _paymentNm = ValueNotifier<String>("");

  ValueNotifier<String> get paymentNmNotifier => _paymentNm;

  String get paymentNm => _paymentNm.value;

  set paymentNm(String value) {
    _paymentNm.value = value;
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
    debugPrint("$password, $cvc, $mmyy, $card1$card2$card3$card4, $paymentNm");
    if (password.length == 2 && cvc.length == 3 && mmyy.length == 4 && card1.length == 4 && card2.length == 4 && card3.length == 4 && card4.length == 4 && paymentNm.isNotEmpty) {
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

  /// 결제수단 등록 API
  Future<StateAPI> addPayment({required String identityNumber}) async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();
    // final uuid = const Uuid().v1();

    final request = KGMobilBillingKeyRequest(
      mbrSq: mbrSq,
      aliasNm: paymentNm,
      cardNumber: "$card1$card2$card3$card4",
      cardExpirationYear: "20${mmyy.substring(2, 4)}",
      cardExpirationMonth: mmyy.substring(0, 2),
      // 앞 두 자리만 입력받음
      cardPassword: password,
      customerIdentityNumber: identityNumber,
      // customerKey: uuid,
      breGenerate: false,
    );
    final result = await setKGMobilBillingKeyUseCase.execute(kgMobilBillingKeyRequest: request);
    state = result;

    if (result is Success) {
      final response = result.kgMobilBillingKeyResponse;
      await _addPayment(payment: Payment(paymentNm: paymentNm, cardId: response.cardId));
    }
    return result;
  }

  /// 결제수단 로컬에 저장
  Future<void> _addPayment({required Payment payment}) async {
    await addPaymentUseCase.execute(payment: payment);
  }
}
