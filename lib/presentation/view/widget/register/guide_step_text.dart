import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';

class GuideStepText extends StatelessWidget {
  const GuideStepText({
    Key? key,
    required this.isChecked,
    required this.text,
  }) : super(key: key);

  final bool isChecked;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          isChecked ? ImageRegister.iconCheckOn : ImageRegister.iconCheckOff,
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isChecked ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).disabledColor,
              ),
        ),
      ],
    );
  }
}
