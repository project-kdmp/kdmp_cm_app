import '../../../repository/secure_storage/secure_storage_repository.dart';

class SetPaymentPasswordUseCase {
  final SecureStorageRepository _secureStorageRepository;

  SetPaymentPasswordUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required String paymentPassword}) async {
    await _secureStorageRepository.setPaymentPassword(paymentPassword: paymentPassword);
  }
}
