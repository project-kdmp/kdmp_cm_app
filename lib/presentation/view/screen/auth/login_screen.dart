import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/login/get_login_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/set_auto_refresh_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/set_jwt_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_onboarding_check_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrid_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrpw_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/home/home_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/onboarding/onboarding_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/register/register_car_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/cm_term_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/auth/login_viewmodel.dart';

/// 로그인 화면 (본인인증)
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   static const String routeName = "login";
//   static const String routeURL = "/login";
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   late final LoginViewModel _loginViewModel;
//
//   @override
//   void initState() {
//     super.initState();
//     initViewModel();
//   }
//
//   /// Create
//   void initViewModel() {
//     _loginViewModel = LoginViewModel(
//       getLoginUseCase: GetIt.instance<GetLoginUseCase>(),
//       setJwtUseCase: GetIt.instance<SetJwtUseCase>(),
//       setAutoRefreshUseCase: GetIt.instance<SetAutoRefreshUseCase>(),
//       setMbrSqUseCase: GetIt.instance<SetMbrSqUseCase>(),
//       setMbrIdUseCase: GetIt.instance<SetMbrIdUseCase>(),
//       setMbrPwUseCase: GetIt.instance<SetMbrPwUseCase>(),
//       getOnBoardingCheckUseCase: GetIt.instance<GetOnBoardingCheckUseCase>(),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       /// 상단 앱바
//       appBar: BaseAppBar(
//         appBar: AppBar(),
//         title: StringRegister.phoneVerify,
//       ),
//
//       /// 화면
//       body: SafeArea(
//         child: Column(
//           children: [
//             Text("본인인증 WebView"),
//             // TODO: 임시 버튼. 본인인증 기능 구현 후 제거
//             CustomElevatedButton(
//               onPressed: () async {
//                 /// 본인인증 후 로그인 처리
//                 // TODO: id, pw 임시값
//                 _loginViewModel.mbrId = "C000E";
//                 _loginViewModel.password = "ci234938";
//
//                 /// 로그인 처리
//                 final result = await _loginViewModel.login();
//
//                 if (result is Success) {
//                   /// 로그인 - 성공시 처리
//                   final response = result.loginResponse;
//
//                   /// 회원구분
//                   switch (response.mbrPrivilegeTp) {
//                     case MbrPrivilegeTp.driver:
//                       await _showAlertDialog(content: StringLogin.mbrPrivilegeTpDMMB, isCanceled: false);
//                       SystemNavigator.pop();
//                       return;
//                     case MbrPrivilegeTp.admin:
//                       await _showAlertDialog(content: StringLogin.mbrPrivilegeTpADMN, isCanceled: false);
//                       SystemNavigator.pop();
//                       return;
//                     case MbrPrivilegeTp.customer:
//                       {
//                         /// 가입상태
//                         switch (response.mbrSt) {
//                           case MbrSt.temp:
//                             if (response.mbrCarCount > 0) {
//                               /// 홈 화면으로 이동
//                               context.goNamed(HomeScreen.routeName);
//                             } else {
//                               /// 차량등록 화면으로 이동
//                               context.goNamed(RegisterCarScreen.routeName);
//                             }
//                             break;
//                           case MbrSt.reject: // 심사 거절이나 기사용 상태
//                             break;
//                           case MbrSt.registerComplete:
//
//                             /// 이용약관 갱신 여부 확인
//                             if (response.bagreeTrmUpdate) {
//                               /// 필수 약관 모두 동의
//                               final isOnBoardingCheck = await _loginViewModel.isOnBoardingCheck();
//                               if (!isOnBoardingCheck) {
//                                 await context.pushNamed(OnBoardingScreen.routeName);
//                               }
//                               context.goNamed(HomeScreen.routeName);
//                             } else {
//                               /// 미동의 필수 약관 갱신 필요
//                               context.goNamed(CMTermScreen.routeName);
//                             }
//                             break;
//                           case MbrSt.withdrawal:
//                             await _showAlertDialog(content: StringLogin.mbrStW, isCanceled: false);
//                             SystemNavigator.pop();
//                             break;
//                           case MbrSt.registerDormant:
//                             await _showAlertDialog(content: StringLogin.mbrStD, isCanceled: false);
//                             SystemNavigator.pop();
//                             break;
//                         }
//                       }
//                       break;
//                     default:
//                       await _showAlertDialog(content: StringLogin.mbrPrivilegeTpUNKNOWN, isCanceled: false);
//                       SystemNavigator.pop();
//                   }
//                 } else if (result is Bad) {
//                   // TODO: 로그인 - 에러코드 처리
//                   switch (result.badResponse.bizErrCode) {
//                     case 22001:
//                   }
//                   Fluttertoast.showToast(msg: StringLogin.loginFail);
//                 } else if (result is Fail) {
//                   Fluttertoast.showToast(msg: "${result.errorMessage}");
//                 }
//               },
//               text: "다음",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _showAlertDialog({String? title, String? content, bool isWarning = false, bool isCanceled = true}) {
//     return showDialog(
//       context: context,
//       barrierDismissible: isCanceled, // dialog 영역 외 터치 여부
//       builder: (BuildContext context) {
//         return CustomAlertDialog(
//           title: title,
//           content: content,
//           isCanceled: isCanceled,
//           isWarning: isWarning,
//           onConfirm: () {
//             context.pop();
//           },
//         );
//       },
//     );
//   }
// }
