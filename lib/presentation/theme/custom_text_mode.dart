import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/presentation/theme/custom_text_data.dart';

class CustomTextMode {
  static final CustomTextMode instance = CustomTextMode._internal();

  static final ValueNotifier<TextMode> textMode = ValueNotifier(TextMode.medium);

  static final ValueNotifier<TextTheme> textTheme = ValueNotifier(CustomTextData.textMediumTheme);

  factory CustomTextMode() => instance;

  static void change(TextMode mTextMode) {
    switch (mTextMode) {
      case TextMode.small:
        textTheme.value = CustomTextData.textSmallTheme;
        textMode.value = TextMode.small;
        break;
      case TextMode.medium:
        textTheme.value = CustomTextData.textMediumTheme;
        textMode.value = TextMode.medium;
        break;
      case TextMode.large:
        textTheme.value = CustomTextData.textLargeTheme;
        textMode.value = TextMode.large;
        break;
    }
    textMode.value = mTextMode;
  }

  CustomTextMode._internal();
}

enum TextMode {
  small,
  medium,
  large;
}
