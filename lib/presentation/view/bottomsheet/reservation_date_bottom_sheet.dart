import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class ReservationDateBottomSheet extends StatefulWidget {
  const ReservationDateBottomSheet({
    Key? key,
    this.initDate = "",
  }) : super(key: key);

  final String initDate;

  @override
  State<ReservationDateBottomSheet> createState() => _ReservationDateBottomSheetState();
}

class _ReservationDateBottomSheetState extends State<ReservationDateBottomSheet> {
  List<WheelChoice> dates = [
    WheelChoice(value: DateTime.now(), title: '오늘'),
    WheelChoice(value: DateTime.now().add(const Duration(days: 1)), title: '내일'),
    WheelChoice(value: DateTime.now().add(const Duration(days: 2)), title: getDateFormat(date: DateTime.now().add(const Duration(days: 2)).toIso8601String(), dateFormat: "MM월 dd일(E)")),
    WheelChoice(value: DateTime.now().add(const Duration(days: 3)), title: getDateFormat(date: DateTime.now().add(const Duration(days: 3)).toIso8601String(), dateFormat: "MM월 dd일(E)")),
    WheelChoice(value: DateTime.now().add(const Duration(days: 4)), title: getDateFormat(date: DateTime.now().add(const Duration(days: 4)).toIso8601String(), dateFormat: "MM월 dd일(E)")),
  ];

  /// 일자
  final ValueNotifier<DateTime> _date = ValueNotifier<DateTime>(DateTime.now());

  ValueNotifier<DateTime> get dateNotifier => _date;

  DateTime get date => _date.value;

  set date(DateTime value) => _date.value = value;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            /// 상단 타이틀
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),

                  /// 타이틀
                  Text(
                    StringReservation.dateTitle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Divider(thickness: 1),
                ],
              ),
            ),

            /// 예약 일자 선택 휠
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: WheelChooser.choices(
                selectTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                unSelectTextStyle: TextStyle(
                  color: Theme.of(context).disabledColor,
                ),
                onChoiceChanged: (value) {
                  date = value;
                },
                choices: dates,
              ),
            ),

            /// 확인 버튼
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomElevatedButton(
                text: StringCommon.confirm,
                onPressed: () {
                  context.pop(date);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
