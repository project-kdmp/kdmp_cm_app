import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';

/// 호출취소 사유선택 팝업
class CallCancelDialog extends StatelessWidget {
  CallCancelDialog({
    Key? key,
    required this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  final Function(String drvCancelTp) onConfirm;
  final Function()? onCancel;

  /// 취소사유 유형
  final ValueNotifier<String> _drvCancelTp = ValueNotifier<String>(DrvCancelTp.oths);

  ValueNotifier<String> get drvCancelTpNotifier => _drvCancelTp;

  String get drvCancelTp => _drvCancelTp.value;

  set drvCancelTp(String value) => _drvCancelTp.value = value;

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
          const SizedBox(height: 24),

          /// 제목
          const Text(StringCallCancel.title, textAlign: TextAlign.center),
          const SizedBox(height: 4),

          /// 내용
          Text(StringCallCancel.content, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),

          ValueListenableBuilder<String>(
            valueListenable: drvCancelTpNotifier,
            builder: (context, value, _) {
              return RadioListTile(
                activeColor: Theme.of(context).colorScheme.primary,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  StringCallCancel.typeOTHS,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                value: DrvCancelTp.oths,
                groupValue: value,
                onChanged: (radioValue) {
                  drvCancelTp = radioValue as String;
                },
              );
            },
          ),

          ValueListenableBuilder<String>(
            valueListenable: drvCancelTpNotifier,
            builder: (context, value, _) {
              return RadioListTile(
                activeColor: Theme.of(context).colorScheme.primary,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  StringCallCancel.typeDRVC,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                value: DrvCancelTp.drvc,
                groupValue: value,
                onChanged: (radioValue) {
                  drvCancelTp = radioValue as String;
                },
              );
            },
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
                onPressed: () => onConfirm(drvCancelTp),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
