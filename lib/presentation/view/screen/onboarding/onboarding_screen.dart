import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_onboarding_check_usecase.dart';
import 'package:kdmp_cm_app/presentation/theme/custom_theme_mode.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/onboarding/onboarding_viewmodel.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  static const String routeName = "on_boarding";
  static const String routeURL = "/on_boarding";

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late final OnBoardingViewModel _onBoardingViewModel;

  @override
  void initState() {
    super.initState();
    _onBoardingViewModel = OnBoardingViewModel(
      setOnBoardingCheckUseCase: GetIt.instance<SetOnBoardingCheckUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: CustomThemeMode.themeMode,
      builder: (context, themeMode, child) {
        return IntroductionScreen(
          pages: [
            // 대부분의 온보딩 스크린은 여러 페이지로 구성되어 있기 때문에, 칼럼 위젯처럼 pages 알규먼트는 리스트를 불러와야 한다.
            PageViewModel(
              title: "",
              body: "",
              image: Image.asset(
                themeMode == ThemeMode.light ? ImageOnBoarding.imgOnBoarding1Light : ImageOnBoarding.imgOnBoarding1Dark,
                width: double.maxFinite,
                height: double.infinity,
              ),
              decoration: getScreenDecoration(context),
            ),
            PageViewModel(
              title: "",
              body: "",
              image: Image.asset(
                themeMode == ThemeMode.light ? ImageOnBoarding.imgOnBoarding2Light : ImageOnBoarding.imgOnBoarding2Dark,
                width: double.maxFinite,
                height: double.infinity,
              ),
              decoration: getScreenDecoration(context),
            ),
          ],

          /// 시작하기 버튼
          done: Text(
            StringOnBoarding.start,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          // 온보딩 스크린을 마지막까지 보았을 때, 무엇을 할 지 지정해주는 버튼
          onDone: () async {
            await _onBoardingViewModel.setOnBoardingCheck();
            context.pop();
          },
          // 버튼이 터치가 되면 무엇을 할 지 지정, onPressed와 유사
          /// 다음 버튼
          next: Text(
            StringCommon.next,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          // showSkipButton: true,
          // skip: const Text('skip'),
          dotsDecorator: DotsDecorator(
            color: Theme.of(context).disabledColor,
            size: const Size(10, 10),
            activeSize: const Size(10, 10),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            activeColor: Theme.of(context).colorScheme.secondary,
          ),
          curve: Curves.linear,
          animationDuration: 200,
        );
      },
    );
  }

  PageDecoration getScreenDecoration(BuildContext context) {
    return const PageDecoration(
      imagePadding: EdgeInsets.all(20),
      fullScreen: true,
      imageFlex: 1,
    );
  }
}
