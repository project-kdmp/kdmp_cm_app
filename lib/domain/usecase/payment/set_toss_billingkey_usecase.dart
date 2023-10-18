import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/payment/toss_billingkey_request.dart';
import 'package:kdmp_cm_app/domain/repository/payment/payment_repository.dart';

class SetTossBillingKeyUseCase {
  final PaymentRepository _paymentRepository;

  SetTossBillingKeyUseCase({required PaymentRepository paymentRepository}) : _paymentRepository = paymentRepository;

  Future<StateAPI> execute({required TossBillingKeyRequest tossBillingKeyRequest}) async {
    return await _paymentRepository.setTossBillingKey(tossBillingKeyRequest: tossBillingKeyRequest);
  }
}
