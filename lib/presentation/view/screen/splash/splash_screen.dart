import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/client_info.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/login/get_login_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_token_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/fcm/get_fcm_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/get_jwt_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_user_data_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrid_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrpw_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_onboarding_check_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_user_data_usecase.dart';
import 'package:kdmp_cm_app/presentation/theme/custom_theme_mode.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/home/home_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/onboarding/onboarding_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/permission/permission_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/cm_term_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/term_screen.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/splash/splash_viewmodel.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// 스플래시 화면
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = "splash";
  static const String routeURL = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashViewModel _splashViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    checkVersion();
    checkPermission();
  }

  void checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    String platform = "";
    if (Platform.isAndroid) platform = "android";
    if (Platform.isIOS) platform = "iOS";
    debugPrint("appName: $appName, packageName: $packageName, version: $version, buildNumber: $buildNumber, platform: $platform");

    ClientInfo.setClientVersion = "${platform}_$version";
  }

  void checkPermission() async {
    final isLogin = (await GetIt.instance<GetJwtUseCase>().execute()).isNotEmpty;

    /// 위치 권한 상태 조회
    var locationStatus = await Permission.location.isGranted;

    /// 전화 권한 상태 조회
    var phoneStatus = await Permission.phone.isGranted;

    /// 알림 권한 상태 조회
    var notificationStatus = await FirebaseMessaging.instance.getNotificationSettings();

    debugPrint("필수 권한 - location: $locationStatus, phone: $phoneStatus, notification: ${notificationStatus.authorizationStatus}");

    Future.delayed(const Duration(milliseconds: 1000), () async {
      if (!locationStatus || !phoneStatus || notificationStatus.authorizationStatus != AuthorizationStatus.authorized) {
        await context.pushNamed(PermissionScreen.routeName);
      }

      if (isLogin) {
        /// 로그인 상태, 자동 로그인 처리
        _autoLogin();
      } else {
        /// 로그아웃 상태
        /// 첫 로그인 여부 상관 없이, 이용약관 화면으로 이동
        context.pushNamed(TermScreen.routeName);
      }
    });
  }

  /// Create
  void initViewModel() {
    _splashViewModel = SplashViewModel(
      getLoginUseCase: GetIt.instance<GetLoginUseCase>(),
      getMbrIdUseCase: GetIt.instance<GetMbrIdUseCase>(),
      getMbrPwUseCase: GetIt.instance<GetMbrPwUseCase>(),
      setUserDataUseCase: GetIt.instance<SetUserDataUseCase>(),
      getOnBoardingCheckUseCase: GetIt.instance<GetOnBoardingCheckUseCase>(),
      getFCMUseCase: GetIt.instance<GetFCMUseCase>(),
      setFCMTokenUseCase: GetIt.instance<SetFCMTokenUseCase>(),
      deleteUserDataUseCase: GetIt.instance<DeleteUserDataUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Center(
          child: ValueListenableBuilder<ThemeMode>(
            valueListenable: CustomThemeMode.themeMode,
            builder: (context, themeMode, child) {
              return Image.asset(themeMode == ThemeMode.light ? ImageCommon.appLogoLight : ImageCommon.appLogoDark, width: 200, height: 200);
            },
          ),
        ),
      ),
    );
  }

  _autoLogin() async {
    /// 로그인 처리
    final result = await _splashViewModel.autoLogin();

    if (result is Success) {
      /// 로그인 - 성공시 처리
      final response = result.loginResponse;

      /// 회원구분
      switch (response.mbrPrivilegeTp) {
        case MbrPrivilegeTp.driver:
          _splashViewModel.logout();
          await _showAlertDialog(content: StringLogin.mbrPrivilegeTpDMMB, isCanceled: false);
          SystemNavigator.pop();
          return;
        case MbrPrivilegeTp.admin:
          _splashViewModel.logout();
          await _showAlertDialog(content: StringLogin.mbrPrivilegeTpADMN, isCanceled: false);
          SystemNavigator.pop();
          return;
        case MbrPrivilegeTp.customer:
          {
            /// 가입상태
            switch (response.mbrSt) {
              case MbrSt.temp:
                break;
              case MbrSt.reject: // 심사 거절이나 기사용 상태
                break;
              case MbrSt.registerComplete:
                // if (response.mbrCarCount == 0) {
                //   /// 차량등록 화면으로 이동
                //   await context.pushNamed(RegisterCarScreen.routeName);
                // }

                /// 이용약관 갱신 여부 확인
                if (response.bagreeTrmUpdate) {
                  /// 미동의 필수 약관 갱신 필요
                  await context.pushNamed(CMTermScreen.routeName);
                }

                /// 필수 약관 모두 동의
                final isOnBoardingCheck = await _splashViewModel.isOnBoardingCheck();
                if (!isOnBoardingCheck) {
                  await context.pushNamed(OnBoardingScreen.routeName);
                }
                context.goNamed(HomeScreen.routeName);
                break;
              case MbrSt.withdrawal:
                _splashViewModel.logout();
                await _showAlertDialog(content: StringLogin.mbrStW, isCanceled: false);
                SystemNavigator.pop();
                break;
              case MbrSt.registerDormant:
                _splashViewModel.logout();
                await _showAlertDialog(content: StringLogin.mbrStD, isCanceled: false);
                SystemNavigator.pop();
                break;
            }
          }
          break;
        default:
          _splashViewModel.logout();
          await _showAlertDialog(content: StringLogin.mbrPrivilegeTpUNKNOWN, isCanceled: false);
          SystemNavigator.pop();
      }
    }
  }

  /// 앱 뒤로가기
  Future<bool> _onBackPressed() async {
    SystemNavigator.pop();
    return true;
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
            context.pop();
          },
        );
      },
    );
  }
}
