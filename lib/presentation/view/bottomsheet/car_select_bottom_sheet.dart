import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_list_response.dart';
import 'package:kdmp_cm_app/presentation/theme/custom_theme_mode.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/mypage/car_info_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_radius_button.dart';

/// 차량선택 팝업
class CarSelectBottomSheet extends StatelessWidget {
  const CarSelectBottomSheet({
    Key? key,
    required this.carList,
  }) : super(key: key);

  final List<Car> carList;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: Container(
        height: 380,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// 타이틀
            const Text(
              StringCarSelect.title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Divider(thickness: 1),

            /// 차량정보 목록
            getListView(carList),

            /// 차량추가 버튼
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomRadiusButton(
                text: StringCarSelect.addCar,
                onPressed: () {
                  context.pop();

                  /// 차량정보 화면으로 이동
                  context.pushNamed(CarInfoScreen.routeName);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 차량정보 리스트
  Widget getListView(List<Car> value) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        itemCount: value.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.pop(carList[index]);
            },
            child: Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20, left: 24, right: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        CustomThemeMode.getThemeMode == ThemeMode.light ? ImageMenuLight.iconCarInfo : ImageMenuDark.iconCarInfo,
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(width: 16),

                      /// 차량번호
                      Expanded(child: Text(value[index].carNumId, style: Theme.of(context).textTheme.titleLarge)),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Column(
            children: [
              SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}
