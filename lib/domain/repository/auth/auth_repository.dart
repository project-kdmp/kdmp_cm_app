import '../../../data/model/auth/auth_request_model.dart';
import '../../../data/model/auth/auth_state.dart';

abstract class AuthRepository {
  Future<AuthState> signIn({required AuthRequestModel authRequestModel});
}
