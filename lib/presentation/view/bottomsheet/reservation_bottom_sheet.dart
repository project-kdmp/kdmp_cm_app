import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/reservation_date_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/reservation_time_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_text_button.dart';

class ReservationBottomSheet extends StatelessWidget {
  ReservationBottomSheet({
    Key? key,
    this.initDate = "",
    this.initTime = "",
  }) : super(key: key);

  final String initDate;
  final String initTime;

  /// 일자
  final ValueNotifier<String> _date = ValueNotifier<String>("");

  ValueNotifier<String> get dateNotifier => _date;

  String get date => _date.value;

  set date(String value) {
    _date.value = value;
    _checkIsValid();
  }

  /// 시간
  final ValueNotifier<Map<String, String>> _time = ValueNotifier<Map<String, String>>({});

  ValueNotifier<Map<String, String>> get timeNotifier => _time;

  Map<String, String> get time => _time.value;

  set time(Map<String, String> value) {
    _time.value = value;
    _checkIsValid();
  }

  /// 하단 버튼 활성화 여부
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isValidNotifier => _isValid;

  bool get isValid => _isValid.value;

  _setIsValid({required bool value}) {
    _isValid.value = value;
  }

  _checkIsValid() {
    bool valid;
    debugPrint("$date, $time");
    if (date.isNotEmpty && time.isNotEmpty) {
      valid = true;
    } else {
      valid = false;
    }
    _setIsValid(value: valid);
  }

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
                    StringReservation.title,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Divider(thickness: 1),
                ],
              ),
            ),

            /// 예약 일자
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 예약 일자 선택
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(StringReservation.date),
                  ),
                  const SizedBox(height: 6),
                  ValueListenableBuilder<String>(
                    valueListenable: dateNotifier,
                    builder: (context, value, _) {
                      return CustomTextButton(
                        hint: StringReservation.dateHint,
                        icon: Icons.calendar_month_outlined,
                        text: value.isNotEmpty ? getDateFormat(date: value, dateFormat: "yyyy년 MM월 dd일(E)") : "",
                        onPressed: () async {
                          final result = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return Wrap(children: [ReservationDateBottomSheet()]);
                            },
                          );
                          if (result != null && result is DateTime) {
                            date = result.toIso8601String();
                            time = {};
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            /// 예약 시간
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 예약 시간 선택
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(StringReservation.time),
                  ),
                  const SizedBox(height: 6),
                  ValueListenableBuilder<Map>(
                    valueListenable: timeNotifier,
                    builder: (context, value, _) {
                      return CustomTextButton(
                        icon: Icons.access_time_outlined,
                        hint: StringReservation.timeHint,
                        text: value.isNotEmpty ? value["title"] : "",
                        onPressed: () async {
                          if (date.isEmpty) {
                            Fluttertoast.showToast(msg: StringReservation.dateHint);
                            return;
                          }
                          final result = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return Wrap(children: [ReservationTimeBottomSheet(date: date)]);
                            },
                          );
                          if (result != null) {
                            time = result;
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            /// 확인 버튼
            ValueListenableBuilder<bool>(
              valueListenable: isValidNotifier,
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: CustomElevatedButton(
                    isEnabled: value,
                    text: StringCommon.confirm,
                    onPressed: () {
                      final title = "${getDateFormat(date: date, dateFormat: "yyyy년 MM월 dd일(E)")} ${time["title"]}";
                      final value = "${getDateFormat(date: date)} ${time["value"]}";
                      Map<String, String> values = {
                        "title": title,
                        "value": value,
                      };
                      context.pop(values);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
