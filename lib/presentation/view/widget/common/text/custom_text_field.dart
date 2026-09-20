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
    this.focusNode,
    this.onSubmitted,
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
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputType == TextInputType.number ? [FilteringTextInputFormatter.digitsOnly] : [],
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: onSubmitted,
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
        fillColor: backgroundColor ?? Theme.of(context).cardColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: backgroundColor ?? Theme.of(context).cardColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: backgroundColor ?? Theme.of(context).cardColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      /// 전에는 controller 를 넘기면 onChanged 를 버렸다. 그래서 둘 다 넘긴 화면은
      /// 입력이 바뀌어도 통지를 받지 못했다 (휴대폰 인증번호 6자리 자동 확인)
      onChanged: onChanged,
    );
  }
}
