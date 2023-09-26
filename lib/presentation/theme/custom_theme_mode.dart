import 'package:flutter/material.dart';

class CustomThemeMode {
  static final CustomThemeMode instance = CustomThemeMode._internal();

  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  static ThemeMode get getThemeMode => themeMode.value;

  factory CustomThemeMode() => instance;

  static void change(ThemeMode mThemeMode) {
    switch (mThemeMode) {
      case ThemeMode.light:
        themeMode.value = ThemeMode.light;
        break;
      case ThemeMode.dark:
        themeMode.value = ThemeMode.dark;
        break;
      default:
    }
  }

  CustomThemeMode._internal();
}
