import 'dart:async';

import 'package:flutter/foundation.dart';

/// 타이머 뷰모델
class TimerViewModel {

  /// 인증번호 남은 시간 (String)
  final ValueNotifier<String> _remaining = ValueNotifier<String>("");
  ValueNotifier<String> get remainingNotifier => _remaining;
  String get remaining => _remaining.value;

  _setRemaining({required String value}) {
    _remaining.value = " ($value)";
  }

  void startCountdownTimer({Duration duration = const Duration(minutes: 5)}) {
  // void startCountdownTimer({Duration duration = const Duration(seconds: 5)}) {
    int remainingSeconds = duration.inSeconds;

    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      int minutes = remainingSeconds ~/ 60;
      int seconds = remainingSeconds % 60;
      _setRemaining(value: "$minutes분 $seconds초");
      remainingSeconds--;
      if (remainingSeconds < 0) timer.cancel();
    });
  }

}