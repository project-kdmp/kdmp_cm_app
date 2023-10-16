import '../../../repository/secure_storage/secure_storage_repository.dart';

class DeleteStorageUserDataUseCase {
  final SecureStorageRepository _secureStorageRepository;

  DeleteStorageUserDataUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> logout() async {
    await _secureStorageRepository.deleteJwt();
    await _secureStorageRepository.deleteAutoRefresh();
    await _secureStorageRepository.deleteMbrSq();
    await _secureStorageRepository.deleteMbrId();
    await _secureStorageRepository.deleteMbrPw();
    await _secureStorageRepository.deletePaymentPassword();
    await _secureStorageRepository.deleteFCM();
  }

  Future<void> withdrawal() async {
    await _secureStorageRepository.deleteJwt();
    await _secureStorageRepository.deleteAutoRefresh();
    await _secureStorageRepository.deleteMbrSq();
    await _secureStorageRepository.deleteMbrId();
    await _secureStorageRepository.deleteMbrPw();
    await _secureStorageRepository.deletePaymentPassword();
    await _secureStorageRepository.deleteFCM();
    await _secureStorageRepository.deleteFirstLogin();
    await _secureStorageRepository.deleteOnBoardingCheck();
  }
}
