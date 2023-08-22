import 'package:flutter/material.dart';

/// 권한 설명 목록에 사용될 위젯 아이템
class PermissionGuideItem extends StatelessWidget {
  const PermissionGuideItem(
      {Key? key,
      required this.icon,
      required this.title,
      required this.message})
      : super(key: key);

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          /// 아이콘
          Icon(
            size: 50,
            icon,
            color: Colors.lightBlueAccent,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 제목
                Text(title),
                const SizedBox(height: 4),
                /// 메시지
                Text(message),
              ],
            ),
          )
        ],
      ),
    );
  }
}
