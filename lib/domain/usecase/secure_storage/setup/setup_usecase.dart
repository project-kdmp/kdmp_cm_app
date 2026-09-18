import 'package:kdmp_cm_app/domain/repository/secure_storage/secure_storage_repository.dart';

class SetupUseCase {
  final SecureStorageRepository _secureStorageRepository;

  SetupUseCase({
    required SecureStorageRepository secureStorageRepository,
  }) : _secureStorageRepository = secureStorageRepository;

  Future<String> getThemeMode() async {
    return await _secureStorageRepository.getThemeMode();
  }

  Future<void> setThemeMode({required String themeMode}) async {
    await _secureStorageRepository.setThemeMode(themeMode: themeMode);
  }

  Future<String> getLostChildLastShownDt() async {
    return await _secureStorageRepository.getLostChildLastShownDt();
  }

  Future<void> setLostChildLastShownDt({required String lostChildLastShownDt}) async {
    await _secureStorageRepository.setLostChildLastShownDt(lostChildLastShownDt: lostChildLastShownDt);
  }

  Future<int?> getPendingReviewDrvReqSq() async {
    return await _secureStorageRepository.getPendingReviewDrvReqSq();
  }

  Future<void> setPendingReviewDrvReqSq({required int drvReqSq}) async {
    await _secureStorageRepository.setPendingReviewDrvReqSq(drvReqSq: drvReqSq);
  }

  Future<void> deletePendingReviewDrvReqSq() async {
    await _secureStorageRepository.deletePendingReviewDrvReqSq();
  }

  Future<int> getLostChildHour() async {
    return await _secureStorageRepository.getLostChildHour();
  }

  Future<void> setLostChildHour({required int lostChildHour}) async {
    await _secureStorageRepository.setLostChildHour(lostChildHour: lostChildHour);
  }
}
