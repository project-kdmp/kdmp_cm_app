import '../../../repository/secure_storage/secure_storage_repository.dart';

class GetMbrCiUseCase {
  final SecureStorageRepository _secureStorageRepository;

  GetMbrCiUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<String> execute() async {
    return await _secureStorageRepository.getMbrCi();
  }
}
