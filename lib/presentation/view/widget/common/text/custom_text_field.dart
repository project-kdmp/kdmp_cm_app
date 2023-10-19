import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.text = "",
    this.hint = " ",
    this.onChanged,
    this.controller,
    this.isPassword = false,
    this.isEnabled = true,
    this.suffixText,
    this.textAlign,
    this.inputType,
    this.maxLength,
    this.maxLines,
    this.isExpands = false,
    this.backgroundColor,
    this.textInputAction,
  }) : super(key: key);

  final String text;
  final String hint;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final bool isPassword;
  final bool isEnabled;
  final String? suffixText;
  final TextAlign? textAlign;
  final TextInputType? inputType;
  final int? maxLength;
  final int? maxLines;
  final bool isExpands;
  final Color? backgroundColor;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputType == TextInputType.number ? [FilteringTextInputFormatter.digitsOnly] : [],
      textInputAction: textInputAction,
      // onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      keyboardType: inputType,
      enabled: isEnabled,
      controller: controller,
      initialValue: controller == null ? text : null,
      style: Theme.of(context).textTheme.bodyLarge,
      obscureText: isPassword,
      textAlign: textAlign ?? TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      maxLength: maxLength,
      maxLines: maxLength != null || isPassword ? 1 : maxLines,
      expands: isExpands,
      decoration: InputDecoration(
        counterText: "",
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        hintText: hint,
        hintStyle: TextStyle(
          color: Theme.of(context).disabledColor,
        ),
        filled: true,
        fillColor: backgroundColor ?? Theme.of(context).dividerColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: backgroundColor ?? Theme.of(context).dividerColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      onChanged: controller == null ? onChanged : null,
    );
  }
}
