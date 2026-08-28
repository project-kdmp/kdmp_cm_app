import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/presentation/values/colors.dart';

class CustomThemeData {
  static ThemeData light(TextTheme textTheme) {
    return ThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      canvasColor: Colors.transparent,

      /// 기본 테마
      scaffoldBackgroundColor: ColorLight.background,
      disabledColor: ColorLight.gray3,
      dividerColor: ColorLight.gray5,
      cardColor: ColorLight.gray6,
      colorScheme: const ColorScheme.light(
        primary: ColorLight.primary,
        secondary: ColorLight.icon,
      ),
      dialogTheme: const DialogThemeData(
        surfaceTintColor: ColorLight.background,
        backgroundColor: ColorLight.background,
      ),
      dividerTheme: const DividerThemeData(color: ColorLight.gray5),
      appBarTheme: const AppBarTheme(
        surfaceTintColor: ColorLight.background,
        backgroundColor: ColorLight.background,
        iconTheme: IconThemeData(color: ColorLight.gray1),
      ),
      iconTheme: const IconThemeData(color: ColorLight.gray1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          minimumSize: const Size(double.infinity, double.minPositive),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          backgroundColor: ColorLight.primary,
          textStyle: textTheme.bodyLarge?.copyWith(
            color: ColorLight.background,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: ColorLight.gray4,
        borderColor: ColorLight.gray6,
        selectedColor: ColorLight.icon,
        selectedBorderColor: ColorLight.icon,
        fillColor: ColorLight.btn,
        borderRadius: BorderRadius.circular(4),
      ),
      textTheme: textTheme.copyWith(
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: ColorLight.gray1,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: ColorLight.gray1,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          color: ColorLight.gray1,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          color: ColorLight.gray1,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          color: ColorLight.gray1,
        ),
        titleSmall: textTheme.titleSmall?.copyWith(
          color: ColorLight.gray1,
        ),
        displaySmall: textTheme.displaySmall?.copyWith(
          color: ColorLight.gray1,
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          color: ColorLight.gray1,
        ),
        displayLarge: textTheme.displayLarge?.copyWith(
          color: ColorLight.gray1,
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: ColorLight.icon,
        activeTickMarkColor: ColorLight.icon,
        inactiveTrackColor: ColorLight.gray6,
        inactiveTickMarkColor: ColorLight.gray6,
        thumbColor: ColorLight.icon,
      ),
    );
  }

  static ThemeData dark(TextTheme textTheme) {
    return ThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      canvasColor: Colors.transparent,

      /// 다크 모드 테마
      scaffoldBackgroundColor: ColorNight.background,
      disabledColor: ColorNight.gray3,
      dividerColor: ColorNight.gray5,
      cardColor: ColorNight.gray6,
      colorScheme: const ColorScheme.dark(
        primary: ColorNight.primary,
        secondary: ColorNight.icon,
      ),
      dialogTheme: const DialogThemeData(
        surfaceTintColor: ColorNight.background,
        backgroundColor: ColorNight.background,
      ),
      dividerTheme: const DividerThemeData(color: ColorNight.gray5),
      appBarTheme: const AppBarTheme(
        surfaceTintColor: ColorNight.background,
        backgroundColor: ColorNight.background,
        iconTheme: IconThemeData(color: ColorNight.gray1),
      ),
      iconTheme: const IconThemeData(color: ColorNight.gray1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          minimumSize: const Size(double.infinity, double.minPositive),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          backgroundColor: ColorNight.primary,
          textStyle: textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: ColorNight.gray4,
        borderColor: ColorNight.gray6,
        selectedColor: ColorNight.icon,
        selectedBorderColor: ColorNight.icon,
        fillColor: ColorNight.btn,
        borderRadius: BorderRadius.circular(4),
      ),
      textTheme: textTheme.copyWith(
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: ColorNight.gray1,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: ColorNight.gray1,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          color: ColorNight.gray1,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          color: ColorNight.gray1,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          color: ColorNight.gray1,
        ),
        titleSmall: textTheme.titleSmall?.copyWith(
          color: ColorNight.gray1,
        ),
        displaySmall: textTheme.displaySmall?.copyWith(
          color: ColorNight.gray1,
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          color: ColorNight.gray1,
        ),
        displayLarge: textTheme.displayLarge?.copyWith(
          color: ColorNight.gray1,
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: ColorNight.icon,
        activeTickMarkColor: ColorNight.icon,
        inactiveTrackColor: ColorNight.gray6,
        inactiveTickMarkColor: ColorNight.gray6,
        thumbColor: ColorNight.icon,
      ),
    );
  }
}
