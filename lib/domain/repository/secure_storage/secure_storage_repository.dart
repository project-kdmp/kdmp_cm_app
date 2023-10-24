import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/payment/payment_model.dart';

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

  Future<String> getMbrCi();

  Future<void> setMbrCi({required String mbrCi});

  Future<void> deleteMbrCi();

  Future<List<Payment>> getPaymentList();

  Future<void> setPaymentList({required List<Payment> paymentList});

  Future<void> deletePaymentList();

  Future<List<MapData>> getMapDataList();

  Future<void> setMapDataList({required List<MapData> mapDataList});

  Future<void> deleteMapDataList();

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
