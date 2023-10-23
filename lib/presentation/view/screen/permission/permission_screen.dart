import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/permission_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:permission_handler/permission_handler.dart';

/// 접근 권한 안내 화면
class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  static const String routeName = "permission";
  static const String routeURL = "/permission";

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  void initState() {
    super.initState();
  }

  void checkPermission() async {
    /// 위치 권한
    var locationStatus = await Permission.location.request().isGranted;

    /// 전화 권한
    var phoneStatus = await Permission.phone.request().isGranted;

    /// 알림 권한
    var notificationStatus = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint("필수 권한 - location: $locationStatus, phone: $phoneStatus, notification: ${notificationStatus.authorizationStatus}");

    if (locationStatus && phoneStatus && notificationStatus.authorizationStatus == AuthorizationStatus.authorized) {
      /// 필수 권한 동의 시, 화면 닫기
      context.pop();
    } else {
      showPermissionDialog();
    }
  }

  showPermissionDialog() {
    return showDialog(
      context: context,
      barrierDismissible: true, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return PermissionDialog(
          onConfirm: () {
            // 앱 설정 화면으로 이동
            Navigator.pop(context);
            openAppSettings();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: StringPermission.title,
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
                          /// 접근 권한 안내
                          Text(
                            StringPermission.content,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 44),

                          /// 위치 권한
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(ImagePermission.iconLocation, width: 40, height: 40),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(StringPermission.permissionTitle1, style: Theme.of(context).textTheme.bodyLarge),
                                    const SizedBox(height: 4),
                                    Text(StringPermission.permissionContent1, style: Theme.of(context).textTheme.bodySmall),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 24),

                          /// 전화 권한
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(ImagePermission.iconCall, width: 40, height: 40),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(StringPermission.permissionTitle2, style: Theme.of(context).textTheme.bodyLarge),
                                    const SizedBox(height: 4),
                                    Text(StringPermission.permissionContent2, style: Theme.of(context).textTheme.bodySmall),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 24),

                          /// 알림 권한
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(ImagePermission.iconNotification, width: 40, height: 40),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(StringPermission.permissionTitle4, style: Theme.of(context).textTheme.bodyLarge),
                                    const SizedBox(height: 4),
                                    Text(StringPermission.permissionContent4, style: Theme.of(context).textTheme.bodySmall),
                                  ],
                                ),
                              )
                            ],
                          ),
                          // const SizedBox(height: 24),
                          //
                          // /// 저장공간 권한
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Image.asset(ImagePermission.iconFile, width: 40, height: 40),
                          //     const SizedBox(width: 16),
                          //     Expanded(
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(StringPermission.permissionTitle3, style: Theme.of(context).textTheme.bodyLarge),
                          //           const SizedBox(height: 4),
                          //           Text(StringPermission.permissionContent3, style: Theme.of(context).textTheme.bodySmall),
                          //         ],
                          //       ),
                          //     )
                          //   ],
                          // ),
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).dividerColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              StringPermission.permissionGuide,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),

                /// 하단 버튼
                CustomElevatedButton(
                  text: StringPermission.bottomButton,
                  onPressed: () => checkPermission(),
                )
              ],
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
