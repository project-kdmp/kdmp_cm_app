import '../../../repository/secure_storage/secure_storage_repository.dart';

class GetPaymentPasswordUseCase {
  final SecureStorageRepository _secureStorageRepository;

  GetPaymentPasswordUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<String> execute() async {
    return await _secureStorageRepository.getPaymentPassword();
  }
}
