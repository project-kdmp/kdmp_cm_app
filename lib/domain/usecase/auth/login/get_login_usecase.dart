import 'package:kdmp_cm_app/data/model/auth/login_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/repository/auth/auth_repository.dart';

class GetLoginUseCase {
  final AuthRepository _authRepository;

  GetLoginUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<StateAPI> execute({required LoginRequest loginRequest}) async {
    return await _authRepository.login(loginRequest: loginRequest);
  }
}
