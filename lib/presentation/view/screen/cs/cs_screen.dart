import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/term/term_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/term/get_term_list_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/cs/inquiry_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/cs/notice_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/term_detail_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/menu/custom_move_button.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/cs/cs_viewmodel.dart';

/// 고객센터 화면
class CSScreen extends StatefulWidget {
  const CSScreen({Key? key}) : super(key: key);

  static const String routeName = "cs";
  static const String routeURL = "/cs";

  @override
  State<CSScreen> createState() => _CSScreenState();
}

class _CSScreenState extends State<CSScreen> {
  late final CSViewModel _csViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  initViewModel() async {
    _csViewModel = CSViewModel(getTermUseCase: GetIt.instance<GetTermUseCase>());
    await _csViewModel.getTermList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: StringMenu.cs,
      ),

      /// 화면
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// 공지사항 버튼
                CustomMoveButton(
                  text: StringNotice.title,
                  onPressed: () {
                    context.pushNamed(NoticeScreen.routeName);
                  },
                ),

                /// 고객센터 버튼
                CustomMoveButton(
                  text: StringInquiry.title,
                  onPressed: () {
                    context.pushNamed(InquiryScreen.routeName);
                  },
                ),
                const Divider(thickness: 6),

                ValueListenableBuilder(
                  valueListenable: _csViewModel.termListNotifier,
                  builder: (context, value, _) {
                    return getListView(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 이용약관 리스트
  Widget getListView(List<Term> value) {
    return ListView.builder(
      itemCount: value.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return CustomMoveButton(
          text: value[index].trmTitle ?? "(없음)",
          onPressed: () {
            /// 이용약관 상세 화면으로 이동
            context.pushNamed(
              TermDetailScreen.routeName,
              queryParameters: {"trmSq": value[index].trmSq.toString(), "isAgreeButtonEnabled": false.toString()},
            );
          },
        );
      },
    );
  }
}
