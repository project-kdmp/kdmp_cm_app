import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/term/cm_term_list_response.dart';
import 'package:kdmp_cm_app/data/model/term/my_term_request.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/term/get_term_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/term/set_my_term_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/home/home_screen.dart';
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
  late final CMTermViewModel _cmTermViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  initViewModel() async {
    _cmTermViewModel = CMTermViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getTermUseCase: GetIt.instance<GetTermUseCase>(),
      setMyTermUseCase: GetIt.instance<SetMyTermUseCase>(),
    );
    await _cmTermViewModel.getCMTermList();
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<CMTermViewModel>(
          create: (context) => _cmTermViewModel,
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
                            ValueListenableBuilder<bool>(
                              valueListenable: _cmTermViewModel.isAllCheckNotifier,
                              builder: (context, value, _) {
                                return CustomCheckBox(
                                  isChecked: value,
                                  isBold: true,
                                  message: StringTerm.allAgree,
                                  onPressed: (isChecked) {
                                    _cmTermViewModel.setAgreeTermToAll(isAgreeYn: isChecked);
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
                              valueListenable: _cmTermViewModel.termListNotifier,
                              builder: (context, termList, _) {
                                return ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: termList.length,
                                  itemBuilder: (context, index) {
                                    return ValueListenableBuilder<List<TempAgreeTerm>>(
                                      valueListenable: _cmTermViewModel.tempAgreeTermListNotifier,
                                      builder: (context, agreeTermList, _) {
                                        return TermCheckBox(
                                          isMandatory: termList[index].trmMandatoryYn == "Y",
                                          message: termList[index].trmTitle ?? "(없음)",
                                          isChecked: agreeTermList[index].agreeYn == "Y",
                                          onPressed: (isChecked) {
                                            _cmTermViewModel.setAgreeTermToIndex(index: index, isAgreeYn: isChecked == true);
                                          },
                                          onDetailPressed: () async {
                                            /// 상세화면에서 '동의'를 했으면, 체크박스를 체크
                                            bool? isAgreed = await context.pushNamed(
                                              TermDetailScreen.routeName,
                                              queryParameters: {"trmSq": termList[index].trmSq.toString()},
                                            );
                                            if (isAgreed != null) {
                                              _cmTermViewModel.setAgreeTermToIndex(index: index, isAgreeYn: isAgreed);
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
                      valueListenable: _cmTermViewModel.isValidNotifier,
                      builder: (context, value, _) {
                        return CustomElevatedButton(
                          text: StringTerm.bottomButton,
                          isEnabled: value,
                          onPressed: () async {
                            /// 이용약관 동의여부 저장
                            final result = await _cmTermViewModel.agreeTerms();
                            if (result is Success) {
                              /// 홈 화면으로 이동
                              context.goNamed(HomeScreen.routeName);
                            } else if (result is Bad) {
                              Fluttertoast.showToast(msg: result.badResponse.detailMessage);
                            } else if (result is Fail) {
                              Fluttertoast.showToast(msg: "${result.errorMessage}");
                            }
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
