import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/common/fcm/notification.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_push_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/get_jwt_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_call_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_fee_change_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_confirm_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_review_write_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/call_price_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/review_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/call_cancel_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_round_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/divider/vertical_dashed_divider.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/work/work_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// 운행 화면
class WorkScreen extends StatefulWidget {
  const WorkScreen({
    Key? key,
    required this.drvReqSq,
  }) : super(key: key);

  static const String routeName = "work";
  static const String routeURL = "/work";

  final int drvReqSq;

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  late final WorkViewModel _workViewModel;

  String accessToken = "";

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() async {
    _workViewModel = WorkViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getCallInfoUseCase: GetIt.instance<GetCallInfoUseCase>(),
      setCallCancelUseCase: GetIt.instance<SetCallCancelUseCase>(),
      setConfirmCallCancelUseCase: GetIt.instance<SetConfirmCallCancelUseCase>(),
      setCallFeeChangeUseCase: GetIt.instance<SetCallFeeChangeUseCase>(),
      setReviewWriteUseCase: GetIt.instance<SetReviewWriteUseCase>(),
      setFCMPushUseCase: GetIt.instance<SetFCMPushUseCase>(),
    );
  }

  void initData() async {
    /// 저장된 인증 토큰 가져오기
    accessToken = await GetIt.instance<GetJwtUseCase>().execute();

    /// 호출정보 조회
    _workViewModel.getCallInfo(drvReqSq: widget.drvReqSq);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<WorkViewModel>(
          create: (context) => _workViewModel,
        ),
      ],
      child: Scaffold(
        /// 화면
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: CustomScrollBehavior(),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// 호출취소 버튼
                                ValueListenableBuilder<bool>(
                                  valueListenable: _workViewModel.isCancelVisibleNotifier,
                                  builder: (context, value, child) {
                                    return value
                                        ? CustomRoundButton(
                                            text: StringWork.cancel,
                                            backgroundColor: Theme.of(context).toggleButtonsTheme.fillColor,
                                            textColor: Theme.of(context).colorScheme.secondary,
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                            onPressed: () async {
                                              /// 호출취소 팝업 띄움
                                              final cancelResult = _workViewModel.drvReqSt == DrvReqSt.cal
                                                  ?

                                                  /// 미확정 호출취소 팝업
                                                  await _showConfirmDialog(
                                                      content: StringWork.cancelConfirm,
                                                      onConfirm: () async {
                                                        /// 미확정 호출취소
                                                        final result = await _workViewModel.cancelCall(drvReqSq: widget.drvReqSq);
                                                        if (result is Success) {
                                                          /// 호출취소 팝업 닫기
                                                          context.pop(true);
                                                        }
                                                      },
                                                    )
                                                  :

                                                  /// 호출취소 사유 선택 팝업
                                                  await _showCallCancelDialog(
                                                      onConfirm: (drvCancelTp) async {
                                                        /// 확정 호출취소
                                                        final result = await _workViewModel.cancelConfirmCall(
                                                          drvReqSq: widget.drvReqSq,
                                                          drvCancelTp: drvCancelTp,
                                                        );
                                                        if (result is Success) {
                                                          /// 호출취소 사유 선택 팝업 닫기
                                                          context.pop(true);
                                                        }
                                                      },
                                                    );

                                              if (cancelResult == true) {
                                                /// 호출 취소 완료 팝업 띄움
                                                await _showAlertDialog(content: StringWork.cancelSuccess, isCanceled: false);

                                                /// 화면 닫기, 홈 화면 초기화
                                                context.pop(false);
                                              }
                                            },
                                          )
                                        : const SizedBox();
                                  },
                                ),

                                /// 전화 버튼
                                ValueListenableBuilder<String>(
                                  valueListenable: _workViewModel.callNumberNotifier,
                                  builder: (context, value, child) {
                                    return value.isNotEmpty ? getCallButton(value) : const SizedBox();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 80),

                            ValueListenableBuilder<String>(
                              valueListenable: _workViewModel.drvReqStNotifier,
                              builder: (context, value, child) {
                                return value == DrvReqSt.cal
                                    ? Column(
                                        children: [
                                          Image.asset(ImageWork.imgWork, width: 90, height: 90),
                                          const SizedBox(height: 24),
                                          Text(StringWork.calling, style: Theme.of(context).textTheme.displaySmall),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          /// 프로필 사진
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(66),
                                              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(60),
                                              child: ValueListenableBuilder<String>(
                                                valueListenable: _workViewModel.imagePathNotifier,
                                                builder: (context, value, _) {
                                                  return Image.network(
                                                    "${AppConstants.IMAGE_URL}$value",
                                                    headers: Map.from({"SCLAuthorization": "Bearer $accessToken"}),
                                                    fit: BoxFit.cover,
                                                    width: 88,
                                                    height: 88,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Container(
                                                        width: 88,
                                                        height: 88,
                                                        color: Theme.of(context).scaffoldBackgroundColor,
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 24),

                                          /// 기사명
                                          ValueListenableBuilder(
                                            valueListenable: _workViewModel.nameNotifier,
                                            builder: (context, value, _) {
                                              return Text("$value ${StringCommon.driver}", style: Theme.of(context).textTheme.displaySmall);
                                            },
                                          ),
                                        ],
                                      );
                              },
                            ),

                            const SizedBox(height: 60),
                            const Divider(thickness: 1, height: 72),

                            /// 출발지
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 22,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    StringWork.start,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                ValueListenableBuilder<String>(
                                  valueListenable: _workViewModel.startNotifier,
                                  builder: (context, value, child) {
                                    return Expanded(child: Text(value, style: Theme.of(context).textTheme.titleMedium));
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            /// 경유지
                            ValueListenableBuilder<List<StopOver>>(
                              valueListenable: _workViewModel.stopOverListNotifier,
                              builder: (context, value, child) {
                                String text = value.isNotEmpty
                                    ? value[0].placeName.isNotEmpty
                                        ? value[0].placeName
                                        : value[0].address
                                    : "";
                                if (value.length > 1) {
                                  text += " 외 ${value.length - 1}";
                                }
                                return value.isNotEmpty
                                    ? Row(
                                        children: [
                                          SizedBox(
                                            height: 60,
                                            child: VerticalDashedDivider(
                                              thickness: 1,
                                              color: Theme.of(context).colorScheme.secondary,
                                              space: 22,
                                              length: 2,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 70,
                                            child: Text(
                                              StringWork.stopOver,
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: Theme.of(context).colorScheme.secondary,
                                                  ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Expanded(child: Text(text, style: Theme.of(context).textTheme.titleMedium)),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          SizedBox(
                                            height: 24,
                                            child: VerticalDashedDivider(
                                              thickness: 1,
                                              color: Theme.of(context).colorScheme.secondary,
                                              space: 22,
                                              length: 2,
                                            ),
                                          ),
                                        ],
                                      );
                              },
                            ),
                            const SizedBox(height: 12),

                            /// 도착지
                            Row(
                              children: [
                                Icon(
                                  Icons.flag,
                                  size: 22,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    StringWork.end,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                ValueListenableBuilder<String>(
                                  valueListenable: _workViewModel.endNotifier,
                                  builder: (context, value, child) {
                                    return Expanded(child: Text(value, style: Theme.of(context).textTheme.titleMedium));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(thickness: 6, height: 72),

                /// 결제
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text(
                              StringWork.payment,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          ValueListenableBuilder<String>(
                            valueListenable: _workViewModel.paymKindNotifier,
                            builder: (context, value, child) {
                              return Expanded(child: Text(getPaymentKind(value), style: Theme.of(context).textTheme.bodyLarge));
                            },
                          ),
                        ],
                      ),

                      /// 요금
                      ValueListenableBuilder<int>(
                        valueListenable: _workViewModel.priceNotifier,
                        builder: (context, value, child) {
                          return Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: Text(
                                  StringWork.price,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                  textAlign: TextAlign.left,
                                ),
                              ),

                              Expanded(child: Text(getPrice(value), style: Theme.of(context).textTheme.bodyLarge)),

                              /// 요금 변경 버튼
                              ValueListenableBuilder<bool>(
                                valueListenable: _workViewModel.isPriceInputVisibleNotifier,
                                builder: (context, buttonValue, child) {
                                  return buttonValue
                                      ? CustomRoundButton(
                                          text: StringHome.changeButton,
                                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                          textColor: Theme.of(context).colorScheme.secondary,
                                          borderColor: Theme.of(context).cardColor,
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                          onPressed: () async {
                                            /// 요금 직접 입력 팝업 띄움
                                            final result = await showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return Wrap(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                      child: CallPriceBottomSheet(
                                                        initPrice: value,
                                                        minPrice: value + 1000,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            if (result != null) {
                                              final changeCallFeeResult = await _workViewModel.changeCallFee(
                                                drvReqSq: widget.drvReqSq,
                                                newPrice: result,
                                              );
                                              if (changeCallFeeResult is Success) {
                                                _showAlertDialog(content: StringWork.changeCallFeeAlert, isCanceled: false);
                                              }
                                            }
                                          },
                                        )
                                      : const SizedBox(height: 40);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                StreamBuilder<Map<String, dynamic>>(
                  stream: FlutterLocalNotification.streamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _showPushDialog(snapshot);
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showPushDialog(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    debugPrint("========${snapshot.data}");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 다른 팝업이 열려있으면 닫기
      if (ModalRoute.of(context)?.isCurrent != true) {
        context.pop();
      }
      final type = snapshot.data?["type"] ?? "";
      final title = snapshot.data?["title"] ?? "";
      final body = snapshot.data?["body"] ?? "";
      switch (type) {
        case DrvReqSt.cco:
          _workViewModel.getCallInfo(drvReqSq: widget.drvReqSq);
          _showAlertDialog(content: body, isCanceled: false);
          break;
        case DrvReqSt.rwt:
        case DrvReqSt.wat:
        case DrvReqSt.sta:
          _workViewModel.drvReqSt = type;
          _showAlertDialog(content: body, isCanceled: false);
          break;
        case DrvReqSt.end:
        case DrvReqSt.ren:
          _showReviewBottomSheet(type);
          break;
        case DrvReqSt.del:
        case DrvReqSt.rdl:
          context.pop();
          _showAlertDialog(content: body, isCanceled: false);
          break;
        default:
          _workViewModel.getCallInfo(drvReqSq: widget.drvReqSq);
          _showAlertDialog(content: body, isCanceled: false);
      }
    });
  }

  /// 리뷰 작성 팝업
  Future<void> _showReviewBottomSheet(String drvReqSt) async {
    /// 상태 변경
    // TODO: API 재조회할지 변경된 값만 Push Data 값으로 받을지
    // _workViewModel.getCallInfo(drvReqSq: widget.drvReqSq);
    _workViewModel.drvReqSt = drvReqSt;

    await showModalBottomSheet(
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
                  final result = await _workViewModel.writeReview(drvReqSq: widget.drvReqSq, reviewContent: review, starPoint: star);
                  if (result is Success) {
                    /// 리뷰 작성 팝업 닫기
                    context.pop();
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

  /// 앱 뒤로가기
  Future<bool> _onBackPressed() async {
    /// 운행이 종료된 경우에만 뒤로가기
    if (isWorkEnd()) {
      return true;
    }
    return false;
  }

  /// 운행 종료 여부 체크
  bool isWorkEnd() {
    return _workViewModel.drvReqSt == DrvReqSt.end || _workViewModel.drvReqSt == DrvReqSt.ren || _workViewModel.drvReqSt == DrvReqSt.rco || _workViewModel.drvReqSt == DrvReqSt.del;
  }

  /// 전화 버튼
  Widget getCallButton(String callNumber) {
    return CustomRoundButton(
      text: StringWork.call,
      icon: Icons.call,
      backgroundColor: Theme.of(context).toggleButtonsTheme.fillColor,
      textColor: Theme.of(context).colorScheme.secondary,
      onPressed: () async {
        /// 전화걸기 다이얼 화면 띄움
        if (callNumber.trim().isNotEmpty) {
          makePhoneCall(callNumber);
        }
      },
    );
  }

  /// 전화걸기
  void makePhoneCall(String url) async {
    var telUrl = 'tel:$url';
    if (Platform.isIOS) {
      telUrl = telUrl.replaceAll((RegExp(r'-')), '');
    }
    if (await canLaunchUrl(Uri(scheme: 'tel', path: url))) {
      await launchUrl(Uri(scheme: 'tel', path: url));
    }
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
