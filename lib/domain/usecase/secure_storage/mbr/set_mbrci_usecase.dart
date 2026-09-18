import '../../../repository/secure_storage/secure_storage_repository.dart';

class SetMbrCiUseCase {
  final SecureStorageRepository _secureStorageRepository;

  SetMbrCiUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required String mbrCi}) async {
    await _secureStorageRepository.setMbrCi(mbrCi: mbrCi);
  }
}
