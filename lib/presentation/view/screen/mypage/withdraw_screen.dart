import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/policy_model.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_withdrawal_member_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/policy/get_policy_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_user_data_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/splash/splash_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/mypage/withdraw_viewmodel.dart';
import 'package:provider/provider.dart';

/// 탈퇴하기 화면
class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  static const String routeName = "withdraw";

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  late final WithdrawViewModel _withdrawViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _withdrawViewModel = WithdrawViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      setWithdrawalMemberUseCase: GetIt.instance<SetWithdrawalMemberUseCase>(),
      deleteUserDataUseCase: GetIt.instance<DeleteUserDataUseCase>(),
      getPolicyUseCase: GetIt.instance<GetPolicyUseCase>(),
    );
  }

  void initData() {
    /// 탈퇴 정책 조회
    _withdrawViewModel.getPolicy(policyTp: PolicyTp.cncl);
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<WithdrawViewModel>(
          create: (context) => _withdrawViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringWithdraw.title,
        ),

        /// 화면
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// 내용
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            StringWithdraw.content1,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ValueListenableBuilder<Policy>(
                            valueListenable: _withdrawViewModel.policyNotifier,
                            builder: (context, value, child) {
                              return Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  value.content,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.left,
                                ),
                              );
                            }),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  /// 탈퇴 버튼
                  CustomElevatedButton(
                    text: StringWithdraw.bottomButton,
                    onPressed: () async {
                      final result = await _showWithdrawalDialog();
                      if (result == true) {
                        await _showAlertDialog(content: StringWithdraw.withdrawalSuccess, isCanceled: false);
                        context.goNamed(SplashScreen.routeName);
                      }
                    },
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    minimumSize: const Size(double.minPositive, double.minPositive),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 탈퇴하기 확인 팝업
  _showWithdrawalDialog() {
    return showDialog(
      context: context,
      barrierDismissible: true, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CustomConfirmDialog(
          content: StringWithdraw.withdrawalConfirm,
          isWarning: true,
          onConfirm: () async {
            /// 탈퇴하기 처리
            final result = await _withdrawViewModel.withdraw();
            if (result is Success) {
              /// 팝업 닫기
              context.pop();
            }
          },
        );
      },
    );
  }

  _showAlertDialog({String? title, String? content, bool isWarning = false, bool isCanceled = true}) {
    return showDialog(
      context: context,
      barrierDismissible: isCanceled, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: content,
          isCanceled: isCanceled,
          isWarning: isWarning,
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
