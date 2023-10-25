import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/inquiry/get_inquiry_detail_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/inquiry/set_inquiry_delete_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/other_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/cs/inquiry_detail_viewmodel.dart';

/// 상담문의 상세 화면
class InquiryDetailScreen extends StatefulWidget {
  const InquiryDetailScreen({
    Key? key,
    required this.inqSq,
  }) : super(key: key);

  static const String routeName = "inquiry_detail";

  final int inqSq;

  @override
  State<InquiryDetailScreen> createState() => _InquiryDetailScreenState();
}

class _InquiryDetailScreenState extends State<InquiryDetailScreen> {
  late final InquiryDetailViewModel _inquiryDetailViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _inquiryDetailViewModel = InquiryDetailViewModel(
      getInquiryDetailUseCase: GetIt.instance<GetInquiryDetailUseCase>(),
      setInquiryDeleteUseCase: GetIt.instance<SetInquiryDeleteUseCase>(),
    );
  }

  void initData() {
    _inquiryDetailViewModel.getInquiryDetail(inqSq: widget.inqSq);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: StringInquiry.inquiryDetail,
        actions: [
          /// 더보기 버튼
          InkWell(
            child: Icon(
              Icons.more_vert,
              color: Theme.of(context).disabledColor,
              size: 30,
            ),
            onTap: () async {
              /// 더보기 팝업 띄움
              final result = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return Wrap(children: [
                    OtherBottomSheet(
                      onDeletePressed: () async {
                        /// 상담문의 삭제 확인팝업 띄움
                        final deleteAlertResult = await _showConfirmDialog(
                          content: StringInquiry.inquiryDeleteAlert,
                          onConfirm: () async {
                            /// 상담문의 삭제
                            final result = await _inquiryDetailViewModel.deleteInquiry(inqSq: widget.inqSq);
                            if (result is Success) {
                              /// 팝업 닫기
                              context.pop(true);
                            }
                          },
                        );

                        if (deleteAlertResult == true) {
                          /// 상담문의 삭제 성공 팝업 띄움
                          await _showAlertDialog(content: StringInquiry.inquiryDeleteSuccessAlert, isCanceled: false);

                          /// 팝업 닫기
                          context.pop(deleteAlertResult);
                        }
                      },
                    )
                  ]);
                },
              );

              if (result == true) {
                /// 화면 닫기, 상담문의 리스트 재조회
                context.pop(result);
              }
            },
          ),
          // ClipOval(
          //   child: Container(
          //     width: 30,
          //     height: 30,
          //     decoration: BoxDecoration(
          //       border: Border.all(color: Theme.of(context).disabledColor, width: 1),
          //       color: Theme.of(context).scaffoldBackgroundColor,
          //       shape: BoxShape.circle,
          //     ),
          //     child: Material(
          //       color: Colors.transparent,
          //       child: InkWell(
          //         child: Icon(
          //           Icons.more_vert,
          //           color: Theme.of(context).disabledColor,
          //           size: 24,
          //         ),
          //         onTap: () async {},
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(width: 20),
        ],
      ),

      /// 화면
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      /// 제목
                      ValueListenableBuilder<String>(
                        valueListenable: _inquiryDetailViewModel.inquiryTitleNotifier,
                        builder: (context, value, _) {
                          return Text(
                            value,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.titleLarge,
                          );
                        },
                      ),

                      /// 답변여부
                      ValueListenableBuilder<bool>(
                        valueListenable: _inquiryDetailViewModel.isAnswerNotifier,
                        builder: (context, value, _) {
                          return Expanded(
                            child: Text(
                              value ? "답변완료" : "답변대기",
                              textAlign: TextAlign.right,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// 날짜
                  ValueListenableBuilder<String>(
                    valueListenable: _inquiryDetailViewModel.inquiryDateNotifier,
                    builder: (context, value, _) {
                      return Text(
                        getDateFormat(date: value, dateFormat: "yyyy.MM.dd HH:mm"),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            /// 상담문의 본문
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: SingleChildScrollView(
                  child: ValueListenableBuilder<String>(
                    valueListenable: _inquiryDetailViewModel.inquiryContentNotifier,
                    builder: (context, value, _) {
                      return Text(value);
                    },
                  ),
                ),
              ),
            ),

            const Divider(thickness: 6, height: 40),

            /// 답변
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 답변자 아이디
                  ValueListenableBuilder<String>(
                    valueListenable: _inquiryDetailViewModel.answerIdNotifier,
                    builder: (context, value, _) {
                      return Text(
                        value,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  /// 답변 내용
                  ValueListenableBuilder<String>(
                    valueListenable: _inquiryDetailViewModel.answerContentNotifier,
                    builder: (context, value, _) {
                      return Text(
                        value,
                        textAlign: TextAlign.start,
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  /// 답변 시간
                  ValueListenableBuilder<String>(
                    valueListenable: _inquiryDetailViewModel.answerDtNotifier,
                    builder: (context, value, _) {
                      return Text(
                        getDateFormat(date: value, dateFormat: "yyyy.MM.dd HH:mm"),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
