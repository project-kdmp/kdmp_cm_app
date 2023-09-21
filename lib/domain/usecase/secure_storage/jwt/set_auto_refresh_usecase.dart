import '../../../repository/secure_storage/secure_storage_repository.dart';

class SetAutoRefreshUseCase {
  final SecureStorageRepository _secureStorageRepository;

  SetAutoRefreshUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required String autoRefresh}) async {
    /// "Bearer " 제거는 만약을 위해서 붙여놨습니다
    await _secureStorageRepository.setAutoRefresh(autoRefresh: autoRefresh);
  }
}
