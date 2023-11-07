import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_push_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_called_detail_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_review_write_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/review_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_radius_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/divider/horizontal_dashed_divider.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_tag.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/mypage/called_detail_viewmodel.dart';
import 'package:provider/provider.dart';

/// 이용 정보 화면
class CalledDetailScreen extends StatefulWidget {
  const CalledDetailScreen({
    Key? key,
    required this.drvReqSq,
  }) : super(key: key);

  static const String routeName = "called_detail";

  final int drvReqSq;

  @override
  State<CalledDetailScreen> createState() => _CalledDetailScreenState();
}

class _CalledDetailScreenState extends State<CalledDetailScreen> with SingleTickerProviderStateMixin {
  late final CalledDetailViewModel _calledDetailViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _calledDetailViewModel = CalledDetailViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getCalledDetailUseCase: GetIt.instance<GetCalledDetailUseCase>(),
      setReviewWriteUseCase: GetIt.instance<SetReviewWriteUseCase>(),
      setFCMPushUseCase: GetIt.instance<SetFCMPushUseCase>(),
    );
  }

  void initData() async {
    /// 이용 정보정보 조회
    await _calledDetailViewModel.getCalledDetail(widget.drvReqSq);
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<CalledDetailViewModel>(
          create: (context) => _calledDetailViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringCalled.callTitle,
        ),

        /// 화면
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),

                          /// 이용 정보
                          SizedBox(
                            width: double.maxFinite,
                            child: Text(StringCalled.infoTitle, style: Theme.of(context).textTheme.displaySmall),
                          ),
                          const SizedBox(height: 28),

                          /// 코드(운행)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(StringCalled.code, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                              const SizedBox(width: 14),
                              ValueListenableBuilder<String>(
                                valueListenable: _calledDetailViewModel.codeNotifier,
                                builder: (context, value, _) {
                                  return Expanded(child: Text(value, textAlign: TextAlign.start));
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          /// 일시
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(StringCalled.date, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                              const SizedBox(width: 14),
                              ValueListenableBuilder<String>(
                                valueListenable: _calledDetailViewModel.dateNotifier,
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
                              Text(StringCalled.callType, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                              const SizedBox(width: 14),
                              ValueListenableBuilder<String>(
                                valueListenable: _calledDetailViewModel.drvReqStNotifier,
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
                              Text(StringCalled.driveType, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                              const SizedBox(width: 14),
                              ValueListenableBuilder<String>(
                                valueListenable: _calledDetailViewModel.drvReqStNotifier,
                                builder: (context, value, child) {
                                  return CustomTag(
                                    text: getDriveType(value),
                                    color: value == DrvReqSt.end || value == DrvReqSt.ren ? Theme.of(context).colorScheme.secondary : Colors.redAccent,
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
                                StringCalled.startSpot,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(width: 30),
                              ValueListenableBuilder<String>(
                                valueListenable: _calledDetailViewModel.startPlaceNotifier,
                                builder: (context, value, _) {
                                  return Expanded(child: Text(value));
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// 경유지
                          ValueListenableBuilder<List<StopOver>>(
                            valueListenable: _calledDetailViewModel.stopoverListNotifier,
                            builder: (context, value, _) {
                              return value.isNotEmpty ? getStopover(value) : const SizedBox();
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: _calledDetailViewModel.stopoverListNotifier,
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
                                StringCalled.endSpot,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(width: 30),
                              ValueListenableBuilder<String>(
                                valueListenable: _calledDetailViewModel.endPlaceNotifier,
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

                          /// 결제 정보
                          SizedBox(
                            width: double.maxFinite,
                            child: Text(StringCalled.paymentTitle, style: Theme.of(context).textTheme.displaySmall),
                          ),
                          const SizedBox(height: 28),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(StringCalled.amount, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                              const SizedBox(width: 14),
                              ValueListenableBuilder<int>(
                                valueListenable: _calledDetailViewModel.amountNotifier,
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
                              Text(StringCalled.payment, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                              const SizedBox(width: 14),
                              ValueListenableBuilder<String>(
                                valueListenable: _calledDetailViewModel.paymentNotifier,
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

                          /// 기사 정보
                          SizedBox(
                            width: double.maxFinite,
                            child: Text(StringCalled.driverTitle, style: Theme.of(context).textTheme.displaySmall),
                          ),
                          const SizedBox(height: 28),

                          /// 코드(아이디)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(StringCalled.driverId, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                              const SizedBox(width: 14),
                              ValueListenableBuilder<String>(
                                valueListenable: _calledDetailViewModel.driverIdNotifier,
                                builder: (context, value, _) {
                                  return Expanded(child: Text(value, textAlign: TextAlign.start));
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          /// 이름
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(StringCalled.driver, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                              const SizedBox(width: 14),
                              ValueListenableBuilder<String>(
                                valueListenable: _calledDetailViewModel.driverNotifier,
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
                              Text(StringCalled.car, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                              const SizedBox(width: 14),
                              ValueListenableBuilder<String>(
                                valueListenable: _calledDetailViewModel.carNumIdNotifier,
                                builder: (context, value, _) {
                                  return Expanded(child: Text(value, textAlign: TextAlign.start));
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          /// 리뷰
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(StringCalled.review, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  children: [
                                    /// 별점
                                    ValueListenableBuilder<int>(
                                      valueListenable: _calledDetailViewModel.starNotifier,
                                      builder: (context, value, child) {
                                        return Row(
                                          children: [
                                            Icon(Icons.star, color: value > 0 ? Theme.of(context).colorScheme.secondary : Theme.of(context).dividerColor, size: 20),
                                            Icon(Icons.star, color: value > 1 ? Theme.of(context).colorScheme.secondary : Theme.of(context).dividerColor, size: 20),
                                            Icon(Icons.star, color: value > 2 ? Theme.of(context).colorScheme.secondary : Theme.of(context).dividerColor, size: 20),
                                            Icon(Icons.star, color: value > 3 ? Theme.of(context).colorScheme.secondary : Theme.of(context).dividerColor, size: 20),
                                            Icon(Icons.star, color: value > 4 ? Theme.of(context).colorScheme.secondary : Theme.of(context).dividerColor, size: 20),
                                          ],
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),

                                    /// 내용
                                    ValueListenableBuilder<String>(
                                      valueListenable: _calledDetailViewModel.reviewNotifier,
                                      builder: (context, value, _) {
                                        return Container(
                                          height: 80,
                                          width: double.maxFinite,
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).dividerColor,
                                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                                          ),
                                          child: Text(value),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// 하단 버튼
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    /// 리뷰 수정 버튼
                    ValueListenableBuilder<bool>(
                      valueListenable: _calledDetailViewModel.isReviewEnabledNotifier,
                      builder: (context, value, child) {
                        return value
                            ? Expanded(
                                child: CustomRadiusButton(
                                  text: StringCalled.reviewModify,
                                  onPressed: () async {
                                    /// 리뷰 작성 팝업 띄움
                                    final result = await _showReviewBottomSheet();
                                    if (result == true) {
                                      initData();
                                    }
                                  },
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _calledDetailViewModel.isReviewEnabledNotifier,
                      builder: (context, value, child) {
                        return value ? const SizedBox(width: 8) : const SizedBox();
                      },
                    ),

                    /// 다시 호출하기 버튼
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // TODO: 다시 호출하기
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        ),
                        child: Row(
                          children: [
                            /// 아이콘
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
                              child: const Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  child: Icon(Icons.call, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            /// 예약콜
                            const Expanded(
                              child: Text(
                                StringCalled.reCall,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
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
              "${StringCalled.stopover} ${index + 1}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 18),
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

  /// 리뷰 작성 팝업
  Future<bool> _showReviewBottomSheet() async {
    return await showModalBottomSheet(
      context: context,
      isDismissible: false, // bottomSheet 영역 외 터치 여부
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ReviewBottomSheet(
                onPressed: (star, review) async {
                  debugPrint("$star, $review");

                  /// 리뷰 작성
                  final result = await _calledDetailViewModel.writeReview(drvReqSq: widget.drvReqSq, reviewContent: review, starPoint: star);
                  if (result is Success) {
                    /// 리뷰 작성 팝업 닫기
                    context.pop(true);
                  }
                },
              ),
            ),
          ],
        );
      },
    );

    /// 화면 닫기, 홈 화면 초기화
    context.pop(false);
  }
}
