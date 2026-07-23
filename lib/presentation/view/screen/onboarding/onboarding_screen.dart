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
    return WillPopScope(
      onWillPop: () async => false,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: CustomThemeMode.themeMode,
        builder: (context, themeMode, child) {
          return IntroductionScreen(
            // 안드로이드 네비게이션 바에 컨트롤 영역이 가려지지 않도록 하단 세이프 영역 확보
            safeAreaList: const [false, false, false, true],
            // 페이지가 1개뿐이라 도트 인디케이터는 숨김
            isProgress: false,
            // 좌측(스킵/뒤로) 및 도트 영역의 flex를 0으로 두어(내용이 비어있으므로) 시작하기 버튼이 남은 폭 전체를 차지하며 하단 중앙에 오도록 함
            skipOrBackFlex: 0,
            dotsFlex: 0,
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
      ),
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
