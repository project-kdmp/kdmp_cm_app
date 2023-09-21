import '../../../repository/secure_storage/secure_storage_repository.dart';

class GetMbrIdUseCase {
  final SecureStorageRepository _secureStorageRepository;

  GetMbrIdUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<String> execute() async {
    return await _secureStorageRepository.getMbrId();
  }
}
