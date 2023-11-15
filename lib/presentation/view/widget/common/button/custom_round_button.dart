import 'package:flutter/material.dart';

class CustomRoundButton extends StatelessWidget {
  const CustomRoundButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.margin,
    this.padding,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.icon,
    this.textSize,
  }) : super(key: key);

  final String text;
  final Function() onPressed;
  final bool isEnabled;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final IconData? icon;
  final double? textSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.minPositive, double.minPositive),
          backgroundColor: backgroundColor ?? Theme.of(context).cardColor,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: borderColor ?? Colors.transparent)),
        ),
        onPressed: isEnabled ? onPressed : null,
        child: Row(
          children: [
            icon != null ? Icon(icon, color: textColor, size: 18) : const SizedBox(),
            SizedBox(width: icon != null ? 4 : 0),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor ?? Theme.of(context).disabledColor,
                    fontSize: textSize,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
