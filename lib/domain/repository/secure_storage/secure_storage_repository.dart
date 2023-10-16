abstract class SecureStorageRepository {
  Future<String> getJwt();

  Future<void> setJwt({required String jwt});

  Future<void> deleteJwt();

  Future<String> getAutoRefresh();

  Future<void> setAutoRefresh({required String autoRefresh});

  Future<void> deleteAutoRefresh();

  Future<int> getMbrSq();

  Future<void> setMbrSq({required int mbrSq});

  Future<void> deleteMbrSq();

  Future<String> getMbrId();

  Future<void> setMbrId({required String mbrId});

  Future<void> deleteMbrId();

  Future<String> getMbrPw();

  Future<void> setMbrPw({required String mbrPw});

  Future<void> deleteMbrPw();

  Future<String> getFCM();

  Future<void> setFCM({required String fcm});

  Future<void> deleteFCM();

  Future<void> setThemeMode({required String themeMode});

  Future<String> getThemeMode();

  Future<bool> getFirstLogin();

  Future<void> setFirstLogin({required bool isFirstLogin});

  Future<void> deleteFirstLogin();

  Future<bool> getOnBoardingCheck();

  Future<void> setOnBoardingCheck({required bool isOnBoardingCheck});

  Future<void> deleteOnBoardingCheck();

  Future<String> getPaymentPassword();

  Future<void> setPaymentPassword({required String paymentPassword});

  Future<void> deletePaymentPassword();
}
