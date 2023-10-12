import 'package:flutter/material.dart';

class CustomTag extends StatelessWidget {
  const CustomTag({
    Key? key,
    required this.text,
    this.color,
    this.margin,
  }) : super(key: key);

  final String text;
  final Color? color;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: margin ?? const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        color: color != null ? color!.withOpacity(0.2) : Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: color!.withOpacity(0.2) ?? Theme.of(context).colorScheme.secondary,
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color ?? Theme.of(context).colorScheme.secondary,
            ),
      ),
    );
  }
}
