import '../../../repository/secure_storage/secure_storage_repository.dart';

class GetAutoRefreshUseCase {
  final SecureStorageRepository _secureStorageRepository;

  GetAutoRefreshUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<String> execute() async {
    return await _secureStorageRepository.getAutoRefresh();
  }
}
