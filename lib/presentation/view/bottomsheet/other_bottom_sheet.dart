import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';

/// 더보기 팝업
class OtherBottomSheet extends StatelessWidget {
  const OtherBottomSheet({
    Key? key,
    required this.onDeletePressed,
  }) : super(key: key);

  final Function() onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            /// 상단 타이틀
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),

                  /// 타이틀
                  Text(
                    StringOther.title,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Divider(thickness: 1),
                ],
              ),
            ),

            /// 삭제하기 버튼
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onDeletePressed,
              child: Container(
                width: double.maxFinite,
                height: 50,
                alignment: Alignment.center,
                child: const Text(StringOther.delete),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
