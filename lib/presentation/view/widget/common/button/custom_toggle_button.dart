import 'dart:math';

import 'package:flutter/material.dart';

class CustomToggleButton extends StatelessWidget {
  const CustomToggleButton({
    Key? key,
    required this.texts,
    required this.selections,
    required this.onPressed,
    this.isEnabled = true,
    this.textSizes,
  }) : super(key: key);

  final List<String> texts;
  final List<bool> selections;
  final Function(int, String) onPressed;
  final bool isEnabled;
  final List<double?>? textSizes;

  @override
  Widget build(BuildContext context) {
    // side padding 20 기준
    final width = (MediaQuery.of(context).size.width - 44) / max(1, texts.length);

    var children = <Widget>[];
    for (int i = 0; i < texts.length; i++) {
      children.add(
        SizedBox(
          width: width,
          child: Center(
            child: Text(
              texts[i],
              style: TextStyle(fontSize: textSizes?[i] ?? Theme.of(context).textTheme.bodyMedium?.fontSize),
            ),
          ),
        ),
      );
    }
    var isSelected = <bool>[];
    for (var value in selections) {
      isSelected.add(value);
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: Theme.of(context).toggleButtonsTheme.borderRadius,
        border: Border.all(color: Theme.of(context).dividerColor, width: 0),
      ),
      child: ToggleButtons(
        onPressed: (index) => onPressed(index, texts[index]),
        isSelected: isSelected,
        children: children,
      ),
    );
  }
}
