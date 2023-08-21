import 'auth_response_model.dart';

abstract class AuthState {}

class Loading extends AuthState {}

class Unauthorized extends AuthState {}

class Fail extends AuthState {}

class Success extends AuthState {
  final AuthResponseModel _authResponseModel;
  Success(this._authResponseModel);

  String get getServerVersion => _authResponseModel.serverVersion;
  String get getJwt => _authResponseModel.jwt;
  String get getAutoRefresh => _authResponseModel.autoRefresh;
}
