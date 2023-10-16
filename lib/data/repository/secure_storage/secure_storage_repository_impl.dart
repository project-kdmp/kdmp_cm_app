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

  /// 로컬에서 JWT 삭제
  @override
  Future<void> deleteJwt() async {
    await _storage.delete(key: 'jwt');
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

  /// 로컬에서 AutoRefresh 삭제
  @override
  Future<void> deleteAutoRefresh() async {
    await _storage.delete(key: 'autoRefresh');
  }

  /// 로컬에 저장된 MbrSq 반환
  @override
  Future<int> getMbrSq() async {
    int mbrSq = int.parse(await _storage.read(key: 'mbrSq') ?? '0');
    return mbrSq;
  }

  /// 로컬에 MbrSq 저장
  @override
  Future<void> setMbrSq({required int mbrSq}) async {
    await _storage.write(key: 'mbrSq', value: mbrSq.toString());
  }

  /// 로컬에서 MbrSq 삭제
  @override
  Future<void> deleteMbrSq() async {
    await _storage.delete(key: 'mbrSq');
  }

  /// 로컬에 저장된 MbrId 반환
  @override
  Future<String> getMbrId() async {
    String mbrId = await _storage.read(key: 'mbrId') ?? '';
    return mbrId;
  }

  /// 로컬에 MbrId 저장
  @override
  Future<void> setMbrId({required String mbrId}) async {
    await _storage.write(key: 'mbrId', value: mbrId.toString());
  }

  /// 로컬에서 MbrId 삭제
  @override
  Future<void> deleteMbrId() async {
    await _storage.delete(key: 'mbrId');
  }

  /// 로컬에 저장된 MbrPw 반환
  @override
  Future<String> getMbrPw() async {
    String mbrPw = await _storage.read(key: 'mbrPw') ?? '';
    return mbrPw;
  }

  /// 로컬에 MbrPw 저장
  @override
  Future<void> setMbrPw({required String mbrPw}) async {
    await _storage.write(key: 'mbrPw', value: mbrPw.toString());
  }

  /// 로컬에서 MbrPw 삭제
  @override
  Future<void> deleteMbrPw() async {
    await _storage.delete(key: 'mbrPw');
  }

  /// 로컬에 저장된 FCM 반환
  @override
  Future<String> getFCM() async {
    String fcm = await _storage.read(key: 'fcm') ?? '';
    return fcm;
  }

  /// 로컬에 FCM 저장
  @override
  Future<void> setFCM({required String fcm}) async {
    await _storage.write(key: 'fcm', value: fcm);
  }

  /// 로컬에서 FCM 삭제
  @override
  Future<void> deleteFCM() async {
    await _storage.delete(key: 'fcm');
  }

  /// 로컬에 '테마' 저장
  @override
  Future<void> setThemeMode({required String themeMode}) async {
    await _storage.write(key: 'themeMode', value: themeMode);
  }

  /// 로컬에 저장된 '테마' 반환
  @override
  Future<String> getThemeMode() async {
    String themeMode = await _storage.read(key: 'themeMode') ?? 'light';
    return themeMode;
  }

  /// 로컬에 저장된 '첫 로그인 여부' 반환
  @override
  Future<bool> getFirstLogin() async {
    String isFirstLogin = await _storage.read(key: 'isFirstLogin') ?? 'true';
    return isFirstLogin == "true";
  }

  /// 로컬에 '첫 로그인 여부' 저장
  @override
  Future<void> setFirstLogin({required bool isFirstLogin}) async {
    await _storage.write(key: 'isFirstLogin', value: "$isFirstLogin");
  }

  /// 로컬에서 '첫 로그인 여부' 삭제
  @override
  Future<void> deleteFirstLogin() async {
    await _storage.delete(key: 'isFirstLogin');
  }

  /// 로컬에 저장된 '온보딩 확인 여부' 반환
  @override
  Future<bool> getOnBoardingCheck() async {
    String isFirstLogin = await _storage.read(key: 'isOnBoardingCheck') ?? 'false';
    return isFirstLogin == "true";
  }

  /// 로컬에 '온보딩 확인 여부' 저장
  @override
  Future<void> setOnBoardingCheck({required bool isOnBoardingCheck}) async {
    await _storage.write(key: 'isOnBoardingCheck', value: "$isOnBoardingCheck");
  }

  /// 로컬에서 '온보딩 확인 여부' 삭제
  @override
  Future<void> deleteOnBoardingCheck() async {
    await _storage.delete(key: 'isOnBoardingCheck');
  }

  /// 로컬에 저장된 '결제 비밀번호' 반환
  @override
  Future<String> getPaymentPassword() async {
    String paymentPassword = await _storage.read(key: 'paymentPassword') ?? '';
    return paymentPassword;
  }

  /// 로컬에 '결제 비밀번호' 저장
  @override
  Future<void> setPaymentPassword({required String paymentPassword}) async {
    await _storage.write(key: 'paymentPassword', value: paymentPassword);
  }

  /// 로컬에서 '결제 비밀번호' 삭제
  @override
  Future<void> deletePaymentPassword() async {
    await _storage.delete(key: 'paymentPassword');
  }
}
