import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/setup/setup_usecase.dart';

class SetupViewModel {
  SetupViewModel({
    required this.setupUseCase,
  });

  final SetupUseCase setupUseCase;

  /// 테마
  final ValueNotifier<bool> _isLightMode = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isLightModeNotifier => _isLightMode;

  bool get isLightMode => _isLightMode.value;

  /// 초기화
  initSetup() {
    initThemeMode();
  }

  Future<void> initThemeMode() async {
    late ThemeMode themeMode;
    switch (await setupUseCase.getThemeMode()) {
      case "light":
        themeMode = ThemeMode.light;
        break;
      case "dark":
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.light;
    }
    debugPrint("themeMode: ${themeMode.toString()}");
    setThemeMode(isLightMode: themeMode == ThemeMode.light);
  }

  /// setter
  setThemeMode({required bool isLightMode}) {
    var themeMode = isLightMode ? ThemeMode.light : ThemeMode.dark;
    final newThemeMode = themeMode.toString().replaceAll("ThemeMode.", "");
    debugPrint("themeMode: $newThemeMode");
    setupUseCase.setThemeMode(themeMode: newThemeMode);

    _isLightMode.value = isLightMode;
  }
}

enum TextMode {
  small,
  medium,
  large;
}
