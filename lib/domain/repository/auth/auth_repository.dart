import 'package:kdmp_cm_app/data/model/auth/verify_request.dart';
import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/auth/login_request.dart';

abstract class AuthRepository {
  Future<StateAPI> login({required LoginRequest loginRequest});

  Future<StateAPI> logout({required DefaultRequest logoutRequest});

  Future<StateAPI> getVerifyInfo({required VerifyRequest verifyRequest});
}
