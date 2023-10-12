import '../../../repository/secure_storage/secure_storage_repository.dart';

class SetFCMUseCase {
  final SecureStorageRepository _secureStorageRepository;

  SetFCMUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required String fcm}) async {
    await _secureStorageRepository.setFCM(fcm: fcm);
  }
}
