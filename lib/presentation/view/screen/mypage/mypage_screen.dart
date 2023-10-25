import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/logout/set_logout_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_profile_detail_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_user_data_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/mypage/withdraw_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/term_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/menu/custom_move_button.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/mypage/mypage_viewmodel.dart';

/// 내정보 화면
class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  static const String routeName = "my_page";

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late final MyPageViewModel _myPageViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _myPageViewModel = MyPageViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      setLogoutUseCase: GetIt.instance<SetLogoutUseCase>(),
      getProfileDetailUseCase: GetIt.instance<GetProfileDetailUseCase>(),
      deleteUserDataUseCase: GetIt.instance<DeleteUserDataUseCase>(),
    );
  }

  void initData() {
    /// 프로필 상세 정보 조회
    _myPageViewModel.getProfileDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: StringMenu.myPage,
      ),

      /// 화면
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// 이름
                ValueListenableBuilder<String>(
                  valueListenable: _myPageViewModel.nameNotifier,
                  builder: (context, value, _) {
                    return CustomMoveButton(
                      text: StringMyPage.name,
                      content: value,
                      isArrow: false,
                    );
                  },
                ),

                /// 휴대폰번호
                ValueListenableBuilder<String>(
                  valueListenable: _myPageViewModel.phoneNotifier,
                  builder: (context, value, _) {
                    return CustomMoveButton(
                      text: StringMyPage.phone,
                      content: getPhoneNumber(value),
                      isArrow: false,
                    );
                  },
                ),

                const SizedBox(height: 12),
                const Divider(thickness: 6),
                const SizedBox(height: 12),

                /// 로그아웃
                CustomMoveButton(
                  text: StringMyPage.logout,
                  isArrow: false,
                  onPressed: () async {
                    _showLogoutDialog();
                  },
                ),

                /// 탈퇴하기
                CustomMoveButton(
                  text: StringMyPage.withdraw,
                  isArrow: false,
                  onPressed: () {
                    context.goNamed(WithdrawScreen.routeName);
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 로그아웃 확인 팝업
  _showLogoutDialog() {
    return showDialog(
      context: context,
      barrierDismissible: true, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CustomConfirmDialog(
          content: StringMyPage.logoutConfirm,
          onConfirm: () async {
            final result = await _myPageViewModel.logout();
            if (result is Success) {
              /// 이용약관 화면으로 이동
              context.goNamed(TermScreen.routeName);
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
