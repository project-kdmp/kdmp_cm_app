import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/url.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/call_price_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custon_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/home/home_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_round_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/divider/vertical_dashed_divider.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/work/work_viewmodel.dart';
import 'package:provider/provider.dart';

/// 운행 화면
class WorkScreen extends StatefulWidget {
  const WorkScreen({Key? key}) : super(key: key);

  static const String routeName = "work";

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  late final WorkViewModel _workViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  initViewModel() async {
    _workViewModel = WorkViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
    );

    // TODO: 해당 운행 조회
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
        body: SafeArea(
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              /// 호출취소 버튼
                              CustomRoundButton(
                                text: StringWork.cancel,
                                backgroundColor: Theme.of(context).toggleButtonsTheme.fillColor,
                                textColor: Theme.of(context).colorScheme.secondary,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                onPressed: () async {
                                  /// 호출취소 팝업 띄움
                                  await _showConfirmDialog(
                                    content: StringCar.deleteAlert,
                                    onConfirm: () async {
                                      Navigator.pop(context);

                                      // TODO: 호출취소 사유 선택

                                      // TODO: 호출취소
                                      // final result = await _workViewModel.cancelCall;
                                      // if (result is Success) {
                                      await _showAlertDialog(content: StringWork.cancelSuccess, isCanceled: false);

                                      /// 홈 화면으로 이동
                                      context.goNamed(HomeScreen.routeName);
                                      // } else if (result is Bad) {
                                      //   Fluttertoast.showToast(msg: StringCommon.httpBad);
                                      // } else if (result is Fail) {
                                      //   Fluttertoast.showToast(msg: "${result.errorMessage}");
                                      // }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 80),

                          false
                              ? Column(
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
                                            return value.isNotEmpty
                                                ? Image.network(
                                                    "$baseImageUrl$value",
                                                    fit: BoxFit.cover,
                                                    width: 88,
                                                    height: 88,
                                                  )
                                                : Container(
                                                    width: 88,
                                                    height: 88,
                                                    color: Theme.of(context).scaffoldBackgroundColor,
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
                                )
                              : Column(
                                  children: [
                                    Image.asset(ImageWork.imgWork, width: 90, height: 90),
                                    const SizedBox(height: 24),
                                    Text(StringWork.calling, style: Theme.of(context).textTheme.displaySmall),
                                  ],
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
                              Expanded(child: Text("우림라이온스밸리2차", style: Theme.of(context).textTheme.titleMedium)),
                            ],
                          ),
                          const SizedBox(height: 12),

                          /// 경유지
                          false
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
                                    Expanded(child: Text("빨호떡볶이 외 2", style: Theme.of(context).textTheme.titleMedium)),
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
                              Expanded(child: Text("빨호떡볶이 외 2", style: Theme.of(context).textTheme.titleMedium)),
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
                        Expanded(child: Text("신용/체크카드", style: Theme.of(context).textTheme.bodyLarge)),
                      ],
                    ),

                    /// 요금
                    Row(
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

                        Expanded(child: Text(getPrice(28000), style: Theme.of(context).textTheme.bodyLarge)),

                        /// 요금 변경 버튼
                        CustomRoundButton(
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
                                      child: CallPriceBottomSheet(minPrice: 28000, initPrice: 28000.toString()),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (result != null) {
                              // _workViewModel.inputPrice = result;
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 운행 확정 팝업
  Future<void> showCallConfirmAlert() async {
    _showAlertDialog(content: StringWork.callConfirmAlert, isCanceled: false);
    // TODO: 상태 변경
    // _workViewModel.
  }

  /// 출발지 도착 팝업
  Future<void> showStartAlert() async {
    _showAlertDialog(content: StringWork.callStartAlert, isCanceled: false);
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
            Navigator.pop(context);
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
}
