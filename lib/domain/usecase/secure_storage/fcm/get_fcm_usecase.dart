import '../../../repository/secure_storage/secure_storage_repository.dart';

class GetFCMUseCase {
  final SecureStorageRepository _secureStorageRepository;

  GetFCMUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<String> execute() async {
    return await _secureStorageRepository.getFCM();
  }
}
