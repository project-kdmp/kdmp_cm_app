import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    Key? key,
    this.text = "",
    this.hint = " ",
    this.onPressed,
    this.isEnabled = true,
  }) : super(key: key);

  final String text;
  final String hint;
  final Function()? onPressed;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        alignment: Alignment.centerLeft,
        backgroundColor: Theme.of(context).dividerColor,
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 18),
        minimumSize: const Size(double.infinity, double.minPositive),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        disabledBackgroundColor: Theme.of(context).dividerColor,
      ),
      onPressed: isEnabled ? onPressed : null,
      child: text.isEmpty
          ? Text(
              hint,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).disabledColor),
            )
          : Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
    );
  }
}
