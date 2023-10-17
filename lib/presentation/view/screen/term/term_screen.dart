import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/register/register_request.dart';
import 'package:kdmp_cm_app/data/model/term/term_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/term/get_term_list_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/register/register_verify_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/checkbox/custom_checkbox.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/term/term_checkbox.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/term/term_viewmodel.dart';
import 'package:provider/provider.dart';

import 'term_detail_screen.dart';

/// 이용약관 화면
class TermScreen extends StatefulWidget {
  const TermScreen({Key? key}) : super(key: key);

  static const String routeName = "term";
  static const String routeURL = "/term";

  @override
  State<TermScreen> createState() => _TermScreenState();
}

class _TermScreenState extends State<TermScreen> {
  late final TermViewModel _termViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  initViewModel() async {
    _termViewModel = TermViewModel(getTermUseCase: GetIt.instance<GetTermUseCase>());
    await _termViewModel.getTermList();
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<TermViewModel>(
          create: (context) => _termViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringTerm.title,
          backButtonVisible: false,
        ),

        /// 화면
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: CustomScrollBehavior(),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            /// 로고
                            Padding(
                              padding: const EdgeInsets.only(top: 50, bottom: 60),
                              child: Image.asset(ImageCommon.appLogo, width: 120, height: 120),
                            ),

                            /// 전체 이용약관
                            ValueListenableBuilder<bool>(
                              valueListenable: _termViewModel.isAllCheckNotifier,
                              builder: (context, value, _) {
                                return CustomCheckBox(
                                  isChecked: value,
                                  isBold: true,
                                  message: StringTerm.allAgree,
                                  onPressed: (isChecked) {
                                    _termViewModel.setAgreeTermToAll(isAgreeYn: isChecked);
                                  },
                                );
                              },
                            ),

                            /// 경계선
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Divider(),
                            ),

                            /// 이용약관 리스트
                            ValueListenableBuilder<List<Term>>(
                              valueListenable: _termViewModel.termListNotifier,
                              builder: (context, termList, _) {
                                return ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: termList.length,
                                  itemBuilder: (context, index) {
                                    return ValueListenableBuilder<List<TempAgreeTerm>>(
                                      valueListenable: _termViewModel.agreeTermListNotifier,
                                      builder: (context, agreeTermList, _) {
                                        return TermCheckBox(
                                          isMandatory: termList[index].trmMandatoryYn == "Y",
                                          message: termList[index].trmTitle ?? "(없음)",
                                          isChecked: agreeTermList[index].agreeYn == "Y",
                                          onPressed: (isChecked) {
                                            _termViewModel.setAgreeTermToIndex(index: index, isAgreeYn: isChecked == true);
                                          },
                                          onDetailPressed: () async {
                                            /// 상세화면에서 '동의'를 했으면, 체크박스를 체크
                                            bool? isAgreed = await context.pushNamed(
                                              TermDetailScreen.routeName,
                                              queryParameters: {"trmSq": termList[index].trmSq.toString()},
                                            );
                                            if (isAgreed != null) {
                                              _termViewModel.setAgreeTermToIndex(index: index, isAgreeYn: isAgreed);
                                            }
                                          },
                                        );
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) => const SizedBox(
                                    height: 10,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// 하단 버튼
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _termViewModel.isValidNotifier,
                      builder: (context, value, _) {
                        return CustomElevatedButton(
                          text: StringTerm.bottomButton,
                          isEnabled: value,
                          onPressed: () {
                            /// 본인인증 화면으로 이동
                            context.pushNamed(
                              RegisterVerifyScreen.routeName,
                              extra: _termViewModel.agreeTermList,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 앱 뒤로가기
  Future<bool> _onBackPressed() async {
    /// 앱종료
    SystemNavigator.pop();
    return true;
  }
}
