import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/setup/setup_usecase.dart';
import 'package:kdmp_cm_app/presentation/theme/custom_theme_mode.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_toggle_image_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/menu/setup_viewmodel.dart';
import 'package:provider/provider.dart';

/// 환경설정 화면
class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  static const String routeName = "setup";

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  late SetupViewModel _setupViewModel;

  @override
  void initState() {
    super.initState();
    initView();
  }

  initView() async {
    _setupViewModel = SetupViewModel(setupUseCase: GetIt.instance<SetupUseCase>());
    _setupViewModel.initSetup();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SetupViewModel>(
          create: (context) => _setupViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringMenu.title,
        ),

        /// 화면
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Column(
                  children: [
                    /// 테마 설정
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        StringSetup.themeMode,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ValueListenableBuilder<bool>(
                      valueListenable: _setupViewModel.isLightModeNotifier,
                      builder: (context, value, _) {
                        final texts = [
                          StringSetup.themeLightMode,
                          StringSetup.themeDarkMode,
                        ];
                        final icons = [
                          Image.asset(ImageSetup.iconLightMode, width: 72, height: 72),
                          Image.asset(ImageSetup.iconDarkMode, width: 72, height: 72),
                        ];
                        final selections = <bool>[value, !value];
                        return CustomToggleImageButton(
                          texts: texts,
                          icons: icons,
                          selections: selections,
                          onPressed: (index, text) {
                            final isLightMode = index == 0;
                            _setupViewModel.setThemeMode(isLightMode: isLightMode);
                            CustomThemeMode.change(isLightMode ? ThemeMode.light : ThemeMode.dark);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 44),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
