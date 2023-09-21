import 'package:flutter/material.dart';

class CustomRoundButton extends StatelessWidget {
  const CustomRoundButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.margin,
    this.textColor,
    this.backgroundColor,
    this.icon,
  }) : super(key: key);

  final String text;
  final Function() onPressed;
  final bool isEnabled;
  final EdgeInsets? margin;
  final Color? textColor;
  final Color? backgroundColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.minPositive, double.minPositive),
          backgroundColor: backgroundColor ?? Theme.of(context).dividerColor,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: isEnabled ? onPressed : null,
        child: Row(
          children: [
            icon != null ? Icon(icon, color: textColor, size: 18) : const SizedBox(),
            SizedBox(width: icon != null ? 4 : 0),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor ?? Theme.of(context).disabledColor),
            ),
          ],
        ),
      ),
    );
  }
}
