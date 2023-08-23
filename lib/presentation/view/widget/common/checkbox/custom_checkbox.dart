import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    Key? key,
    required this.isChecked,
    required this.message,
    required this.onPressed,
  }) : super(key: key);

  final bool isChecked;
  final String message;
  final Function(bool) onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (isChecked) {
            onPressed(isChecked == true);
          },
        ),
        const SizedBox(height: 16),
        Text(message),

      ],
    );
  }
}