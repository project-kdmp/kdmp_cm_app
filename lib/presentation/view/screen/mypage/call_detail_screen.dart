import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_push_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_call_detail_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_confirm_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/call_cancel_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/home/home_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_radius_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/divider/horizontal_dashed_divider.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_tag.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/mypage/call_detail_viewmodel.dart';
import 'package:provider/provider.dart';

/// 미완료 이용 정보 화면
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
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getCallDetailUseCase: GetIt.instance<GetCallDetailUseCase>(),
      setCallCancelUseCase: GetIt.instance<SetCallCancelUseCase>(),
      setConfirmCallCancelUseCase: GetIt.instance<SetConfirmCallCancelUseCase>(),
      setFCMPushUseCase: GetIt.instance<SetFCMPushUseCase>(),
    );
  }

  void initData() async {
    /// 미완료 이용 정보정보 조회
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: ValueListenableBuilder<String>(
            valueListenable: _callDetailViewModel.drvReqStNotifier,
            builder: (context, value, _) {
              return BaseAppBar(
                appBar: AppBar(),
                title: _callDetailViewModel.isReservation() ? StringCalled.reservationTitle : StringCalled.infoTitle,
              );
            },
          ),
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

                          /// 예약인 경우에만 보여줄 위젯
                          ValueListenableBuilder<String>(
                            valueListenable: _callDetailViewModel.drvReqStNotifier,
                            builder: (context, value, child) {
                              final primaryColor = Theme.of(context).colorScheme.primary;
                              final disabledColor = Theme.of(context).disabledColor;
                              final isWait = value == DrvReqSt.res || value == DrvReqSt.rco || value == DrvReqSt.rwt || value == DrvReqSt.rst;
                              final isStart = value == DrvReqSt.rst;
                              return _callDetailViewModel.isReservation()
                                  ? Column(
                                      children: [
                                        /// 접수 완료
                                        SizedBox(
                                          width: double.maxFinite,
                                          child: Text(StringCalled.reservationStateTitle, style: Theme.of(context).textTheme.displaySmall),
                                        ),
                                        const SizedBox(height: 28),

                                        /// 예약접수
                                        Row(
                                          children: [
                                            Icon(Icons.check_circle, size: 26, color: primaryColor),
                                            const SizedBox(width: 10),
                                            Text(
                                              StringCalled.reservationState1,
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: primaryColor),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),

                                        /// 기사님 호출중
                                        Row(
                                          children: [
                                            Icon(Icons.check_circle, size: 26, color: primaryColor),
                                            const SizedBox(width: 10),
                                            Text(
                                              StringCalled.reservationState2,
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: primaryColor),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),

                                        /// 운행준비
                                        Row(
                                          children: [
                                            Icon(Icons.check_circle, size: 26, color: isWait ? primaryColor : disabledColor),
                                            const SizedBox(width: 10),
                                            Text(
                                              StringCalled.reservationState3,
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isWait ? primaryColor : disabledColor),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),

                                        /// 운행중
                                        Row(
                                          children: [
                                            Icon(Icons.check_circle, size: 26, color: isStart ? primaryColor : disabledColor),
                                            const SizedBox(width: 10),
                                            Text(
                                              StringCalled.reservationState4,
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isStart ? primaryColor : disabledColor),
                                            ),
                                          ],
                                        ),

                                        HorizontalDashedDivider(
                                          thickness: 1,
                                          color: Theme.of(context).disabledColor,
                                          space: 68,
                                          length: 2,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(height: 28);
                            },
                          ),

                          /// 이용 정보 또는 예약 정보
                          ValueListenableBuilder<String>(
                            valueListenable: _callDetailViewModel.drvReqStNotifier,
                            builder: (context, value, child) {
                              return SizedBox(
                                width: double.maxFinite,
                                child: Text(_callDetailViewModel.isReservation() ? StringCalled.reservationTitle : StringCalled.infoTitle, style: Theme.of(context).textTheme.displaySmall),
                              );
                            },
                          ),
                          const SizedBox(height: 28),

                          /// 일시
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(StringCalled.date, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
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
                              Text(StringCalled.callType, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
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
                              Text(StringCalled.driveType, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
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
                                StringCalled.startSpot,
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
                                StringCalled.endSpot,
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
                              Text(StringCalled.payment, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
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

                          /// 기사 정보
                          SizedBox(
                            width: double.maxFinite,
                            child: Text(StringCalled.driverTitle, style: Theme.of(context).textTheme.displaySmall),
                          ),
                          const SizedBox(height: 28),

                          /// 이름
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(StringCalled.driver, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
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
                              Text(StringCalled.car, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                              const SizedBox(width: 14),
                              ValueListenableBuilder<String>(
                                valueListenable: _callDetailViewModel.carNumIdNotifier,
                                builder: (context, value, _) {
                                  return Expanded(child: Text(value, textAlign: TextAlign.start));
                                },
                              ),
                            ],
                          ),

                          ValueListenableBuilder<String>(
                            valueListenable: _callDetailViewModel.drvReqStNotifier,
                            builder: (context, value, child) {
                              return _callDetailViewModel.isReservation()
                                  ? Column(
                                      children: [
                                        HorizontalDashedDivider(
                                          thickness: 1,
                                          color: Theme.of(context).disabledColor,
                                          space: 68,
                                          length: 2,
                                        ),

                                        /// 취소 수수료 안내
                                        SizedBox(
                                          width: double.maxFinite,
                                          child: Text(StringReservation.cancelTitle, style: Theme.of(context).textTheme.displaySmall),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          width: double.maxFinite,
                                          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).dividerColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            StringReservation.cancelContent,
                                            style: Theme.of(context).textTheme.bodySmall,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox();
                            },
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// 예약일 시 하단 버튼
              ValueListenableBuilder<String>(
                valueListenable: _callDetailViewModel.drvReqStNotifier,
                builder: (context, value, child) {
                  return _callDetailViewModel.isReservation()
                      ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              /// 예약 취소 버튼
                              value == DrvReqSt.res || value == DrvReqSt.rco
                                  ? Expanded(
                                      child: CustomRadiusButton(
                                        text: StringCalled.reservationCancel,
                                        onPressed: () async {
                                          // TODO: 예약 취소 API 별도로 있는지 확인 후 예약 취소 기능 구현

                                          /// 호출취소 팝업 띄움
                                          final cancelResult = _callDetailViewModel.drvReqSt == DrvReqSt.res
                                              ?

                                              /// 미확정 호출취소 팝업
                                              await _showConfirmDialog(
                                                  content: StringCalled.reservationCancelConfirm,
                                                  onConfirm: () async {
                                                    /// 미확정 호출취소
                                                    final result = await _callDetailViewModel.cancelCall(drvReqSq: widget.drvReqSq);
                                                    if (result is Success) {
                                                      /// 호출취소 팝업 닫기
                                                      context.pop(true);
                                                    } else if (result is Bad) {
                                                      Fluttertoast.showToast(msg: StringCommon.httpBad);
                                                    } else if (result is Fail) {
                                                      Fluttertoast.showToast(msg: "${result.errorMessage}");
                                                    }
                                                  },
                                                )
                                              :

                                              /// 호출취소 사유 선택 팝업
                                              await _showCallCancelDialog(
                                                  onConfirm: (drvCancelTp) async {
                                                    /// 확정 호출취소
                                                    final result = await _callDetailViewModel.cancelConfirmCall(
                                                      drvReqSq: widget.drvReqSq,
                                                      drvCancelTp: drvCancelTp,
                                                    );
                                                    if (result is Success) {
                                                      /// 호출취소 사유 선택 팝업 닫기
                                                      context.pop(true);
                                                    } else if (result is Bad) {
                                                      Fluttertoast.showToast(msg: StringCommon.httpBad);
                                                    } else if (result is Fail) {
                                                      Fluttertoast.showToast(msg: "${result.errorMessage}");
                                                    }
                                                  },
                                                );

                                          if (cancelResult == true) {
                                            /// 호출 취소 완료 팝업 띄움
                                            await _showAlertDialog(content: StringCalled.reservationCancelSuccess, isCanceled: false);

                                            /// 화면 닫기, 이전 화면 갱신
                                            context.pop(true);
                                          }
                                        },
                                      ),
                                    )
                                  : const SizedBox(),
                              value == DrvReqSt.res || value == DrvReqSt.rco ? const SizedBox(width: 8) : const SizedBox(),

                              /// 대리 추가 호출 버튼
                              Expanded(
                                child: CustomElevatedButton(
                                  text: StringCalled.reservationAdd,
                                  onPressed: () {
                                    /// 홈 화면으로 이동
                                    context.goNamed(HomeScreen.routeName);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox();
                },
              ),
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

  _showAlertDialog({String? title, String? content, bool isWarning = false, bool isCanceled = true}) {
    return showDialog(
      context: context,
      barrierDismissible: isCanceled, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: content,
          isCanceled: isCanceled,
          isWarning: isWarning,
          onConfirm: () {
            context.pop();
          },
        );
      },
    );
  }

  _showConfirmDialog({String? title, String? content, bool isWarning = false, required Function() onConfirm}) {
    return showDialog(
      context: context,
      barrierDismissible: true, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CustomConfirmDialog(
          title: title,
          content: content,
          isWarning: isWarning,
          onConfirm: onConfirm,
        );
      },
    );
  }

  _showCallCancelDialog({required Function(String) onConfirm}) {
    return showDialog(
      context: context,
      barrierDismissible: true, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CallCancelDialog(
          onConfirm: onConfirm,
        );
      },
    );
  }
}
