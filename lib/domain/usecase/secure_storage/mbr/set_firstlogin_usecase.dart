import '../../../repository/secure_storage/secure_storage_repository.dart';

class SetFirstLoginUseCase {
  final SecureStorageRepository _secureStorageRepository;

  SetFirstLoginUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required bool isFirstLogin}) async {
    await _secureStorageRepository.setFirstLogin(isFirstLogin: isFirstLogin);
  }
}
