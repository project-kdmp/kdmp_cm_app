import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/term/term_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/term/get_term_list_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/term_detail_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/menu/custom_move_button.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/menu/term_list_viewmodel.dart';

/// 메뉴 > 이용약관 화면
class TermListScreen extends StatefulWidget {
  const TermListScreen({Key? key}) : super(key: key);

  static const String routeName = "term_list";
  static const String routeURL = "/term_list";

  @override
  State<TermListScreen> createState() => _TermListScreenState();
}

class _TermListScreenState extends State<TermListScreen> {
  late final TermListViewModel _termListViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  initViewModel() async {
    _termListViewModel = TermListViewModel(getTermUseCase: GetIt.instance<GetTermUseCase>());
    await _termListViewModel.getTermList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: StringMenu.terms,
      ),

      /// 화면
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                ValueListenableBuilder(
                  valueListenable: _termListViewModel.termListNotifier,
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
