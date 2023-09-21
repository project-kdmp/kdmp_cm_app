import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/checkbox/custom_checkbox.dart';

class TermCheckBox extends StatelessWidget {
  const TermCheckBox({
    Key? key,
    required this.isChecked,
    required this.message,
    required this.onPressed,
    required this.isMandatory,
    required this.onDetailPressed,
  }) : super(key: key);

  final bool isChecked;
  final String message;
  final bool isMandatory;
  final Function(bool) onPressed;
  final Function onDetailPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onDetailPressed();
      },
      child: Row(
        children: [
          Expanded(
            child: CustomCheckBox(
              isChecked: isChecked,
              message: "(${isMandatory ? "필수" : "선택"}) $message",
              onPressed: (isChecked) {
                onPressed(isChecked == true);
              },
            ),
          ),
          Text(
            StringTerm.detail,
            style: TextStyle(
              color: Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}
