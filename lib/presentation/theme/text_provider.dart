import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/menu/setup_viewmodel.dart';

class TextProvider extends ChangeNotifier {
  TextProvider({
    required this.textMode,
  });

  TextMode textMode;
  double text12 = 14;
  double text14 = 16;
  double text16 = 18;
  double text18 = 20;
  double text20 = 22;
  double text22 = 24;
  double text24 = 26;

  setTextMode(TextMode textMode) {
    switch (textMode) {
      case TextMode.small:
        text12 = 14;
        text14 = 16;
        text16 = 18;
        text18 = 20;
        text20 = 22;
        text22 = 24;
        text24 = 26;
        break;
      case TextMode.medium:
        text12 = 14 + 3;
        text14 = 16 + 3;
        text16 = 18 + 3;
        text18 = 20 + 3;
        text20 = 22 + 3;
        text22 = 24 + 3;
        text24 = 26 + 3;
        break;
      case TextMode.large:
        text12 = 14 + 6;
        text14 = 16 + 6;
        text16 = 18 + 6;
        text18 = 20 + 6;
        text20 = 22 + 6;
        text22 = 24 + 6;
        text24 = 26 + 6;
        break;
    }
    notifyListeners();
  }
}
