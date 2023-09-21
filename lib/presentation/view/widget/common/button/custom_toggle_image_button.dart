import 'dart:math';

import 'package:flutter/material.dart';

class CustomToggleImageButton extends StatelessWidget {
  const CustomToggleImageButton({
    Key? key,
    required this.texts,
    required this.icons,
    required this.selections,
    required this.onPressed,
    this.isEnabled = true,
  }) : super(key: key);

  final List<String> texts;
  final List<Image> icons;
  final List<bool> selections;
  final Function(int, String) onPressed;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    // side padding 20 기준
    final width = (MediaQuery.of(context).size.width - 44) / max(1, texts.length);

    var children = <Widget>[];
    for (int i = 0; i < texts.length; i++) {
      children.add(
        Container(
          padding: const EdgeInsets.all(12),
          width: width,
          child: Column(
            children: [
              icons[i],
              const SizedBox(height: 16),
              Text(texts[i]),
            ],
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
