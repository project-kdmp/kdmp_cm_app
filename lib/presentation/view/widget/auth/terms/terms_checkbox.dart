import 'package:flutter/material.dart';

import '../../../../../data/constant/text/common.dart';
import '../../common/custom_checkbox.dart';

class TermsCheckBox extends StatelessWidget {
  const TermsCheckBox({
    Key? key,
    required this.isChecked,
    required this.message,
    required this.onPressed,
    required this.onDetailPressed,
  }) : super(key: key);

  final bool isChecked;
  final String message;
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
              message: message,
              onPressed: (isChecked) {
                onPressed(isChecked == true);
              },
            ),
          ),
          const Text(
            view,
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
