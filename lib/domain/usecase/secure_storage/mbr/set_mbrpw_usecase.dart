import '../../../repository/secure_storage/secure_storage_repository.dart';

class SetMbrPwUseCase {
  final SecureStorageRepository _secureStorageRepository;

  SetMbrPwUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required String mbrPw}) async {
    await _secureStorageRepository.setMbrPw(mbrPw: mbrPw);
  }
}
