import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kdmp_cm_app/domain/usecase/inquiry/get_inquiry_detail_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
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
                        getDateFormat(date: value, dateFormat: "yyyy.MM.dd"),
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

                  /// 내용
                  ValueListenableBuilder<String>(
                    valueListenable: _inquiryDetailViewModel.answerContentNotifier,
                    builder: (context, value, _) {
                      return Text(
                        value,
                        textAlign: TextAlign.start,
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
}
