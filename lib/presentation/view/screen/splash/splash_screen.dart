import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_update/in_app_update.dart';
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
import 'package:kdmp_cm_app/presentation/view/dialog/custom_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/home/home_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/onboarding/onboarding_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/permission/permission_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/register/no_permission_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/cm_term_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/term_screen.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/splash/splash_viewmodel.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  /// 현재 버전
  final ValueNotifier<String> _versionName = ValueNotifier<String>("");

  ValueNotifier<String> get versionNameNotifier => _versionName;

  String get versionName => _versionName.value;

  set versionName(String value) => _versionName.value = value;

  @override
  void initState() {
    super.initState();
    initViewModel();
    checkVersion();
    checkStoreVersion();
  }

  /// 스토어 업데이트 버전체크 및 업데이트
  Future<void> checkStoreVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    versionName = packageInfo.version;
    final versionCode = packageInfo.buildNumber;
    if (Platform.isAndroid) {
      await _getAndroidStoreVersion(versionCode: versionCode);
    } else if (Platform.isIOS) {
      // TODO: iOS
    }

    checkPermission();
  }

  /// Android Google Play 버전체크 및 업데이트
  Future<void> _getAndroidStoreVersion({required String versionCode}) async {
    await InAppUpdate.checkForUpdate().then((info) async {
      debugPrint("checkForUpdate info=${info.toString()}");

      final newVersionCode = info.availableVersionCode?.toString() ?? "";
      final versionA = int.parse(versionCode.substring(0, versionCode.length - 1));
      final versionB = int.parse(versionCode[versionCode.length - 1]);
      final newVersionA = int.parse(newVersionCode.substring(0, newVersionCode.length - 1));
      final newVersionB = int.parse(newVersionCode[newVersionCode.length - 1]);

      debugPrint("nowVersion: $versionA $versionB");
      debugPrint("newVersion: $newVersionA $newVersionB");

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (newVersionA > versionA) {
          /// 새 업데이트 버전 알림 (필수)
          await _showAlertDialog(
            title: "업데이트 알림",
            content: "새롭게 출시된 버전이 있습니다.\n업데이트를 진행해주세요.",
            isWarning: true,
          );

          /// 스토어 이동
          final id = (await PackageInfo.fromPlatform()).packageName;
          await launchUrlString('https://play.google.com/store/apps/details?id=$id');
          Fluttertoast.showToast(msg: "업데이트 후 다시 실행해주세요.");

          /// 앱 종료
          SystemNavigator.pop();
        } else if (newVersionB > versionB) {
          /// 새 업데이트 버전 알림 (선택)
          final result = await _showConfirmDialog(
            title: "업데이트 알림",
            content: "새롭게 출시된 버전이 있습니다.\n업데이트 하시겠습니까?",
            isWarning: true,
            onConfirm: () => context.pop(true),
          );
          if (result) {
            /// 스토어 이동
            final id = (await PackageInfo.fromPlatform()).packageName;
            await launchUrlString('https://play.google.com/store/apps/details?id=$id');
            Fluttertoast.showToast(msg: "업데이트 후 다시 실행해주세요.");

            /// 앱 종료
            SystemNavigator.pop();
          }
        }
      }
    }).catchError((e) {
      debugPrint("checkForUpdate error=${e.toString()}");
    });
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

    /// 전화 권한 상태 조회 (Android 전용, iOS는 해당 권한 없음)
    var phoneStatus = Platform.isAndroid ? await Permission.phone.isGranted : true;

    /// 알림 권한 상태 조회
    var notificationStatus = await FirebaseMessaging.instance.getNotificationSettings();

    debugPrint("필수 권한 - location: $locationStatus, phone: $phoneStatus, notification: ${notificationStatus.authorizationStatus}");

    Future.delayed(const Duration(milliseconds: 1000), () async {
      if (!mounted) return;

      try {
        if (!locationStatus || !phoneStatus || notificationStatus.authorizationStatus != AuthorizationStatus.authorized) {
          await context.pushNamed(PermissionScreen.routeName);
        }

        if (!mounted) return;

        if (isLogin) {
          /// 로그인 상태, 자동 로그인 처리
          _autoLogin();
        } else {
          /// 로그아웃 상태
          /// 첫 로그인 여부 상관 없이, 이용약관 화면으로 이동
          context.pushNamed(TermScreen.routeName);
        }
      } catch (e, stack) {
        debugPrint("checkPermission navigation error: $e\n$stack");
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
              return Padding(
                padding: const EdgeInsets.all(50),
                child: Image.asset(themeMode == ThemeMode.light ? ImageCommon.appLogoLight : ImageCommon.appLogoDark),
              );
            },
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder<String>(
          valueListenable: versionNameNotifier,
          builder: (context, value, child) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Text("V$value"),
            );
          },
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
            /// 이용정지 회원 체크
            if (response.serviceYn != "Y") {
              context.goNamed(NoPermissionScreen.routeName);
              return;
            }

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
    } else {
      _splashViewModel.logout();
      SystemNavigator.pop();
    }
  }

  /// 앱 뒤로가기
  Future<bool> _onBackPressed() async {
    SystemNavigator.pop();
    return true;
  }

  _showConfirmDialog({String? title, String? content, bool isWarning = false, required Function() onConfirm}) {
    return showDialog(
      context: context,
      barrierDismissible: true, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CustomConfirmDialog(
          title: title,
          content: content,
          isWarning: isWarning,
          onConfirm: onConfirm,
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
            context.pop();
          },
        );
      },
    );
  }
}
