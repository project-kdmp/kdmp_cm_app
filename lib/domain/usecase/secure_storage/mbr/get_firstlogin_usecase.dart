import '../../../repository/secure_storage/secure_storage_repository.dart';

class GetFirstLoginUseCase {
  final SecureStorageRepository _secureStorageRepository;

  GetFirstLoginUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<bool> execute() async {
    return await _secureStorageRepository.getFirstLogin();
  }
}
