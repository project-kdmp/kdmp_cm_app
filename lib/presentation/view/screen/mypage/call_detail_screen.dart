import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_call_detail_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/divider/horizontal_dashed_divider.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_tag.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/mypage/call_detail_viewmodel.dart';
import 'package:provider/provider.dart';

/// 미완료 이용내역 상세 화면
class CallDetailScreen extends StatefulWidget {
  const CallDetailScreen({
    Key? key,
    required this.drvReqSq,
  }) : super(key: key);

  static const String routeName = "call_detail";

  final int drvReqSq;

  @override
  State<CallDetailScreen> createState() => _CallDetailScreenState();
}

class _CallDetailScreenState extends State<CallDetailScreen> with SingleTickerProviderStateMixin {
  late final CallDetailViewModel _callDetailViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _callDetailViewModel = CallDetailViewModel(
      getCallDetailUseCase: GetIt.instance<GetCallDetailUseCase>(),
    );
  }

  void initData() async {
    /// 미완료 이용내역 상세정보 조회
    await _callDetailViewModel.getCallDetail(widget.drvReqSq);
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<CallDetailViewModel>(
          create: (context) => _callDetailViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringCalledDetail.title,
        ),

        /// 화면
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    /// 이용정보
                    SizedBox(
                      width: double.maxFinite,
                      child: Text(StringCalledDetail.sub1Title, style: Theme.of(context).textTheme.displaySmall),
                    ),
                    const SizedBox(height: 28),

                    /// 일시
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(StringCalledDetail.date, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                        const SizedBox(width: 14),
                        ValueListenableBuilder<String>(
                          valueListenable: _callDetailViewModel.dateNotifier,
                          builder: (context, value, _) {
                            return Expanded(child: Text(value, textAlign: TextAlign.start));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    /// 호출
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(StringCalledDetail.callType, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                        const SizedBox(width: 14),
                        ValueListenableBuilder<String>(
                          valueListenable: _callDetailViewModel.drvReqStNotifier,
                          builder: (context, value, _) {
                            return Expanded(child: Text(getCallType(value), textAlign: TextAlign.start));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    /// 상태
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(StringCalledDetail.driveType, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                        const SizedBox(width: 14),
                        ValueListenableBuilder<String>(
                          valueListenable: _callDetailViewModel.drvReqStNotifier,
                          builder: (context, value, child) {
                            return CustomTag(
                              text: getDriveType(value),
                              color: Colors.redAccent,
                              margin: const EdgeInsets.all(6),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    /// 출발지
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Theme.of(context).colorScheme.secondary, size: 24),
                        const SizedBox(width: 4),
                        Text(
                          StringCalledDetail.startSpot,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(width: 30),
                        ValueListenableBuilder<String>(
                          valueListenable: _callDetailViewModel.startPlaceNotifier,
                          builder: (context, value, _) {
                            return Expanded(child: Text(value));
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// 경유지
                    ValueListenableBuilder<List<StopOver>>(
                      valueListenable: _callDetailViewModel.stopoverListNotifier,
                      builder: (context, value, _) {
                        return value.isNotEmpty ? getStopover(value) : const SizedBox();
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: _callDetailViewModel.stopoverListNotifier,
                      builder: (context, value, _) {
                        return value.isNotEmpty ? const SizedBox(height: 12) : const SizedBox();
                      },
                    ),

                    /// 도착지
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.flag_sharp, color: Theme.of(context).colorScheme.secondary, size: 24),
                        const SizedBox(width: 4),
                        Text(
                          StringCalledDetail.endSpot,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(width: 30),
                        ValueListenableBuilder<String>(
                          valueListenable: _callDetailViewModel.endPlaceNotifier,
                          builder: (context, value, _) {
                            return Expanded(child: Text(value));
                          },
                        ),
                      ],
                    ),

                    HorizontalDashedDivider(
                      thickness: 1,
                      color: Theme.of(context).disabledColor,
                      space: 68,
                      length: 2,
                    ),

                    /// 결제정보
                    SizedBox(
                      width: double.maxFinite,
                      child: Text(StringCalledDetail.sub2Title, style: Theme.of(context).textTheme.displaySmall),
                    ),
                    const SizedBox(height: 28),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(StringCalledDetail.amount, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                        const SizedBox(width: 14),
                        ValueListenableBuilder<int>(
                          valueListenable: _callDetailViewModel.amountNotifier,
                          builder: (context, value, _) {
                            return Expanded(child: Text(getPrice(value), textAlign: TextAlign.start));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    /// 결제
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(StringCalledDetail.payment, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                        const SizedBox(width: 14),
                        ValueListenableBuilder<String>(
                          valueListenable: _callDetailViewModel.paymentNotifier,
                          builder: (context, value, _) {
                            return Expanded(child: Text(getPaymentKind(value), textAlign: TextAlign.start));
                          },
                        ),
                      ],
                    ),

                    HorizontalDashedDivider(
                      thickness: 1,
                      color: Theme.of(context).disabledColor,
                      space: 68,
                      length: 2,
                    ),

                    /// 기사정보
                    SizedBox(
                      width: double.maxFinite,
                      child: Text(StringCalledDetail.sub3Title, style: Theme.of(context).textTheme.displaySmall),
                    ),
                    const SizedBox(height: 28),

                    /// 이름
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(StringCalledDetail.driver, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                        const SizedBox(width: 14),
                        ValueListenableBuilder<String>(
                          valueListenable: _callDetailViewModel.driverNotifier,
                          builder: (context, value, _) {
                            return Expanded(child: Text(value, textAlign: TextAlign.start));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    /// 차량
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(StringCalledDetail.car, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                        const SizedBox(width: 14),
                        ValueListenableBuilder<String>(
                          valueListenable: _callDetailViewModel.carNumIdNotifier,
                          builder: (context, value, _) {
                            return Expanded(child: Text(value, textAlign: TextAlign.start));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
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
            Padding(
              padding: const EdgeInsets.all(9),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                width: 6,
                height: 6,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "${StringCalledDetail.stopover} ${index + 1}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 18),
            Text(value[index].placeName.isNotEmpty ? value[index].placeName : value[index].address),
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
