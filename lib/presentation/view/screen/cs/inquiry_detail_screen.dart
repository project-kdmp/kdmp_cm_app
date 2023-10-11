import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:kdmp_cm_app/domain/usecase/inquiry/get_inquiry_detail_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/cs/inquiry_detail_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

/// 상담문의 상세 화면
class InquiryDetailScreen extends StatefulWidget {
  const InquiryDetailScreen({
    Key? key,
    required this.inqSq,
  }) : super(key: key);

  static const String routeName = "inquiry_detail";
  static const String routeURL = "/inquiry_detail";

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

            /// 제목
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
            Expanded(
              child: Container(
                width: double.infinity,
                color: Theme.of(context).dividerColor,
                padding: const EdgeInsets.all(20),
                child: ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: SingleChildScrollView(
                    child: ValueListenableBuilder<String>(
                      valueListenable: _inquiryDetailViewModel.inquiryContentNotifier,
                      builder: (context, value, _) {
                        return Html(
                          data: value,
                          onLinkTap: (url, attributes, element) async {
                            debugPrint("$url");
                            if (url != null) {
                              await launchUrl(
                                Uri.parse(url),
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
