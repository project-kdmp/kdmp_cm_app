import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';

/// 확인 팝업
class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key,
    this.isWarning = false,
    this.title,
    this.content,
    required this.onConfirm,
  }) : super(key: key);

  final bool isWarning;
  final String? title;
  final String? content;
  final Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        actionsPadding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: isWarning ? 18 : 24),

            /// 경고 아이콘
            isWarning ? Image.asset(ImageCommon.iconWarning, width: 46, height: 46) : const SizedBox(),
            isWarning ? const SizedBox(height: 18) : const SizedBox(),

            /// 제목
            title != null ? Text(title!, textAlign: TextAlign.center) : const SizedBox(),
            title != null ? const SizedBox(height: 12) : const SizedBox(),

            /// 내용
            content != null
                ? Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                    decoration: BoxDecoration(
                      // color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(content!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                  )
                : const SizedBox(),

            SizedBox(height: isWarning ? 12 : 18),
          ],
        ),
        actions: [
          CustomElevatedButton(
            text: StringCommon.confirm,
            onPressed: onConfirm,
          ),
        ],
      ),
    );
  }
}
