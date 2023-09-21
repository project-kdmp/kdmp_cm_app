import '../../../repository/secure_storage/secure_storage_repository.dart';

class GetOnBoardingCheckUseCase {
  final SecureStorageRepository _secureStorageRepository;

  GetOnBoardingCheckUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<bool> execute() async {
    return await _secureStorageRepository.getOnBoardingCheck();
  }
}
