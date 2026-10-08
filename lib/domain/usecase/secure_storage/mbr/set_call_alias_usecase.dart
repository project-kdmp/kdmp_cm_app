import '../../../repository/secure_storage/secure_storage_repository.dart';

class SetCallAliasUseCase {
  final SecureStorageRepository _secureStorageRepository;

  SetCallAliasUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required int drvReqSq, required String alias}) async {
    await _secureStorageRepository.setCallAlias(drvReqSq: drvReqSq, alias: alias);
  }
}
