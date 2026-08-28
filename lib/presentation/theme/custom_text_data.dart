import 'package:flutter/material.dart';

/// 자간(letterSpacing)은 폰트 크기 대비 비율로 산출한다.
/// 16px 계열은 -4%, 그 외는 -2.5%, 행간(height)은 16px 계열·display가 1.2, 나머지는 1.45.
class CustomTextData {
  static const TextTheme textSmallTheme = TextTheme(
    bodyLarge: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      letterSpacing: -0.64,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    // 기본 적용 텍스트
    bodyMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: -0.35,
      wordSpacing: 0.0,
      height: 1.45,
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      letterSpacing: -0.3,
      wordSpacing: 0.0,
      height: 1.45,
    ),
    titleLarge: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      letterSpacing: -0.64,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      letterSpacing: -0.35,
      wordSpacing: 0.0,
      height: 1.45,
    ),
    titleSmall: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      letterSpacing: -0.3,
      wordSpacing: 0.0,
      height: 1.45,
    ),
    displaySmall: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20,
      letterSpacing: -0.5,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 22,
      letterSpacing: -0.55,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    displayLarge: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 24,
      letterSpacing: -0.6,
      wordSpacing: 0.0,
      height: 1.2,
    ),
  );

  static const TextTheme textMediumTheme = TextTheme(
    bodyLarge: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16 + 3,
      letterSpacing: -0.76,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    // 기본 적용 텍스트
    bodyMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14 + 3,
      letterSpacing: -0.43,
      wordSpacing: 0.0,
      height: 1.45,
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12 + 3,
      letterSpacing: -0.38,
      wordSpacing: 0.0,
      height: 1.45,
    ),
    titleLarge: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16 + 3,
      letterSpacing: -0.76,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14 + 3,
      letterSpacing: -0.43,
      wordSpacing: 0.0,
      height: 1.45,
    ),
    titleSmall: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12 + 3,
      letterSpacing: -0.38,
      wordSpacing: 0.0,
      height: 1.45,
    ),
    displaySmall: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20 + 3,
      letterSpacing: -0.58,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 22 + 3,
      letterSpacing: -0.63,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    displayLarge: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 24 + 3,
      letterSpacing: -0.68,
      wordSpacing: 0.0,
      height: 1.2,
    ),
  );

  static const TextTheme textLargeTheme = TextTheme(
    bodyLarge: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16 + 6,
      letterSpacing: -0.88,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    // 기본 적용 텍스트
    bodyMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14 + 6,
      letterSpacing: -0.5,
      wordSpacing: 0.0,
      height: 1.45,
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12 + 6,
      letterSpacing: -0.45,
      wordSpacing: 0.0,
      height: 1.45,
    ),
    titleLarge: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16 + 6,
      letterSpacing: -0.88,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14 + 6,
      letterSpacing: -0.5,
      wordSpacing: 0.0,
      height: 1.45,
    ),
    titleSmall: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12 + 6,
      letterSpacing: -0.45,
      wordSpacing: 0.0,
      height: 1.45,
    ),
    displaySmall: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20 + 6,
      letterSpacing: -0.65,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 22 + 6,
      letterSpacing: -0.7,
      wordSpacing: 0.0,
      height: 1.2,
    ),
    displayLarge: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 24 + 6,
      letterSpacing: -0.75,
      wordSpacing: 0.0,
      height: 1.2,
    ),
  );
}
