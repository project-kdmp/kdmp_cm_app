import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:kdmp_cm_app/domain/usecase/notice/get_notice_detail_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/cs/notice_detail_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

/// 공지사항 상세 화면
class NoticeDetailScreen extends StatefulWidget {
  const NoticeDetailScreen({
    Key? key,
    required this.notiSq,
  }) : super(key: key);

  static const String routeName = "notice_detail";
  static const String routeURL = "/notice_detail";

  final int notiSq;

  @override
  State<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  late final NoticeDetailViewModel _noticeDetailViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _noticeDetailViewModel = NoticeDetailViewModel(
      getNoticeDetailUseCase: GetIt.instance<GetNoticeDetailUseCase>(),
    );
  }

  void initData() {
    _noticeDetailViewModel.getNoticeDetail(notiSq: widget.notiSq);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: StringNotice.noticeDetail,
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
                    valueListenable: _noticeDetailViewModel.noticeTitleNotifier,
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
                    valueListenable: _noticeDetailViewModel.noticeDateNotifier,
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

            /// 공지사항 본문
            Expanded(
              child: Container(
                width: double.infinity,
                color: Theme.of(context).dividerColor,
                padding: const EdgeInsets.all(20),
                child: ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: SingleChildScrollView(
                    child: ValueListenableBuilder<String>(
                      valueListenable: _noticeDetailViewModel.noticeContentNotifier,
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
