import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:kdmp_cm_app/domain/usecase/term/get_term_list_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/term/term_detail_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

/// 이용약관 상세 화면
class TermDetailScreen extends StatefulWidget {
  const TermDetailScreen({
    Key? key,
    required this.trmSq,
    required this.isAgreeButtonEnabled,
  }) : super(key: key);

  static const String routeName = "term_detail";
  static const String routeURL = "/term_detail";

  final int trmSq;
  final bool isAgreeButtonEnabled;

  @override
  State<TermDetailScreen> createState() => _TermDetailScreenState();
}

class _TermDetailScreenState extends State<TermDetailScreen> {
  late final TermDetailViewModel _termDetailViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _termDetailViewModel = TermDetailViewModel(
      getTermUseCase: GetIt.instance<GetTermUseCase>(),
    );
  }

  void initData() {
    _termDetailViewModel.getTermDetail(trmSq: widget.trmSq);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: ValueListenableBuilder<String>(
            valueListenable: _termDetailViewModel.termTitleNotifier,
            builder: (context, value, _) {
              return BaseAppBar(
                appBar: AppBar(),
                title: value,
              );
            }),
      ),

      /// 화면
      body: SafeArea(
        child: Column(
          children: [
            /// 상세 이용약관 본문
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: SingleChildScrollView(
                    child: ValueListenableBuilder<String>(
                        valueListenable: _termDetailViewModel.termContentNotifier,
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
                        }),
                  ),
                ),
              ),
            ),

            /// 하단 버튼
            widget.isAgreeButtonEnabled
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomElevatedButton(
                      text: StringTerm.bottomButton,
                      onPressed: () {
                        if (context.mounted) Navigator.pop(context, true);
                      },
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
