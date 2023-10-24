import '../../../repository/secure_storage/secure_storage_repository.dart';

class DeleteUserDataUseCase {
  final SecureStorageRepository _secureStorageRepository;

  DeleteUserDataUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> logout() async {
    await _secureStorageRepository.deleteJwt();
    await _secureStorageRepository.deleteAutoRefresh();
    await _secureStorageRepository.deleteMbrSq();
    await _secureStorageRepository.deleteMbrId();
    await _secureStorageRepository.deleteMbrPw();
    await _secureStorageRepository.deleteMbrCi();
    await _secureStorageRepository.deletePaymentPassword();
    await _secureStorageRepository.deletePaymentList();
    await _secureStorageRepository.deleteMapDataList();
    await _secureStorageRepository.deleteFCM();
  }

  Future<void> withdrawal() async {
    await _secureStorageRepository.deleteJwt();
    await _secureStorageRepository.deleteAutoRefresh();
    await _secureStorageRepository.deleteMbrSq();
    await _secureStorageRepository.deleteMbrId();
    await _secureStorageRepository.deleteMbrPw();
    await _secureStorageRepository.deleteMbrCi();
    await _secureStorageRepository.deletePaymentPassword();
    await _secureStorageRepository.deletePaymentList();
    await _secureStorageRepository.deleteMapDataList();
    await _secureStorageRepository.deleteFCM();
    await _secureStorageRepository.deleteFirstLogin();
    await _secureStorageRepository.deleteOnBoardingCheck();
  }
}
