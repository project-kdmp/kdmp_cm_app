import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';

class ReservationConfirmBottomSheet extends StatefulWidget {
  const ReservationConfirmBottomSheet({
    Key? key,
    required this.dateTitle,
    required this.dateValue,
    required this.price,
    required this.paymentNm,
    required this.start,
    required this.end,
    required this.stopOverList,
  }) : super(key: key);

  final String dateTitle;
  final String dateValue;
  final int price;
  final String paymentNm;
  final MapData start;
  final MapData end;
  final List<StopOver> stopOverList;

  @override
  State<ReservationConfirmBottomSheet> createState() => _ReservationConfirmBottomSheetState();
}

class _ReservationConfirmBottomSheetState extends State<ReservationConfirmBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  StringReservation.confirmTitle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Divider(thickness: 1),
              ],
            ),
          ),

          Expanded(
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// 일시
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(StringReservation.dateAndTime, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                          SizedBox(height: 12, child: VerticalDivider(thickness: 1, width: 40, color: Theme.of(context).disabledColor)),
                          Expanded(child: Text(widget.dateTitle, textAlign: TextAlign.start)),
                        ],
                      ),
                    ),

                    /// 운행경로
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                      color: Theme.of(context).dividerColor,
                      child: Column(
                        children: [
                          /// 출발지
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 80, child: Text(StringReservation.startSpot)),
                              SizedBox(width: 20, child: Icon(Icons.circle, color: Theme.of(context).textTheme.bodyMedium?.color, size: 8)),
                              Expanded(child: Text(widget.start.place.isNotEmpty ? widget.start.place : widget.start.address)),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// 경유지
                          widget.stopOverList.isNotEmpty ? getStopover(widget.stopOverList) : const SizedBox(),
                          widget.stopOverList.isNotEmpty ? const SizedBox(height: 12) : const SizedBox(),

                          /// 도착지
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 80, child: Text(StringReservation.endSpot)),
                              SizedBox(width: 20, child: Icon(Icons.circle, color: Theme.of(context).textTheme.bodyMedium?.color, size: 8)),
                              Expanded(child: Text(widget.end.place.isNotEmpty ? widget.end.place : widget.end.address)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          /// 요금
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(StringReservation.amount, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                              SizedBox(height: 12, child: VerticalDivider(thickness: 1, width: 40, color: Theme.of(context).disabledColor)),
                              Expanded(child: Text(getPrice(widget.price), textAlign: TextAlign.start)),
                            ],
                          ),
                          const SizedBox(height: 14),

                          /// 결제
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(StringReservation.payment, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                              SizedBox(height: 12, child: VerticalDivider(thickness: 1, width: 40, color: Theme.of(context).disabledColor)),
                              Expanded(child: Text(widget.paymentNm, textAlign: TextAlign.start)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Divider(thickness: 6, height: 60),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          /// 유의사항
                          SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              StringReservation.warningTitle,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).dividerColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              StringReservation.warningContent,
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(height: 14),

                          /// 취소 정책 안내
                          // SizedBox(
                          //   width: double.maxFinite,
                          //   child: Text(
                          //     StringReservation.cancelTitle,
                          //     style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          //           color: Theme.of(context).disabledColor,
                          //         ),
                          //     textAlign: TextAlign.start,
                          //   ),
                          // ),
                          // const SizedBox(height: 4),
                          // Container(
                          //   width: double.maxFinite,
                          //   padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                          //   decoration: BoxDecoration(
                          //     color: Theme.of(context).dividerColor,
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          //   child: Text(
                          //     StringReservation.cancelContent,
                          //     style: Theme.of(context).textTheme.bodySmall,
                          //     textAlign: TextAlign.start,
                          //   ),
                          // ),
                          // const SizedBox(height: 14),

                          /// 대기료 발생 안내
                          SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              StringReservation.waitTitle,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).dividerColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              StringReservation.waitContent,
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// 하단 버튼
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomElevatedButton(
              text: StringCommon.confirm,
              onPressed: () async {
                context.pop(true);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 경유지 리스트
  Widget getStopover(List<StopOver> value) {
    return ListView.separated(
      itemCount: value.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 80, child: Text("${StringReservation.stopover} ${index + 1}")),
            SizedBox(height: 12, child: VerticalDivider(thickness: 1, width: 20, color: Theme.of(context).disabledColor)),
            Expanded(child: Text(value[index].placeName.isNotEmpty ? value[index].placeName : value[index].address)),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return const Column(
          children: [
            SizedBox(height: 6),
          ],
        );
      },
    );
  }
}
