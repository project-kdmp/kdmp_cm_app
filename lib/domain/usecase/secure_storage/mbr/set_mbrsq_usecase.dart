import '../../../repository/secure_storage/secure_storage_repository.dart';

class SetMbrSqUseCase {
  final SecureStorageRepository _secureStorageRepository;

  SetMbrSqUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required int mbrSq}) async {
    await _secureStorageRepository.setMbrSq(mbrSq: mbrSq);
  }
}
