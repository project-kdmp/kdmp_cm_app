import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/auth/login_request.dart';
import 'package:kdmp_cm_app/data/model/fcm/fcm_push_request.dart';
import 'package:kdmp_cm_app/data/model/fcm/fcm_token_request.dart';

abstract class FCMRepository {
  Future<StateAPI> setToken({required FCMTokenRequest fcmTokenRequest});

  Future<StateAPI> sendPush({required FCMPushRequest fcmPushRequest});
}
