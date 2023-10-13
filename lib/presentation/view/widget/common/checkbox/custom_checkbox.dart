import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    Key? key,
    required this.isChecked,
    required this.message,
    required this.onPressed,
    this.isBold = false,
  }) : super(key: key);

  final bool isChecked;
  final String message;
  final Function(bool) onPressed;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.6,
          child: Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: isChecked,
            onChanged: (isChecked) {
              onPressed(isChecked == true);
            },
            checkColor: Colors.white,
            side: BorderSide(color: Theme.of(context).dividerColor, width: 9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: isBold ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
