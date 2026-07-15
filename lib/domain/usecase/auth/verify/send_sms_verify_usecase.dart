import 'package:kdmp_cm_app/data/model/auth/send_sms_verify_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/repository/auth/auth_repository.dart';

class SendSmsVerifyUseCase {
  final AuthRepository _authRepository;

  SendSmsVerifyUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<StateAPI> execute({required SendSmsVerifyRequest sendSmsVerifyRequest}) async {
    return await _authRepository.sendSmsVerify(sendSmsVerifyRequest: sendSmsVerifyRequest);
  }
}
