import '../../../repository/secure_storage/secure_storage_repository.dart';

class SetUserDataUseCase {
  final SecureStorageRepository _secureStorageRepository;

  SetUserDataUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> login({
    required String jwt,
    required String autoRefresh,
    required int mbrSq,
    required String mbrId,
    required String mbrPw,
    required String mbrCi,
    required bool isFirstLogin,
  }) async {
    await _secureStorageRepository.setJwt(jwt: jwt);
    await _secureStorageRepository.setAutoRefresh(autoRefresh: autoRefresh);
    await _secureStorageRepository.setMbrSq(mbrSq: mbrSq);
    await _secureStorageRepository.setMbrId(mbrId: mbrId);
    await _secureStorageRepository.setMbrPw(mbrPw: mbrPw);
    await _secureStorageRepository.setMbrCi(mbrCi: mbrCi);
    await _secureStorageRepository.setFirstLogin(isFirstLogin: isFirstLogin);
  }
  Future<void> autoLogin({
    required String jwt,
    required String autoRefresh,
  }) async {
    await _secureStorageRepository.setJwt(jwt: jwt);
    await _secureStorageRepository.setAutoRefresh(autoRefresh: autoRefresh);
  }
}
