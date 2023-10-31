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
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /// Foreground : 앱 실행중
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message != null) {
        if (message.notification != null) {
          debugPrint("fcmTest=====Foreground - ${message.notification!.title}");
          debugPrint("fcmTest=====Foreground - ${message.notification!.body}");
          debugPrint("fcmTest=====Foreground - ${message.data["type"]}");

          if (message.data.containsKey("type")) {
            Map<String, dynamic> map = Map.from({
              "title": message.notification!.title,
              "body": message.notification!.body,
              "type": message.data["type"],
            });
            streamController.add(map);
          }

          showNotification(
            title: message.notification!.title,
            body: message.notification!.body,
          );
        }
      }
    });

    /// Background
    FirebaseMessaging.onMessageOpenedApp.listen(_onBackgroundMessage);

    /// Terminate : 앱 종료 상태
    final remoteMessaging = await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessaging != null) {
      _onBackgroundMessage(remoteMessaging);
    }
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

  @pragma('vm:entry-point')
  static Future<void> _onBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();

    debugPrint("fcmTest=====Notification Listener - ${message.notification!.title}");
    debugPrint("fcmTest=====Notification Listener - ${message.notification!.body}");

    /// Foreground 푸시 알림을 위한 설정
    showNotification(
      title: message.notification!.title,
      body: message.notification!.body,
    );
  }
}
