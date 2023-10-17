import 'package:kdmp_cm_app/data/model/payment/payment_model.dart';

import '../../../repository/secure_storage/secure_storage_repository.dart';

class AddPaymentUseCase {
  final SecureStorageRepository _secureStorageRepository;

  AddPaymentUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required Payment payment}) async {
    final paymentList = await _secureStorageRepository.getPaymentList();
    int paymentSq = payment.paymentSq;
    if (paymentSq == 0) {
      for (int i = 0; i < paymentList.length; i++) {
        int lastSq = paymentList[i].paymentSq;
        if (paymentSq < lastSq) {
          paymentSq = lastSq + 1;
        }
      }
      payment.paymentSq = paymentSq;
    }
    paymentList.add(payment);
    await _secureStorageRepository.setPaymentList(paymentList: paymentList);
  }
}
