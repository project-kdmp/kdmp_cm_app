import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';

class PaymentManagementViewModel {
  PaymentManagementViewModel(// {
// required this.getPaymentManagementUseCase,
// }
      );

// final GetPaymentManagementUseCase getPaymentManagementUseCase;

  /// 결제수단 리스트
  final ValueNotifier<List<String>> _paymentList = ValueNotifier<List<String>>(List.empty());

  ValueNotifier<List<String>> get paymentListNotifier => _paymentList;

  List<String> get paymentList => _paymentList.value;

  set paymentList(List<String> value) => _paymentList.value = value;

  /// 선택 결제수단
  final ValueNotifier<int> _current = ValueNotifier<int>(0);

  ValueNotifier<int> get currentNotifier => _current;

  int get current => _current.value;

  set current(int value) => _current.value = value;

  /// 상태
  StateAPI state = Loading();
}
