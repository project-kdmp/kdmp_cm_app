import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/payment/delete_card_info_request.dart';
import 'package:kdmp_cm_app/data/model/payment/payment_model.dart';
import 'package:kdmp_cm_app/domain/usecase/payment/delete_card_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_payment_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_payment_list_usecase.dart';

class PaymentManagementViewModel {
  PaymentManagementViewModel({
    required this.getMbrSqUseCase,
    required this.getPaymentListUseCase,
    required this.deleteCardInfoUseCase,
    required this.deletePaymentUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetPaymentListUseCase getPaymentListUseCase;
  final DeleteCardInfoUseCase deleteCardInfoUseCase;
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

    // /// 카드가 등록되어있지 않으면
    // if (newPaymentList.length < 2) {
    /// 카드 여러개 등록하도록 개수 제한 없앰
    /// 결제수단 추가
    newPaymentList.add(Payment(paymentNm: "+ 신용/체크카드 결제수단 추가", cardId: "ADD"));
    // }

    paymentList = newPaymentList;
    currentPayment = paymentList[0];
  }

  /// 결제수단 삭제 API
  Future<StateAPI> deletePayment() async {
    if (currentPayment == null && currentPayment!.cardId != "CASH" && currentPayment!.cardId != "ADD") {
      return Fail();
    }
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = DeleteCardInfoRequest(
      mbrSq: mbrSq,
      cardId: currentPayment!.cardId,
    );
    final result = await deleteCardInfoUseCase.execute(deleteCardInfoRequest: request);
    state = result;

    if (result is Success) {
      await _deletePayment();
    }
    return result;
  }

  /// 로컬에 저장된 결제수단 삭제
  Future<void> _deletePayment() async {
    await deletePaymentUseCase.execute(cardId: currentPayment!.cardId);
  }
}
