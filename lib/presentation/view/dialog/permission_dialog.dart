import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({
    Key? key,
    required this.onConfirm,
    this.onCancel,
  }) : super(key: key);

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
          const SizedBox(height: 18),
          Image.asset(ImageCommon.iconWarning, width: 46, height: 46),
          const SizedBox(height: 18),
          const Text(
            StringPermission.alertTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StringPermission.alertContent1,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).disabledColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  StringPermission.alertContent2,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
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
