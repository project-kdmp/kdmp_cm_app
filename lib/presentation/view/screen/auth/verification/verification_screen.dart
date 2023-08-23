import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../../data/constant/text/common.dart';
import '../../../../../data/constant/text/contact.dart';
import '../../../../util/formatter/phone_number_formatter.dart';
import '../../../../viewmodel/auth/verification/verification_viewmodel.dart';
import '../../../../viewmodel/common/timer_viewmodel.dart';
import '../../../widget/common/button/custom_animated_button.dart';
import '../../../widget/common/button/rounded_elevated_button.dart';

/// 휴대폰번호 본인인증 화면
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  static const String routeName = "verification";
  static const String routeURL = "/verification";

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final VerificationViewModel _verificationViewModel = VerificationViewModel();
  final TimerViewModel _timerViewModel = TimerViewModel();

  final TextEditingController _textEditingControllerForPhoneNumber = TextEditingController();
  final TextEditingController _textEditingControllerForVerificationNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// 상단 앱바
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          phoneNumberVerification,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),

      /// 화면
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                phoneNumber,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),

              /// 휴대폰번호 입력 필드
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: _textEditingControllerForPhoneNumber,
                      decoration: const InputDecoration(
                        hintText: writePhoneNumber,
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 1,
                      inputFormatters: [
                        /// 숫자만 허용
                        FilteringTextInputFormatter.digitsOnly,
                        /// 최대 길이 11로 제한
                        LengthLimitingTextInputFormatter(11),
                        /// 전화번호 포맷터
                        PhoneNumberTextInputFormatter(),
                      ],
                      onChanged: (phoneNumber) {
                        /// 입력 받은 번호에서 '-' 및 공백을 제거한 후, 뷰모델에 Set
                        _verificationViewModel.setPhoneNumber(phoneNumber: phoneNumber.replaceAll("-", "").trim());
                      },
                    ),
                    const SizedBox(height: 16),

                    /// 인증번호 전송 버튼
                    ValueListenableBuilder<bool>(
                      valueListenable: _verificationViewModel.isSentVerificationNumberNotifier,
                      builder: (context, isSent, _) {
                        /// 타이머 상태 Observing 을 하기 위해서 전송 버튼 위젯을 isSent true/false 로 분기처리
                        if (isSent) {
                          return ValueListenableBuilder<String>(
                            valueListenable: _timerViewModel.remainingNotifier,
                            builder: (context, value, _) {
                              return RoundedElevatedButton(
                                text: reSendVerificationNumber + value,
                                onPressed: () {
                                  // TODO : 인증번호 전송 로직 구현
                                  _verificationViewModel.setIsSentVerificationNumber(isSent: true);

                                  /// 타이머 시작/재시작
                                  _timerViewModel.startCountdownTimer();
                                },
                              );
                            },
                          );
                        } else {
                          return RoundedElevatedButton(
                            text: sendVerificationNumber,
                            onPressed: () {
                              // TODO : 인증번호 전송 로직 구현
                              _verificationViewModel.setIsSentVerificationNumber(isSent: true);

                              /// 타이머 시작/재시작
                              _timerViewModel.startCountdownTimer();
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    /// 인증번호 입력 필드
                    ValueListenableBuilder<bool>(
                      valueListenable: _verificationViewModel.isSentVerificationNumberNotifier,
                      builder: (context, isSent, _) {
                        if (isSent) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                verificationNumber,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _textEditingControllerForVerificationNumber,
                                decoration: const InputDecoration(
                                  hintText: writeVerificationNumber,
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 1,
                                inputFormatters: [
                                  /// 숫자만 허용
                                  FilteringTextInputFormatter.digitsOnly,
                                  /// 최대 길이 6으로 제한
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                onChanged: (verificationNumber) {
                                  /// 입력 받은 인증번호를 뷰모델에 Set
                                  _verificationViewModel.setVerificationNumber(verificationNumber: verificationNumber.trim());
                                },
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),

              /// 하단 버튼
              ValueListenableBuilder<String>(
                valueListenable:
                    _verificationViewModel.verificationNumberNotifier,
                builder: (context, verificationNumber, _) {
                  return CustomAnimatedButton(
                    text: ok,
                    isEnabled: verificationNumber.length > 5,
                    onPressed: () {
                      // TODO : 소개 이미지 화면으로 이동
                      // context.pushNamed(VerificationScreen.routeName);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
