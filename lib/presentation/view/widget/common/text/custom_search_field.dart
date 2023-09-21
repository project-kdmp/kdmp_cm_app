import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    Key? key,
    this.text = "",
    this.hint = "",
    required this.onChanged,
    this.isPassword = false,
    this.isEnabled = true,
  }) : super(key: key);

  final String text;
  final String hint;
  final Function(String) onChanged;
  final bool isPassword;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        TextFormField(
          // textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
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
            fillColor: Theme.of(context).dividerColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(22)),
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(22)),
              borderSide: BorderSide(
                color: Theme.of(context).disabledColor,
              ),
            ),
          ),
          onChanged: (value) => onChanged(value),
        ),
        const SizedBox(width: 50, child: Icon(Icons.search, size: 24)),
      ],
    );
  }
}
