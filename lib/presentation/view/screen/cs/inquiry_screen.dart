import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/inquiry/get_inquiry_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/cs/inquiry_detail_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/cs/inquiry_viewmodel.dart';
import 'package:provider/provider.dart';

/// 상담문의 화면
class InquiryScreen extends StatefulWidget {
  const InquiryScreen({Key? key}) : super(key: key);

  static const String routeName = "inquiry";

  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> with SingleTickerProviderStateMixin {
  late final InquiryViewModel _inquiryViewModel;

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
    _inquiryViewModel = InquiryViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getInquiryListUseCase: GetIt.instance<GetInquiryListUseCase>(),
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
    /// 상담문의 리스트 가져오기
    _inquiryViewModel.getInquiryList();
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<InquiryViewModel>(
          create: (context) => _inquiryViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringInquiry.title,
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

                    /// 상담문의 리스트
                    ValueListenableBuilder<List<Inquiry>>(
                      valueListenable: _inquiryViewModel.inquiryListNotifier,
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

  /// 상담문의 리스트
  Widget getListView(List<Inquiry> value) {
    return ListView.separated(
      itemCount: value.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            /// 상담문의 리스트 아이템 클릭
            context.pushNamed(
              InquiryDetailScreen.routeName,
              extra: value[index].inqSq,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 제목
              Text(
                value[index].inqAskTitle ?? "(제목없음)",
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
