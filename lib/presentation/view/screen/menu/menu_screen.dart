import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/presentation/theme/custom_theme_mode.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/menu/setup_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/mypage/mypage_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/menu/custom_move_button.dart';

/// 메뉴 화면
class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  static const String routeName = "menu";
  static const String routeURL = "/menu";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: ValueListenableBuilder<ThemeMode>(
                valueListenable: CustomThemeMode.themeMode,
                builder: (context, themeMode, child) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),

                      /// 내정보 버튼
                      CustomMoveButton(
                        text: StringMenu.myPage,
                        iconImage: Image.asset(
                          themeMode == ThemeMode.light ? ImageMenuLight.iconMyPage : ImageMenuDark.iconMyPage,
                          width: 28,
                          height: 28,
                        ),
                        onPressed: () {
                          context.pushNamed(MyPageScreen.routeName);
                        },
                      ),

                      /// 이용내역 버튼
                      CustomMoveButton(
                        text: StringMenu.called,
                        iconImage: Image.asset(
                          themeMode == ThemeMode.light ? ImageMenuLight.iconCalled : ImageMenuDark.iconCalled,
                          width: 28,
                          height: 28,
                        ),
                        onPressed: () {
                          // TODO: 이용내역 화면으로 이동
                          // context.pushNamed(CalledScreen.routeName);
                        },
                      ),

                      /// 자주 가는 장소 버튼
                      CustomMoveButton(
                        text: StringMenu.place,
                        iconImage: Image.asset(
                          themeMode == ThemeMode.light ? ImageMenuLight.iconPlace : ImageMenuDark.iconPlace,
                          width: 28,
                          height: 28,
                        ),
                        onPressed: () {
                          // TODO: 자주 가는 장소 화면으로 이동
                          // context.pushNamed(PlaceScreen.routeName);
                        },
                      ),

                      /// 결제 관리 버튼
                      CustomMoveButton(
                        text: StringMenu.payment,
                        iconImage: Image.asset(
                          themeMode == ThemeMode.light ? ImageMenuLight.iconPayment : ImageMenuDark.iconPayment,
                          width: 28,
                          height: 28,
                        ),
                        onPressed: () {
                          // TODO: 결제 관리 화면 이동
                          // context.pushNamed(PaymentScreen.routeName);
                        },
                      ),

                      /// 차량정보 버튼
                      CustomMoveButton(
                        text: StringMenu.carInfo,
                        iconImage: Image.asset(
                          themeMode == ThemeMode.light ? ImageMenuLight.iconCarInfo : ImageMenuDark.iconCarInfo,
                          width: 28,
                          height: 28,
                        ),
                        onPressed: () {
                          // TODO: 차량정보 화면 이동
                          // context.pushNamed(CarInfoScreen.routeName);
                        },
                      ),
                      const Divider(thickness: 6),

                      /// 고객센터 버튼
                      CustomMoveButton(
                        text: StringMenu.cs,
                        iconImage: Image.asset(
                          themeMode == ThemeMode.light ? ImageMenuLight.iconCS : ImageMenuDark.iconCS,
                          width: 28,
                          height: 28,
                        ),
                        onPressed: () {
                          // TODO: 고객센터 화면 이동
                          // context.pushNamed(CSScreen.routeName);
                        },
                      ),

                      /// 환경설정 버튼
                      CustomMoveButton(
                        text: StringMenu.setup,
                        iconImage: Image.asset(
                          themeMode == ThemeMode.light ? ImageMenuLight.iconSetup : ImageMenuDark.iconSetup,
                          width: 28,
                          height: 28,
                        ),
                        onPressed: () {
                          context.pushNamed(SetupScreen.routeName);
                        },
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
