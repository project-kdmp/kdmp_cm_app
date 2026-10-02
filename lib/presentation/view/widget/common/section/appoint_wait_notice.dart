import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';

/// 지정 호출을 지정 기사가 아직 수락하지 않은 동안, 누구를 기다리는지와 남은 시한을 보여준다.
/// 시한이 지나면 콜이 전체 기사에게 공개되므로 그때부터는 아무것도 그리지 않는다.
class AppointWaitNotice extends StatefulWidget {
  const AppointWaitNotice({
    Key? key,
    required this.driverNm,
    required this.expireDt,
  }) : super(key: key);

  final String driverNm;
  final DateTime? expireDt;

  @override
  State<AppointWaitNotice> createState() => _AppointWaitNoticeState();
}

class _AppointWaitNoticeState extends State<AppointWaitNotice> {
  Timer? _ticker;
  Duration _remain = Duration.zero;

  @override
  void initState() {
    super.initState();
    _restartTicker();
  }

  @override
  void didUpdateWidget(covariant AppointWaitNotice oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// 콜 상세를 다시 조회하면 시한이 새로 내려온다
    if (oldWidget.expireDt != widget.expireDt) _restartTicker();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  /// 남은 시간을 다시 재고, 아직 남아 있으면 1 초마다 줄인다
  void _restartTicker() {
    _ticker?.cancel();
    _remain = _calcRemain();
    if (_remain == Duration.zero) return;

    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final remain = _calcRemain();
      if (remain == Duration.zero) timer.cancel();
      setState(() => _remain = remain);
    });
  }

  Duration _calcRemain() {
    final expireDt = widget.expireDt;
    if (expireDt == null) return Duration.zero;

    final remain = expireDt.difference(DateTime.now());
    return remain.isNegative ? Duration.zero : remain;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.driverNm.isEmpty || _remain == Duration.zero) return const SizedBox();

    final remainText = "${_remain.inMinutes}:${(_remain.inSeconds % 60).toString().padLeft(2, '0')}";

    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            "${StringDriverSelect.waitPrefix} ${widget.driverNm}${StringDriverSelect.waitSuffix} · $remainText",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            StringDriverSelect.waitGuide,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).disabledColor),
          ),
        ],
      ),
    );
  }
}
