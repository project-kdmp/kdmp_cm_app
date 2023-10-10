import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class ReservationTimeBottomSheet extends StatefulWidget {
  const ReservationTimeBottomSheet({
    Key? key,
    required this.date,
  }) : super(key: key);

  final String date;

  @override
  State<ReservationTimeBottomSheet> createState() => _ReservationTimeBottomSheetState();
}

class _ReservationTimeBottomSheetState extends State<ReservationTimeBottomSheet> {
  /// 오전/오후
  final ValueNotifier<int> _amPm = ValueNotifier<int>(0);

  ValueNotifier<int> get amPmNotifier => _amPm;

  int get amPm => _amPm.value;

  set amPm(int value) => _amPm.value = value;

  /// 시
  final ValueNotifier<int> _hour = ValueNotifier<int>(12);

  ValueNotifier<int> get hourNotifier => _hour;

  int get hour => _hour.value;

  set hour(int value) => _hour.value = value;

  /// 분
  final ValueNotifier<String> _minute = ValueNotifier<String>("00");

  ValueNotifier<String> get minuteNotifier => _minute;

  String get minute => _minute.value;

  set minute(String value) => _minute.value = value;

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
                    StringReservation.timeTitle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Divider(thickness: 1),
                ],
              ),
            ),

            /// 시간 선택
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  /// 오전/오후 선택 휠
                  Flexible(
                    flex: 1,
                    child: WheelChooser.choices(
                      selectTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      unSelectTextStyle: TextStyle(
                        color: Theme.of(context).disabledColor,
                      ),
                      onChoiceChanged: (value) {
                        amPm = value;
                      },
                      choices: [
                        WheelChoice(value: 0, title: "오전"),
                        WheelChoice(value: 1, title: "오후"),
                      ],
                    ),
                  ),

                  /// 시 선택 휠
                  Flexible(
                    flex: 1,
                    child: WheelChooser(
                      selectTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      unSelectTextStyle: TextStyle(
                        color: Theme.of(context).disabledColor,
                      ),
                      onValueChanged: (value) {
                        hour = value;
                      },
                      datas: List.from({12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}),
                    ),
                  ),

                  /// 분 선택 휠
                  Flexible(
                    flex: 1,
                    child: WheelChooser(
                      selectTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      unSelectTextStyle: TextStyle(
                        color: Theme.of(context).disabledColor,
                      ),
                      onValueChanged: (value) {
                        minute = value;
                      },
                      datas: List.from({"00", "10", "20", "30", "40", "50"}),
                    ),
                  ),
                ],
              ),
            ),

            /// 확인 버튼
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomElevatedButton(
                text: StringCommon.confirm,
                onPressed: () {
                  final title = "${amPm == 0 ? "오전" : "오후"} $hour시 $minute분";
                  final mHour = (amPm * 12) + (hour != 12 ? hour : 0);
                  final value = "${"$mHour".padLeft(2, "0")}:$minute:00";

                  final date = "${getDateFormat(date: widget.date)} $value";
                  final isConfirmValid = DateTime.parse(date).isAfter(DateTime.now());

                  if (!isConfirmValid) {
                    Fluttertoast.showToast(msg: StringReservation.dateErrorToast);
                    return;
                  }
                  Map<String, String> values = {
                    "title": title,
                    "value": value,
                  };
                  context.pop(values);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
