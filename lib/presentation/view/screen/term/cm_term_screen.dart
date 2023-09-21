import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/register/register_request.dart';
import 'package:kdmp_cm_app/data/model/term/cm_term_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/term/get_term_list_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/checkbox/custom_checkbox.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/term/term_checkbox.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/term/cm_term_viewmodel.dart';
import 'package:provider/provider.dart';

import 'term_detail_screen.dart';

/// 미동의 이용약관 화면
class CMTermScreen extends StatefulWidget {
  const CMTermScreen({Key? key}) : super(key: key);

  static const String routeName = "cm_term";
  static const String routeURL = "/cm_term";

  @override
  State<CMTermScreen> createState() => _CMTermScreenState();
}

class _CMTermScreenState extends State<CMTermScreen> {
  late final CMTermViewModel _cmCMTermViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  initViewModel() async {
    _cmCMTermViewModel = CMTermViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getTermUseCase: GetIt.instance<GetTermUseCase>(),
    );
    await _cmCMTermViewModel.getCMTermList();
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<CMTermViewModel>(
          create: (context) => _cmCMTermViewModel,
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
                            const SizedBox(height: 20),
                            const Text(
                              StringTerm.content,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),

                            /// 로고
                            Padding(
                              padding: const EdgeInsets.only(top: 50, bottom: 60),
                              child: Image.asset(ImageCommon.appLogo, width: 120, height: 120),
                            ),

                            /// 전체 이용약관
                            Row(
                              children: [
                                /// ValueNotifier 는 안드로이드로 치면 LiveData 라고 생각하시면 됩니다
                                /// 안드로이드에서 LiveData 의 상태변화를 observe 를 통해서 관찰하는 것처럼,
                                /// 플러터의 ValueNotifier 상태변화는 하기 ValueListenableBuilder 를 통해서 관찰할 수 있습니다
                                ValueListenableBuilder<bool>(
                                  valueListenable: _cmCMTermViewModel.isAllCheckNotifier,
                                  builder: (context, value, _) {
                                    return CustomCheckBox(
                                      isChecked: value,
                                      isBold: true,
                                      message: StringTerm.allAgree,
                                      onPressed: (isChecked) {
                                        _cmCMTermViewModel.setAgreeTermToAll(isAgreeYn: isChecked);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),

                            /// 경계선
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Divider(),
                            ),

                            /// 이용약관 리스트
                            ValueListenableBuilder<List<Term>>(
                              valueListenable: _cmCMTermViewModel.termListNotifier,
                              builder: (context, termList, _) {
                                return ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: termList.length,
                                  itemBuilder: (context, index) {
                                    return ValueListenableBuilder<List<AgreeTerm>>(
                                      valueListenable: _cmCMTermViewModel.agreeTermListNotifier,
                                      builder: (context, agreeTermList, _) {
                                        return TermCheckBox(
                                          isMandatory: termList[index].trmMandatoryYn == "Y",
                                          message: termList[index].trmTitle ?? "(없음)",
                                          isChecked: agreeTermList[index].agreeYn == "Y",
                                          onPressed: (isChecked) {
                                            _cmCMTermViewModel.setAgreeTermToIndex(index: index, isAgreeYn: isChecked == true);
                                          },
                                          onDetailPressed: () async {
                                            /// 상세화면에서 '동의'를 했으면, 체크박스를 체크
                                            bool? isAgreed = await context.pushNamed(
                                              TermDetailScreen.routeName,
                                              queryParameters: {"trmSq": termList[index].trmSq.toString()},
                                            );
                                            if (isAgreed != null) {
                                              _cmCMTermViewModel.setAgreeTermToIndex(index: index, isAgreeYn: isAgreed);
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
                      valueListenable: _cmCMTermViewModel.isValidNotifier,
                      builder: (context, value, _) {
                        return CustomElevatedButton(
                          text: StringTerm.bottomButton,
                          isEnabled: value,
                          onPressed: () {
                            // TODO: 이용약관 동의여부 저장

                            // /// 홈 화면으로 이동
                            // context.goNamed(
                            //   HomeScreen.routeName,
                            // );
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
