import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/payment/payment_model.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_payment_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_payment_list_usecase.dart';

class PaymentManagementViewModel {
  PaymentManagementViewModel({
    required this.getPaymentListUseCase,
    required this.deletePaymentUseCase,
  });

  final GetPaymentListUseCase getPaymentListUseCase;
  final DeletePaymentUseCase deletePaymentUseCase;

  /// 결제수단 리스트
  final ValueNotifier<List<Payment>> _paymentList = ValueNotifier<List<Payment>>(List.empty());

  ValueNotifier<List<Payment>> get paymentListNotifier => _paymentList;

  List<Payment> get paymentList => _paymentList.value;

  set paymentList(List<Payment> value) => _paymentList.value = value;

  /// 선택 결제수단
  final ValueNotifier<Payment?> _currentPayment = ValueNotifier<Payment?>(null);

  ValueNotifier<Payment?> get currentPaymentNotifier => _currentPayment;

  Payment? get currentPayment => _currentPayment.value;

  set currentPayment(Payment? value) => _currentPayment.value = value;

  /// 상태
  StateAPI state = Loading();

  /// 로컬에 저장된 결제수단 리스트 조회
  Future<void> getPaymentList() async {
    final newPaymentList = await getPaymentListUseCase.execute();

    /// 현금결제 결제수단 추가
    newPaymentList.add(Payment(paymentNm: "현금결제", cardId: "CASH"));

    /// 결제수단 추가
    newPaymentList.add(Payment(paymentNm: "+ 신용/체크카드 결제수단 추가", cardId: "ADD"));

    paymentList = newPaymentList;
    currentPayment = paymentList[0];
  }

  /// 로컬에 저장된 결제수단 삭제
  Future<bool> deletePayment() async {
    if (currentPayment == null && currentPayment!.cardId != "CASH" && currentPayment!.cardId != "ADD") {
      return false;
    }
    await deletePaymentUseCase.execute(cardId: currentPayment!.cardId);
    return true;
  }
}
