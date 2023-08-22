import 'package:flutter/material.dart';

import '../../../../../data/constant/text/common.dart';
import '../../../../../data/constant/text/permission.dart';
import '../../../widget/auth/permission/permission_guide_item.dart';
import '../../../widget/common/custom_animated_button.dart';

/// 권한 화면
class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  static const String routeName = "permission";
  static const String routeURL = "/permission";

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {

  // TODO : 권한 관련 뷰모델 _permissionViewModel 구현해야함

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// 상단 앱바
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          permissionGuide,
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
              /// 권한 설명
              /// 휴대폰 화면이 작아서 잘리는 경우를 위해서 ListView 로 구현함
              child: ListView(
                children: [
                  /// 상단 메시지
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      permissionMessage, // TODO : 추후 문구 확정되면 수정해주세요
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // TODO : 추후 아이콘 전달 받으시면 수정해주세요
                  /// 위치
                  const PermissionGuideItem(
                    icon: Icons.location_on_outlined,
                    title: locationTitle,
                    message: locationPermissionMessage,
                  ),

                  /// 전화
                  const PermissionGuideItem(
                    icon: Icons.phone,
                    title: contactTitle,
                    message: contactPermissionMessage,
                  ),

                  /// 저장공간
                  const PermissionGuideItem(
                    icon: Icons.sd_storage_rounded,
                    title: storageTitle,
                    message:
                        storagePermissionMessage, // TODO : 추후 문구 확정되면 수정해주세요
                  ),

                  /// 알림
                  const PermissionGuideItem(
                    icon: Icons.circle_notifications,
                    title: notificationTitle,
                    message: notificationPermissionMessage,
                  ),

                  /// 하단 메시지 1
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(" - "),
                        Expanded(
                          child: Text(optionalPermissionMessage),
                        ),
                      ],
                    ),
                  ),
                  // TODO : 스토리보드 보니까 하단 메시지 2가 미정인 것 같은데, 추후 확정되면 추가해주세요
                ],
              ),
            ),

            /// 하단 버튼
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
              child: CustomAnimatedButton(
                text: ok,
                isEnabled: true, // TODO : 권한 체크 로직 만들어야함
                onPressed: () {
                  // TODO : 휴대폰번호 인증 화면으로 이동
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
