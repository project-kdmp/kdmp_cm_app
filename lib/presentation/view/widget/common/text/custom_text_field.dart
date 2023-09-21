import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.text = "",
    this.hint = "",
    this.onChanged,
    this.controller,
    this.isPassword = false,
    this.isEnabled = true,
    this.suffixText,
    this.textAlign,
    this.inputType,
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        // textInputAction: TextInputAction.next,
        // onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        keyboardType: inputType,
        enabled: isEnabled,
        controller: controller,
        initialValue: controller == null ? text : null,
        style: Theme.of(context).textTheme.bodyLarge,
        obscureText: isPassword,
        textAlign: textAlign ?? TextAlign.start,
        decoration: InputDecoration(
          suffixText: suffixText,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          hintText: hint,
          hintStyle: TextStyle(
            color: Theme.of(context).disabledColor,
          ),
          filled: true,
          fillColor: Theme.of(context).dividerColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor,
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
      ),
    );
  }
}
