import 'package:kdmp_cm_app/data/model/auth/send_sms_cert_code_request.dart';
import 'package:kdmp_cm_app/data/model/auth/send_sms_verify_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/verify/send_sms_cert_code_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/verify/send_sms_verify_usecase.dart';

class PhoneInlineVerifyViewModel {
  PhoneInlineVerifyViewModel({
    required this.sendSmsCertCodeUseCase,
    required this.sendSmsVerifyUseCase,
  });

  final SendSmsCertCodeUseCase sendSmsCertCodeUseCase;
  final SendSmsVerifyUseCase sendSmsVerifyUseCase;

  /// 상태
  StateAPI state = Loading();

  /// 인증번호(SMS) 요청/재전송
  Future<StateAPI> sendSmsCertCode({
    required String mbrMobilePhone,
  }) async {
    state = Loading();

    final request = SendSmsCertCodeRequest(
      receiver: mbrMobilePhone,
    );
    final result = await sendSmsCertCodeUseCase.execute(sendSmsCertCodeRequest: request);
    state = result;

    return result;
  }

  /// 인증번호 확인
  Future<StateAPI> sendSmsVerify({
    required String reqNo,
    required String certCode,
  }) async {
    state = Loading();

    final request = SendSmsVerifyRequest(
      reqNo: reqNo,
      certCode: certCode,
    );
    final result = await sendSmsVerifyUseCase.execute(sendSmsVerifyRequest: request);
    state = result;

    return result;
  }
}
