import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    Key? key,
    this.text = "",
    this.hint = "",
    this.isPassword = false,
    this.isEnabled = true,
    this.icon,
    this.inputType,
    required this.onSearch,
  }) : super(key: key);

  final String text;
  final String hint;
  final bool isPassword;
  final bool isEnabled;
  final Icon? icon;
  final TextInputType? inputType;
  final Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        TextFormField(
          inputFormatters: inputType == TextInputType.number ? [FilteringTextInputFormatter.digitsOnly] : [],
          textInputAction: TextInputAction.search,
          onFieldSubmitted: onSearch,
          keyboardType: inputType,
          enabled: isEnabled,
          initialValue: text,
          style: Theme.of(context).textTheme.bodyLarge,
          obscureText: isPassword,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 14, bottom: 14, left: 47, right: 20),
            hintText: hint,
            hintStyle: TextStyle(
              color: Theme.of(context).disabledColor,
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(22)),
              borderSide: BorderSide(
                color: Theme.of(context).cardColor,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(22)),
              borderSide: BorderSide(
                color: Theme.of(context).cardColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(22)),
              borderSide: BorderSide(
                color: Theme.of(context).disabledColor,
              ),
            ),
          ),
        ),
        SizedBox(width: 50, child: icon ?? const Icon(Icons.search, size: 24)),
      ],
    );
  }
}
