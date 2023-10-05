import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';

/// 호출 확인 팝업
class CallConfirmDialog extends StatelessWidget {
  const CallConfirmDialog({
    Key? key,
    this.title,
    required this.content,
    required this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  final String? title;
  final String content;
  final Function() onConfirm;
  final Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      actionsPadding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 12),

          /// 제목
          title != null ? Text(title!, textAlign: TextAlign.center) : const SizedBox(),
          title != null ? const SizedBox(height: 12) : const SizedBox(),

          /// 내용
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
            decoration: BoxDecoration(
              // color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text("$content${StringCall.callContent}", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(height: 12),

          /// 대기료 발생 안내
          SizedBox(
            width: double.maxFinite,
            child: Text(
              StringCall.waitTitle,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              StringCall.waitContent,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomElevatedButton(
                text: StringCommon.cancel,
                backgroundColor: Theme.of(context).cardColor,
                textColor: Theme.of(context).disabledColor,
                onPressed: onCancel != null ? () => onCancel!() : () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomElevatedButton(
                text: StringCommon.confirm,
                onPressed: () => onConfirm(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
