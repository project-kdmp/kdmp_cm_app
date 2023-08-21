abstract class SecureStorageRepository {
  Future<String> getJwt();
  Future<void> setJwt({required String jwt});
  Future<String> getAutoRefresh();
  Future<void> setAutoRefresh({required String autoRefresh});
}