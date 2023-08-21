import '../../../../repository/secure_storage/secure_storage_repository.dart';

class SetJwtUseCase {
  final SecureStorageRepository _secureStorageRepository;

  SetJwtUseCase({required SecureStorageRepository secureStorageRepository})
      : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required String jwt}) async {
    /// "Bearer " 제거는 만약을 위해서 붙여놨습니다
    await _secureStorageRepository.setJwt(jwt: jwt.replaceAll("Bearer ", ""));
  }

}