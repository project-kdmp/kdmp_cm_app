import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kdmp_cm_app/data/constant/text/terms.dart';

import '../../../../../data/constant/text/common.dart';
import '../../../../viewmodel/auth/terms/terms_viewmodel.dart';
import '../../../widget/common/custom_animated_button.dart';

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

      /// 화면
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
                            return Checkbox(
                              value: value,
                              onChanged: (isChecked) {
                                _termsViewModel.setIsAgreeToTerms(value: isChecked == true);
                                _termsViewModel.setIsAgreeToLocation(value: isChecked == true);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(agreeToAllTerms),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Divider(),
                    ),

                    /// 서비스 이용약관
                    GestureDetector(
                      onTap: () {
                        // TODO : 서비스 이용약관 상세화면 이동
                        // TODO : '동의' 버튼 클릭하고 돌아왔을 때, setIsAgreeToTerms()로 상태 갱신
                      },
                      child: Row(
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: _termsViewModel.isAgreeToTermsNotifier,
                            builder: (context, value, _) {
                              return Checkbox(
                                value: value,
                                onChanged: (isChecked) {
                                  _termsViewModel.setIsAgreeToTerms(value: isChecked == true);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text(requiredTerms),
                        ],
                      ),
                    ),

                    /// 위치 기반 서비스 이용약관
                    GestureDetector(
                      onTap: () {
                        // TODO : 위치 기반 서비스 이용약관 상세화면 이동
                        // TODO : '동의' 버튼 클릭하고 돌아왔을 때, setIsAgreeToLocation()로 상태 갱신
                      },
                      child: Row(
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: _termsViewModel.isAgreeToLocationNotifier,
                            builder: (context, value, _) {
                              return Checkbox(
                                value: _termsViewModel.isAgreeToLocation,
                                onChanged: (isChecked) {
                                  _termsViewModel.setIsAgreeToLocation(value: isChecked == true);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text(requiredTermsForLocation),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ValueListenableBuilder<bool>(
                  valueListenable: _termsViewModel.isValidNotifier,
                  builder: (context, value, _) {
                    return CustomAnimatedButton(
                      text: agree,
                      isEnabled: value,
                      onPressed: () {
                        // TODO : 다음화면으로 이동
                        debugPrint("Next button clicked!");
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
