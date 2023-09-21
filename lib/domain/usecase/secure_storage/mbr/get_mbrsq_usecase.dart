import '../../../repository/secure_storage/secure_storage_repository.dart';

class GetMbrSqUseCase {
  final SecureStorageRepository _secureStorageRepository;

  GetMbrSqUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<int> execute() async {
    return await _secureStorageRepository.getMbrSq();
  }
}
