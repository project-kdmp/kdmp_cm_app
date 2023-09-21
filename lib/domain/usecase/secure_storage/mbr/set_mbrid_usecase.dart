import '../../../repository/secure_storage/secure_storage_repository.dart';

class SetMbrIdUseCase {
  final SecureStorageRepository _secureStorageRepository;

  SetMbrIdUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required String mbrId}) async {
    await _secureStorageRepository.setMbrId(mbrId: mbrId);
  }
}
