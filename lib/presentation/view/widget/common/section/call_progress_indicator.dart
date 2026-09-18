import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';

/// 콜 진행 단계 표시 (접수 - 배차 - 운행 - 완료)
///
/// 운행 상태 코드가 14개라 손님이 지금 어느 단계인지 알기 어려우므로 4단계로 접어서 보여준다.
class CallProgressIndicator extends StatelessWidget {
  const CallProgressIndicator({Key? key, required this.drvReqSt}) : super(key: key);

  final String drvReqSt;

  static const List<String> _labels = ["접수", "배차", "운행", "완료"];

  /// 운행 상태 코드를 4단계 중 하나로 접는다. 취소 등 단계로 볼 수 없는 상태는 -1
  static int stepOf(String drvReqSt) {
    switch (drvReqSt) {
      case DrvReqSt.res:
      case DrvReqSt.cal:
        return 0;
      case DrvReqSt.rco:
      case DrvReqSt.cco:
      case DrvReqSt.rwt:
      case DrvReqSt.wat:
        return 1;
      case DrvReqSt.rst:
      case DrvReqSt.sta:
        return 2;
      case DrvReqSt.ren:
      case DrvReqSt.end:
      case DrvReqSt.rcd:
      case DrvReqSt.dcd:
        return 3;
      default:
        return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = stepOf(drvReqSt);

    /// 취소된 콜은 단계를 표시하지 않는다
    if (step < 0) return const SizedBox();

    final activeColor = Theme.of(context).colorScheme.secondary;
    final inactiveColor = Theme.of(context).dividerColor;

    return Row(
      children: List.generate(_labels.length, (index) {
        final isCurrent = index == step;
        final isDone = index <= step;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  /// 왼쪽 연결선 (첫 단계는 비움)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index == 0
                          ? Colors.transparent
                          : (isDone ? activeColor : inactiveColor),
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? activeColor : inactiveColor,
                    ),
                  ),

                  /// 오른쪽 연결선 (마지막 단계는 비움)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index == _labels.length - 1
                          ? Colors.transparent
                          : (index < step ? activeColor : inactiveColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _labels[index],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isCurrent ? activeColor : Theme.of(context).disabledColor,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                    ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
