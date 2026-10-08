import '../../../repository/secure_storage/secure_storage_repository.dart';

class GetCallAliasMapUseCase {
  final SecureStorageRepository _secureStorageRepository;

  GetCallAliasMapUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<Map<int, String>> execute() async {
    return await _secureStorageRepository.getCallAliasMap();
  }
}
