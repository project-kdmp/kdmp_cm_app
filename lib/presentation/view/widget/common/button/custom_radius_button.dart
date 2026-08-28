import 'package:flutter/material.dart';

class CustomRadiusButton extends StatelessWidget {
  const CustomRadiusButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.margin,
    this.textColor,
    this.backgroundColor,
    this.minimumSize,
  }) : super(key: key);

  final String text;
  final Function() onPressed;
  final bool isEnabled;
  final EdgeInsets? margin;
  final Color? textColor;
  final Color? backgroundColor;
  final Size? minimumSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          minimumSize: minimumSize,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          side: BorderSide(
            color: isEnabled ? Theme.of(context).colorScheme.secondary : Theme.of(context).dividerColor,
            width: 1,
          ),
          disabledBackgroundColor: backgroundColor != null ? Theme.of(context).cardColor : Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isEnabled ? textColor ?? Theme.of(context).colorScheme.secondary : Theme.of(context).disabledColor,
          ),
        ),
      ),
    );
  }
}
