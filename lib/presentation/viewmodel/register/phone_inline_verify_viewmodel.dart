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
  ///
  /// [appSignature] 는 Android SMS Retriever 용 앱 해시 11자다. 서버가 문자 끝에
  /// 그대로 붙이고, 그 해시가 있어야 기기가 우리 앱에 문자를 건넨다.
  /// 비워 보내면 종전처럼 동작한다 — 자동입력만 안 될 뿐이다.
  Future<StateAPI> sendSmsCertCode({
    required String mbrMobilePhone,
    String appSignature = "",
  }) async {
    state = Loading();

    final request = SendSmsCertCodeRequest(
      receiver: mbrMobilePhone,
      appSignature: appSignature,
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
