import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/notice/get_notice_list_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/cs/notice_detail_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/cs/notice_viewmodel.dart';
import 'package:provider/provider.dart';

/// 공지사항 화면
class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  static const String routeName = "notice";

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> with SingleTickerProviderStateMixin {
  late final NoticeViewModel _noticeViewModel;

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
    _noticeViewModel = NoticeViewModel(
      getNoticeListUseCase: GetIt.instance<GetNoticeListUseCase>(),
    );
  }

  void initScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        initData();
      }
    });
  }

  void initData() {
    /// 공지사항 리스트 가져오기
    _noticeViewModel.getNoticeList();
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<NoticeViewModel>(
          create: (context) => _noticeViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringNotice.title,
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
                    const SizedBox(height: 20),

                    /// 공지사항 리스트
                    ValueListenableBuilder<List<Notice>>(
                      valueListenable: _noticeViewModel.noticeListNotifier,
                      builder: (context, value, _) {
                        return getListView(value);
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

  /// 공지사항 리스트
  Widget getListView(List<Notice> value) {
    return ListView.separated(
      itemCount: value.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            /// 공지사항 리스트 아이템 클릭
            context.pushNamed(
              NoticeDetailScreen.routeName,
              extra: value[index].notiSq,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 제목
              Text(
                value[index].notiTitle ?? "(제목없음)",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),

              /// 날짜
              Text(
                getDateFormat(date: value[index].createDt, dateFormat: "yyyy.MM.dd"),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Column(
          children: [
            Divider(thickness: 1, height: 40),
          ],
        );
      },
    );
  }
}
