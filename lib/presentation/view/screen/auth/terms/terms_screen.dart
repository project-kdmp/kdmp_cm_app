import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../data/constant/text/common.dart';
import '../../../../../data/constant/text/terms.dart';
import '../../../../viewmodel/auth/terms/terms_viewmodel.dart';
import '../../../widget/auth/terms/terms_checkbox.dart';
import '../../../widget/common/custom_animated_button.dart';
import '../../../widget/common/custom_checkbox.dart';
import '../permission/permission_screen.dart';
import 'terms_detail_screen.dart';
import 'terms_location_screen.dart';

/// 이용약관 화면
class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key}) : super(key: key);

  static const String routeName = "terms";
  static const String routeURL = "/terms";

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  final TermsViewModel _termsViewModel = TermsViewModel();

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<TermsViewModel>(
          create: (context) => _termsViewModel,
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        /// 상단 앱바
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text(
            terms,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        /// 화면
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // TODO : 나중에 여기에 로고 추가해주세요

                    /// 전체 이용약관
                    Row(
                      children: [
                        /// ValueNotifier 는 안드로이드로 치면 LiveData 라고 생각하시면 됩니다
                        /// 안드로이드에서 LiveData 의 상태변화를 observe 를 통해서 관찰하는 것처럼,
                        /// 플러터의 ValueNotifier 상태변화는 하기 ValueListenableBuilder 를 통해서 관찰할 수 있습니다
                        ValueListenableBuilder<bool>(
                          valueListenable: _termsViewModel.isValidNotifier,
                          builder: (context, value, _) {
                            return CustomCheckBox(
                              isChecked: value,
                              message: agreeToAllTerms,
                              onPressed: (isChecked) {
                                _termsViewModel.setIsAgreeToTerms(value: isChecked == true);
                                _termsViewModel.setIsAgreeToLocation(value: isChecked == true);
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    /// 경계선
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Divider(),
                    ),

                    /// 서비스 이용약관
                    ValueListenableBuilder<bool>(
                      valueListenable: _termsViewModel.isAgreeToTermsNotifier,
                      builder: (context, value, _) {
                        return TermsCheckBox(
                          isChecked: value,
                          message: requiredTerms,
                          onPressed: (isChecked) {
                            _termsViewModel.setIsAgreeToTerms(value: isChecked == true);
                          },
                          onDetailPressed: () async {
                            /// 상세화면에서 '동의'를 했으면, 체크박스를 체크
                            bool? isAgreed = await context.pushNamed(TermsDetailScreen.routeName);
                            if (isAgreed != null) _termsViewModel.setIsAgreeToTerms(value: isAgreed);
                          },
                        );
                      },
                    ),

                    /// 위치 기반 서비스 이용약관
                    ValueListenableBuilder<bool>(
                      valueListenable: _termsViewModel.isAgreeToLocationNotifier,
                      builder: (context, value, _) {
                        return TermsCheckBox(
                          isChecked: value,
                          message: requiredTermsForLocation,
                          onPressed: (isChecked) {
                            _termsViewModel.setIsAgreeToLocation(value: isChecked == true);
                          },
                          onDetailPressed: () async {
                            /// 상세화면에서 '동의'를 했으면, 체크박스를 체크
                            bool? isAgreed = await context.pushNamed(TermsLocationScreen.routeName);
                            if (isAgreed != null) _termsViewModel.setIsAgreeToLocation(value: isAgreed);
                          },
                        );
                      },
                    ),

                  ],
                ),
              ),

              /// 하단 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ValueListenableBuilder<bool>(
                  valueListenable: _termsViewModel.isValidNotifier,
                  builder: (context, value, _) {
                    return CustomAnimatedButton(
                      text: agree,
                      isEnabled: value,
                      onPressed: () {
                        /// 권한 화면으로 이동
                        context.pushNamed(PermissionScreen.routeName);
                      },
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
