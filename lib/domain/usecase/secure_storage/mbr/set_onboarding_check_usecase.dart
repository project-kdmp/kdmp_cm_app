import '../../../repository/secure_storage/secure_storage_repository.dart';

class SetOnBoardingCheckUseCase {
  final SecureStorageRepository _secureStorageRepository;

  SetOnBoardingCheckUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required bool isOnBoardingCheck}) async {
    await _secureStorageRepository.setOnBoardingCheck(isOnBoardingCheck: isOnBoardingCheck);
  }
}
