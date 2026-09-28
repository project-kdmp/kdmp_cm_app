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
    this.icon,
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

  /// 에셋이 없는 항목용. iconImage 와 같은 자리를 같은 크기로 차지한다
  final IconData? icon;

  bool get hasLeading => iconImage != null || icon != null;

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
            crossAxisAlignment: hasLeading ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconImage != null)
                iconImage!
              else if (icon != null)
                Icon(icon, size: 28, color: Theme.of(context).iconTheme.color)
              else
                const SizedBox(),
              SizedBox(width: hasLeading ? 16 : 0),
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
