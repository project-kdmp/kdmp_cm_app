import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/call_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/called_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_call_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_called_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_called_delete_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/mypage/call_detail_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/mypage/called_detail_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/divider/horizontal_dashed_divider.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/mypage/called_viewmodel.dart';
import 'package:provider/provider.dart';

/// 이용내역 화면
class CalledScreen extends StatefulWidget {
  const CalledScreen({Key? key}) : super(key: key);

  static const String routeName = "called";

  @override
  State<CalledScreen> createState() => _CalledScreenState();
}

class _CalledScreenState extends State<CalledScreen> with SingleTickerProviderStateMixin {
  late final CalledViewModel _calledViewModel;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initViewModel();
    initScrollController();
    initData();
  }

  /// Create
  void initViewModel() {
    _calledViewModel = CalledViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getCallListUseCase: GetIt.instance<GetCallListUseCase>(),
      getCalledListUseCase: GetIt.instance<GetCalledListUseCase>(),
      setCalledDeleteUseCase: GetIt.instance<SetCalledDeleteUseCase>(),
    );
  }

  void initScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        /// 이용내역 리스트 가져오기
        _calledViewModel.getCalledList();
      }
    });
  }

  void initData() {
    /// 페이지 정보 초기화
    _calledViewModel.clearPagination();

    /// 미완료 이용내역 리스트 가져오기
    _calledViewModel.getCallList();

    /// 이용내역 리스트 가져오기
    _calledViewModel.getCalledList();
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<CalledViewModel>(
          create: (context) => _calledViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringCalled.title,
        ),

        /// 화면
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    /// 미완료 이용내역 리스트
                    ValueListenableBuilder<List<Call>>(
                      valueListenable: _calledViewModel.callListNotifier,
                      builder: (context, value, _) {
                        return getCallListView(value);
                      },
                    ),

                    const SizedBox(height: 16),

                    /// 이용내역 리스트
                    ValueListenableBuilder<List<Called>>(
                      valueListenable: _calledViewModel.calledListNotifier,
                      builder: (context, value, _) {
                        return _calledViewModel.callList.isEmpty && value.isEmpty
                            ?

                            /// 이용내역 없음
                            SizedBox(
                                height: 500,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(ImageCommon.imgWarning, width: 72, height: 72),
                                    const SizedBox(height: 20),
                                    Text(
                                      StringCalled.noList,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).disabledColor,
                                          ),
                                    )
                                  ],
                                ),
                              )
                            : getCalledListView(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 미완료 이용내역 리스트
  Widget getCallListView(List<Call> value) {
    return ListView.separated(
      itemCount: value.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        final stopOverList = value[index].stopOverLst;
        String text = stopOverList.isNotEmpty
            ? stopOverList[0].placeName.isNotEmpty
                ? stopOverList[0].placeName
                : stopOverList[0].address
            : "";
        if (stopOverList.length > 1) {
          text += " 외 ${stopOverList.length - 1}";
        }
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            /// 미완료 이용내역 리스트 아이템 클릭
            /// 미완료 이용 정보 화면으로 이동
            final result = await context.pushNamed(
              CallDetailScreen.routeName,
              extra: value[index].drvReqSq,
            );
            if (result == true) {
              /// 이용내역 재조회
              initData();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).disabledColor.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 17,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      /// 일시
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text(getDateAndTimeFormat(startDate: value[index].drvStartDt, endDate: value[index].drvEndDt), textAlign: TextAlign.start)),
                        ],
                      ),

                      HorizontalDashedDivider(
                        thickness: 1,
                        color: Theme.of(context).disabledColor,
                        space: 30,
                        length: 2,
                      ),

                      /// 호출
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(StringCalled.callType, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(getCallType(value[index].drvReqSt), textAlign: TextAlign.start)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// 상태
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(StringCalled.driveType, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(getDriveType(value[index].drvReqSt), textAlign: TextAlign.start)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// 출발지
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(StringCalled.startSpot, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(value[index].reqStartPlaceNm ?? value[index].reqStartAddress ?? "", textAlign: TextAlign.start)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// 경유지
                      text.isNotEmpty
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(StringCalled.stopover, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                                const SizedBox(width: 12),
                                Expanded(child: Text(text, textAlign: TextAlign.start)),
                              ],
                            )
                          : const SizedBox(),
                      text.isNotEmpty ? const SizedBox(height: 8) : const SizedBox(),

                      /// 도착지
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(StringCalled.endSpot, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(value[index].reqEndPlaceNm ?? value[index].reqEndAddress ?? "", textAlign: TextAlign.start)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// 요금
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(StringCalled.amount, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(getPrice(value[index].drvPaymPrice), textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).colorScheme.secondary))),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// 결제
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(StringCalled.payment, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(getPaymentKind(value[index].paymKind), textAlign: TextAlign.start)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Column(
          children: [
            SizedBox(height: 16),
          ],
        );
      },
    );
  }

  /// 이용내역 리스트
  Widget getCalledListView(List<Called> value) {
    return ListView.separated(
      itemCount: value.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        final stopOverList = value[index].stopOverLst;
        String text = stopOverList.isNotEmpty
            ? stopOverList[0].placeName.isNotEmpty
                ? stopOverList[0].placeName
                : stopOverList[0].address
            : "";
        if (stopOverList.length > 1) {
          text += " 외 ${stopOverList.length - 1}";
        }
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            /// 이용내역 리스트 아이템 클릭
            /// 이용 정보 화면으로 이동
            final result = await context.pushNamed(
              CalledDetailScreen.routeName,
              extra: value[index].drvReqSq,
            );
            if (result == true) {
              /// 이용내역 재조회
              initData();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).disabledColor.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 17,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 일시
                          Expanded(child: Text(getDateAndTimeFormat(startDate: value[index].drvStartDt, endDate: value[index].drvEndDt), textAlign: TextAlign.start)),

                          /// 삭제 버튼
                          GestureDetector(
                            onTap: () async {
                              /// 이용내역 삭제 확인 팝업
                              final deleteResult = await _showConfirmDialog(
                                content: StringCalled.deleteAlert,
                                onConfirm: () async {
                                  /// 이용내역 삭제
                                  final deleteResult = await _calledViewModel.deleteCalled(drvReqSq: value[index].drvReqSq);
                                  if (deleteResult is Success) {
                                    /// 이용내역 삭제 확인 팝업 닫기
                                    context.pop(true);
                                  } else if (deleteResult is Bad) {
                                    Fluttertoast.showToast(msg: StringCommon.httpBad);
                                  } else if (deleteResult is Fail) {
                                    Fluttertoast.showToast(msg: "${deleteResult.errorMessage}");
                                  }
                                },
                              );
                              if (deleteResult == true) {
                                /// 이용내역 삭제 완료 팝업
                                await _showAlertDialog(content: StringCalled.deleteSuccess, isCanceled: false);

                                /// 리스트 갱신
                                initData();
                              }
                            },
                            child: Text(StringCalled.delete, style: TextStyle(color: Theme.of(context).disabledColor)),
                          ),
                        ],
                      ),

                      HorizontalDashedDivider(
                        thickness: 1,
                        color: Theme.of(context).disabledColor,
                        space: 30,
                        length: 2,
                      ),

                      /// 호출
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(StringCalled.callType, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(getCallType(value[index].drvReqSt), textAlign: TextAlign.start)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// 상태
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(StringCalled.driveType, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(getDriveType(value[index].drvReqSt), textAlign: TextAlign.start)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// 출발지
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(StringCalled.startSpot, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(value[index].reqStartPlaceNm ?? value[index].reqStartAddress ?? "", textAlign: TextAlign.start)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// 경유지
                      text.isNotEmpty
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(StringCalled.stopover, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                                const SizedBox(width: 12),
                                Expanded(child: Text(text, textAlign: TextAlign.start)),
                              ],
                            )
                          : const SizedBox(),
                      text.isNotEmpty ? const SizedBox(height: 8) : const SizedBox(),

                      /// 도착지
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(StringCalled.endSpot, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(value[index].reqEndPlaceNm ?? value[index].reqEndAddress ?? "", textAlign: TextAlign.start)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// 요금
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(StringCalled.amount, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(getPrice(value[index].drvPaymPrice), textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).colorScheme.secondary))),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// 결제
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(StringCalled.payment, textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).disabledColor)),
                          const SizedBox(width: 12),
                          // TODO: 결제유형 확인
                          Expanded(child: Text("", textAlign: TextAlign.start)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Column(
          children: [
            SizedBox(height: 16),
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
