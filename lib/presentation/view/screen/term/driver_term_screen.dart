import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/domain/usecase/term/get_term_list_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/term/driver_term_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

/// 운행불가 차종안내 화면
class DriverTermScreen extends StatefulWidget {
  const DriverTermScreen({Key? key}) : super(key: key);

  static const String routeName = "driver_term";
  static const String routeURL = "/driver_term";

  @override
  State<DriverTermScreen> createState() => _DriverTermScreenState();
}

class _DriverTermScreenState extends State<DriverTermScreen> {
  late final DriverTermViewModel _driverTermViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  void initViewModel() {
    _driverTermViewModel = DriverTermViewModel(
      getTermUseCase: GetIt.instance<GetTermUseCase>(),
    );
    _driverTermViewModel.getTermDetail();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _driverTermViewModel.termTitleNotifier,
      builder: (context, value, _) {
        return Scaffold(
          /// 상단 앱바
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: value,
          ),

          /// 화면
          body: SafeArea(
            child: Column(
              children: [
                /// 상세 이용약관 본문
                Expanded(
                  child: ScrollConfiguration(
                    behavior: CustomScrollBehavior(),
                    child: SingleChildScrollView(
                      child: ValueListenableBuilder<String>(
                          valueListenable: _driverTermViewModel.termContentNotifier,
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

                /// 하단 버튼
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomElevatedButton(
                    text: StringCommon.confirm,
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
