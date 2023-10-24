import 'package:kdmp_cm_app/data/model/payment/payment_model.dart';

import '../../../repository/secure_storage/secure_storage_repository.dart';

class AddPaymentUseCase {
  final SecureStorageRepository _secureStorageRepository;

  AddPaymentUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required Payment payment}) async {
    final paymentList = await _secureStorageRepository.getPaymentList();
    paymentList.insert(0, payment);
    await _secureStorageRepository.setPaymentList(paymentList: paymentList);
  }
}
