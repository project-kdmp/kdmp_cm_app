import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../domain/repository/secure_storage/secure_storage_repository.dart';

class SecureStorageRepositoryImpl extends SecureStorageRepository {

  final _storage = const FlutterSecureStorage();

  /// 로컬에 저장된 JWT 반환
  @override
  Future<String> getJwt() async {
    String jwt = await _storage.read(key: 'jwt') ?? "";
    return jwt;
  }

  /// 로컬에 JWT 저장
  @override
  Future<void> setJwt({required String jwt}) async {
    await _storage.write(key: 'jwt', value: jwt);
  }

  /// 로컬에 저장된 AutoRefresh 반환
  @override
  Future<String> getAutoRefresh() async {
    String autoRefresh = await _storage.read(key: 'autoRefresh') ?? "";
    return autoRefresh;
  }

  /// 로컬에 AutoRefresh 저장
  @override
  Future<void> setAutoRefresh({required String autoRefresh}) async {
    await _storage.write(key: 'autoRefresh', value: autoRefresh);
  }

}