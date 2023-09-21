import '../../../repository/secure_storage/secure_storage_repository.dart';

class GetMbrPwUseCase {
  final SecureStorageRepository _secureStorageRepository;

  GetMbrPwUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<String> execute() async {
    return await _secureStorageRepository.getMbrPw();
  }
}
