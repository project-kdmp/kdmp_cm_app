import 'package:kdmp_cm_app/data/model/auth/send_sms_cert_code_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/repository/auth/auth_repository.dart';

class SendSmsCertCodeUseCase {
  final AuthRepository _authRepository;

  SendSmsCertCodeUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<StateAPI> execute({required SendSmsCertCodeRequest sendSmsCertCodeRequest}) async {
    return await _authRepository.sendSmsCertCode(sendSmsCertCodeRequest: sendSmsCertCodeRequest);
  }
}
