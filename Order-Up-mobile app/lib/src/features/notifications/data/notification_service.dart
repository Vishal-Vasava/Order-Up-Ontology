import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:orderly_ecom/src/features/notifications/data/notifications.dart';
import 'package:orderly_ecom/src/features/notifications/domain/notification_model.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';

class NotificationService extends Notifications {
  NotificationService();

  @override
  Future<bool> init() async {
    // Browser notifications require a separately configured web push/VAPID
    // flow and must not block the application from mounting. Mobile keeps the
    // existing Firebase Messaging initialization below.
    if (kIsWeb) {
      return true;
    }

    FirebaseMessaging messageInstance = FirebaseMessaging.instance;
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
        ),
      ),
    );
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .createNotificationChannel(_androidChannel);
    }
    await messageInstance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    NotificationSettings settings = await messageInstance.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return true;
    } else {
      if (inject.isRegistered<AuthLocalRepository>()) {
        await FirebaseCrashlytics.instance.recordError(
          '${inject.get<AuthLocalRepository>().userId} declined or has not accepted notification permission',
          null,
          reason: 'User Denied Notification Permission',
          fatal: true,
        );
      }
      log('User declined or has not accepted permission');
      return false;
    }
  }

  /// [LOCAL NOTIFICATION] INSTANCE
  /// We need this because firebase doesn't show notification when app is in
  /// foreground (Visible on Screen)
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterLocalNotificationsPlugin;

  final AndroidNotificationChannel _androidChannel =
      const AndroidNotificationChannel(
    'high_importance_channel', // id
    'Orders Notifications', // title
    description: 'This notification is used for Orders.',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('classic_bell'),
  );

  static AndroidNotificationDetails androidNotificationDetails({
    String channelId = 'high_importance_channel',
    String channelName = 'Notifications',
  }) {
    return AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription:
          'This notification is used to notify you about updates.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
    );
  }

  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails(),
    iOS: const DarwinNotificationDetails(
      categoryIdentifier: 'plainCategory',
    ),
  );
  Future<void> notificationHandler() async {
    try {
      /// Whenever we receive new notification below  methods will be called
      FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

      FirebaseMessaging.onMessage.listen((message) async {
        log(jsonEncode(message.toMap()), name: 'On Message');

        flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title!,
          message.notification!.body!,
          notificationDetails,
        );
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        log(jsonEncode(message.toMap()), name: 'App Open');
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    log(jsonEncode(message.toMap()), name: 'Background Message ƒ');
  }

  @override
  Future<bool> deleteNotification({required String notificationId}) =>
      throw UnimplementedError();

  @override
  Future<List<NotificationModel>> getNotification() =>
      throw UnimplementedError();
}
