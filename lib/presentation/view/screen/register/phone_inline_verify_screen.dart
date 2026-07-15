import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/verify/send_sms_cert_code_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/verify/send_sms_verify_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_text_field.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/register/phone_inline_verify_viewmodel.dart';

/// 휴대폰 인라인(네이티브) 본인인증 화면
///
/// 인증요청(sendSmsCertCode) → 인증번호 확인(sendSmsVerify) API로 동작합니다.
/// 재시도는 sendSmsCertCode를 재호출하며, 매번 새 reqNo가 발급됩니다.
class PhoneInlineVerifyScreen extends StatefulWidget {
  const PhoneInlineVerifyScreen({
    Key? key,
    this.onVerified,
    this.onTitleTap,
  }) : super(key: key);

  static const String routeName = "phone_inline_verify";
  static const String routeURL = "/phone_inline_verify";

  /// 인증 성공 시 콜백 (mbrNm, mbrMobilePhone)
  /// sendSmsVerify 응답은 인증 성공 여부(result)만 내려주고 이름/CI 등 신원정보는 없습니다.
  final void Function(String mbrNm, String mbrMobilePhone)? onVerified;

  /// 상단 타이틀 영역 탭 콜백 (예: 앱바 N회 탭으로 데모 로그인 진입 등)
  final void Function()? onTitleTap;

  @override
  State<PhoneInlineVerifyScreen> createState() => _PhoneInlineVerifyScreenState();
}

class _PhoneInlineVerifyScreenState extends State<PhoneInlineVerifyScreen> {
  late final PhoneInlineVerifyViewModel _viewModel;

  /// 인증번호 유효시간 (초) - 서버 정책 확정 전 임시값
  static const int _codeValiditySeconds = 180;

  /// 재시도 버튼 비활성화 시간 (초)
  static const int _resendCooldownSeconds = 10;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  /// 인증요청 이후 발급된 요청 식별자
  String? _reqNo;

  /// 인증요청 이후(2단계 뷰 노출 여부)
  bool _isRequested = false;

  /// 인증요청/검증 진행 중 여부 (버튼 중복 클릭 방지)
  bool _isLoading = false;

  /// 재시도 버튼 활성화 여부
  bool _canResend = false;

  Timer? _validityTimer;
  Timer? _resendCooldownTimer;

  int _remainingSeconds = _codeValiditySeconds;

  @override
  void initState() {
    super.initState();
    _viewModel = PhoneInlineVerifyViewModel(
      sendSmsCertCodeUseCase: GetIt.instance<SendSmsCertCodeUseCase>(),
      sendSmsVerifyUseCase: GetIt.instance<SendSmsVerifyUseCase>(),
    );
  }

  @override
  void dispose() {
    _validityTimer?.cancel();
    _resendCooldownTimer?.cancel();
    _nameController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  String get _mbrNm => _nameController.text.trim();

  String get _mbrMobilePhone => _phoneController.text.trim();

  bool _validateInput() {
    if (_mbrNm.isEmpty || _mbrMobilePhone.isEmpty) {
      Fluttertoast.showToast(msg: StringPhoneInlineVerify.nameOrPhoneEmpty);
      return false;
    } else if (_mbrMobilePhone.length < 11) {
      Fluttertoast.showToast(msg: StringPhoneInlineVerify.phoneLengthInvalid);
      return false;
    }
    return true;
  }

  /// 인증요청(1단계 → 2단계) / 재시도 공용
  Future<void> _sendCertCode() async {
    if (_isLoading) return;
    if (!_isRequested && !_validateInput()) return;

    setState(() => _isLoading = true);

    final result = await _viewModel.sendSmsCertCode(
      mbrMobilePhone: _mbrMobilePhone,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result is Success) {
      _reqNo = result.sendSmsCertCodeResponse.reqNo;
      _codeController.clear();
      setState(() => _isRequested = true);
      _startTimers();
    }
    // 실패 시 토스트는 repository에서 이미 처리됨 (Bad/Fail)
  }

  /// 인증번호 확인
  Future<void> _verifyCode(String code) async {
    if (_isLoading) return;
    if (code.trim().length < 6) {
      Fluttertoast.showToast(msg: StringPhoneInlineVerify.codeLengthInvalid);
      return;
    }
    if (_reqNo == null) return;
    if (_remainingSeconds <= 0) {
      Fluttertoast.showToast(msg: StringPhoneInlineVerify.codeExpired);
      return;
    }

    setState(() => _isLoading = true);

    final result = await _viewModel.sendSmsVerify(
      reqNo: _reqNo!,
      certCode: code.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result is Success && result.sendSmsVerifyResponse.result) {
      widget.onVerified?.call(_mbrNm, _mbrMobilePhone);
    } else if (result is Success) {
      // result: false (인증번호 불일치) - 서버가 Bad 대신 Success(result:false)로 내려주는 경우 대비
      Fluttertoast.showToast(msg: StringPhoneInlineVerify.codeInvalid);
    }
    // 그 외 실패 시 토스트는 repository에서 이미 처리됨 (Bad/Fail)
  }

  void _startTimers() {
    _validityTimer?.cancel();
    _resendCooldownTimer?.cancel();

    setState(() {
      _remainingSeconds = _codeValiditySeconds;
      _canResend = false;
    });

    _validityTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _remainingSeconds--);
    });

    var resendRemaining = _resendCooldownSeconds;
    _resendCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      resendRemaining--;
      if (resendRemaining <= 0) {
        timer.cancel();
        setState(() => _canResend = true);
      }
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: GestureDetector(
          onTap: widget.onTitleTap,
          child: BaseAppBar(
            appBar: AppBar(),
            title: StringPhoneInlineVerify.title,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Image.asset(
                  "assets/common/app_logo_light.png",
                  width: 140,
                  height: 140,
                ),
              ),
              const SizedBox(height: 24),

              /// 이름
              Text(
                StringPhoneInlineVerify.nameLabel,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 6),
              CustomTextField(
                controller: _nameController,
                hint: StringPhoneInlineVerify.nameHint,
                isEnabled: !_isRequested,
              ),
              const SizedBox(height: 20),

              /// 휴대폰번호
              Text(
                StringPhoneInlineVerify.phoneLabel,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 6),
              CustomTextField(
                controller: _phoneController,
                hint: StringPhoneInlineVerify.phoneHint,
                maxLength: 11,
                inputType: TextInputType.number,
                isEnabled: !_isRequested,
              ),
              const SizedBox(height: 24),

              if (!_isRequested)
                CustomElevatedButton(
                  text: StringPhoneInlineVerify.requestButton,
                  onPressed: _sendCertCode,
                  isEnabled: !_isLoading,
                  minimumSize: const Size.fromHeight(52),
                ),

              /// ===== 2단계: 인증번호 입력 (인증요청 이후 노출) =====
              if (_isRequested) ...[
                Text(
                  StringPhoneInlineVerify.codeGuide1,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  StringPhoneInlineVerify.codeGuide2,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  StringPhoneInlineVerify.codeLabel,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _codeController,
                        hint: StringPhoneInlineVerify.codeHint,
                        maxLength: 6,
                        inputType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          if (value.length == 6) _verifyCode(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomElevatedButton(
                      text: StringPhoneInlineVerify.resendButton,
                      onPressed: _sendCertCode,
                      isEnabled: _canResend && !_isLoading,
                      minimumSize: const Size(72, 56),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "${StringPhoneInlineVerify.remainingTimePrefix}${_formatTime(_remainingSeconds)}",
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  text: StringPhoneInlineVerify.verifyCompleteButton,
                  onPressed: () => _verifyCode(_codeController.text),
                  isEnabled: !_isLoading,
                  minimumSize: const Size.fromHeight(52),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
