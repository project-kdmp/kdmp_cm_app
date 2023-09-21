import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/repository/auth/auth_repository.dart';

class SetLogoutUseCase {
  final AuthRepository _authRepository;

  SetLogoutUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<StateAPI> execute({required DefaultRequest logoutRequest}) async {
    return await _authRepository.logout(logoutRequest: logoutRequest);
  }
}
