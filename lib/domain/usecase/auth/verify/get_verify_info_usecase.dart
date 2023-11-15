import 'package:kdmp_cm_app/data/model/auth/verify_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/repository/auth/auth_repository.dart';

class GetVerifyInfoUseCase {
  final AuthRepository _authRepository;

  GetVerifyInfoUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<StateAPI> execute({required VerifyRequest verifyRequest}) async {
    return await _authRepository.getVerifyInfo(verifyRequest: verifyRequest);
  }
}
