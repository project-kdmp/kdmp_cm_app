import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kdmp_cm_app/firebase_options.dart';

class FlutterLocalNotification {
  FlutterLocalNotification._();

  /// Notification 을 위한 StreamController 전역 변수 선언
  static StreamController<Map<String, dynamic>> streamController = StreamController.broadcast();

  /// Notification Plugin 객체 생성
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'sound_channel_id',
    'sound_channel_name',
    description: 'channel description',
    importance: Importance.max,
    enableVibration: true,
    playSound: true,
  );

  static init() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }

    InitializationSettings initializationSettings = const InitializationSettings(
      /// Android 초기 설정
      android: AndroidInitializationSettings(
        'mipmap/ic_launcher',
      ),

      /// iOS 초기 설정
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    /// Android channel 등록
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    // 필요 시 푸시 알림을 누르면 작동되는 콜백 함수를 생성할 수 있음, 기본값은 푸시 알림 클릭 시 앱 실행
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  /// 푸시 알림 권한 요청
  static requestNotificationPermission() {
    /// iOS
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// 푸시 알림 띄움
  static Future<void> showNotification({required String? title, required String? body}) async {
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      NotificationDetails(
        /// Android
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.max,
          showWhen: false,
          playSound: channel.playSound,
          enableVibration: channel.enableVibration,
        ),

        /// iOS
        iOS: const DarwinNotificationDetails(badgeNumber: 1),
      ),
    );
  }
}
