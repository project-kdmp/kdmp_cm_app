import '../../../repository/secure_storage/secure_storage_repository.dart';

class DeletePaymentUseCase {
  final SecureStorageRepository _secureStorageRepository;

  DeletePaymentUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required int paymentSq}) async {
    final paymentList = await _secureStorageRepository.getPaymentList();
    for (int i = 0; i < paymentList.length; i++) {
      if (paymentList[i].paymentSq == paymentSq) {
        paymentList.removeAt(i);
      }
    }
    await _secureStorageRepository.setPaymentList(paymentList: paymentList);
  }
}
