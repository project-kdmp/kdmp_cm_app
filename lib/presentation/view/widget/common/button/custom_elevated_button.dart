import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.margin,
    this.textColor,
    this.backgroundColor,
    this.enabledBackgroundColor,
    this.minimumSize,
  }) : super(key: key);

  final String text;
  final Function() onPressed;
  final bool isEnabled;
  final EdgeInsets? margin;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? enabledBackgroundColor;
  final Size? minimumSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? backgroundColor ?? Theme.of(context).colorScheme.primary : enabledBackgroundColor ?? Theme.of(context).cardColor,
          minimumSize: minimumSize,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isEnabled ? textColor ?? Colors.white : Theme.of(context).disabledColor,
          ),
        ),
      ),
    );
  }
}
