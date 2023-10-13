import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/mypage/call_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/called_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_call_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_called_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
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
            /// 미완료 이용내역 화면으로 이동
            context.pushNamed(
              CalledDetailScreen.routeName,
              extra: value[index].drvReqSq,
            );
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
                          Expanded(child: Text(value[index].reqStartAddress ?? "", textAlign: TextAlign.start)),
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
                          Expanded(child: Text(value[index].reqEndAddress ?? "", textAlign: TextAlign.start)),
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
            /// 이용내역 화면으로 이동
            context.pushNamed(
              CalledDetailScreen.routeName,
              extra: value[index].drvReqSq,
            );
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
                          GestureDetector(
                            onTap: () {
                              /// TODO: 이용내역 삭제
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
}
