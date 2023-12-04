import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/payment/kgmobil_billingkey_request.dart';
import 'package:kdmp_cm_app/domain/repository/payment/payment_repository.dart';

class SetKGMobilBillingKeyUseCase {
  final PaymentRepository _paymentRepository;

  SetKGMobilBillingKeyUseCase({required PaymentRepository paymentRepository}) : _paymentRepository = paymentRepository;

  Future<StateAPI> execute({required KGMobilBillingKeyRequest kgMobilBillingKeyRequest}) async {
    return await _paymentRepository.setKGMobilBillingKey(kgMobilBillingKeyRequest: kgMobilBillingKeyRequest);
  }
}
