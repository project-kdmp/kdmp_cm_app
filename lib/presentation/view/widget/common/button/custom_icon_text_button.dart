import 'package:flutter/material.dart';

class CustomIconTextButton extends StatelessWidget {
  const CustomIconTextButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.margin,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final Function() onPressed;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          elevation: 0.0,
          padding: EdgeInsets.zero,
          minimumSize: const Size(double.minPositive, double.minPositive),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).textTheme.bodyMedium?.color),
            const SizedBox(width: 4),
            Text(text, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
