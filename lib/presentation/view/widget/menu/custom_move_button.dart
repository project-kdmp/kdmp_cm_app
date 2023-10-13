import 'package:flutter/material.dart';

class CustomMoveButton extends StatelessWidget {
  const CustomMoveButton({
    Key? key,
    required this.text,
    this.content = "",
    this.onPressed,
    this.isEnabled = true,
    this.isArrow = true,
    this.margin,
    this.textColor,
    this.backgroundColor,
    this.minimumSize,
    this.isBold = true,
    this.iconImage,
  }) : super(key: key);

  final String text;
  final String content;
  final Function()? onPressed;
  final bool isEnabled;
  final bool isArrow;
  final EdgeInsets? margin;
  final Color? textColor;
  final Color? backgroundColor;
  final Size? minimumSize;
  final bool isBold;
  final Image? iconImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            padding: margin ?? const EdgeInsets.only(left: 30, right: 16, top: 14, bottom: 14),
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            minimumSize: minimumSize,
            shadowColor: Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              iconImage != null ? iconImage! : const SizedBox(),
              SizedBox(width: iconImage != null ? 16 : 0),
              Text(
                text,
                style: isBold ? Theme.of(context).textTheme.titleLarge?.copyWith(color: textColor) : Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 15),
              Icon(
                isArrow ? Icons.keyboard_arrow_right : null,
                size: 24,
                color: Theme.of(context).iconTheme.color,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
