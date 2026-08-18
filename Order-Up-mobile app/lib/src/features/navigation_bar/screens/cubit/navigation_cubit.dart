import 'dart:convert';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/notifications/data/notification_service.dart';
import 'package:orderly_ecom/src/features/notifications/domain/push_notification.dart';
import 'package:orderly_ecom/src/features/notifications/screens/cubit/notification_cubit.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit({
    required this.notificationCubit,
  }) : super(const NavigationInitialState(activeIndex: 0, deepLinkData: {})) {
    initNotification();
  }

  final NotificationCubit notificationCubit;

  int get activeIndex => _currentIndex;

  int _currentIndex = 0;

  void changeIndex({required int index}) {
    if (index != _currentIndex) {
      emit(NavigationChangeState());
      _currentIndex = index;
      emit(
        NavigationInitialState(
          activeIndex: activeIndex,
          deepLinkData: const {},
        ),
      );
    }
  }

  void initNotification() async {
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      PushNotification? notification;
      FirebaseMessaging.onMessage.listen(
        (message) async {
          log(jsonEncode(message.toMap()), name: 'On Message');
          inject
              .get<NotificationService>()
              .flutterLocalNotificationsPlugin
              .show(
                0,
                message.notification!.title,
                message.notification!.body,
                inject.get<NotificationService>().notificationDetails,
              );
          await notificationCubit.getNotification();
          notification = PushNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            flag: message.data['flag'],
            userType: message.data['user_type'],
          );
        },
      );
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      final initialData = await FirebaseMessaging.instance.getInitialMessage();
      if (initialData != null) {
        log('INITIAL MESSAGE');
        log(jsonEncode(initialData.toMap()), name: 'Initial Message');
        notification = PushNotification(
          title: initialData.notification!.title!,
          body: initialData.notification!.body!,
          flag: initialData.data['flag'],
          userType: initialData.data['user_type'],
        );
        final currentState = state as NavigationInitialState;
        emit(NavigationChangeState());
        emit(currentState.copyWith(deepLinkData: initialData.data));
      }

      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        log('MESSAGE CLICKED');
        log(jsonEncode(message.toMap()), name: 'onMessageOpenedApp');
        // await notificationCubit.getNotification();
        notification = PushNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          flag: message.data['flag'],
          userType: message.data['user_type'],
        );
        final currentState = state as NavigationInitialState;
        emit(NavigationChangeState());
        emit(currentState.copyWith(deepLinkData: message.data));
        // if (message.data.isNotEmpty) {
        // }
      });
      log(notification.toString());
    } catch (e) {
      log(e.toString(), name: 'Nav Cubit Noti Error');
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    log(jsonEncode(message.toMap()), name: 'Background Message');
    final notification = PushNotification(
      title: message.notification!.title!,
      body: message.notification!.body!,
      flag: message.data['flag'],
      userType: message.data['user_type'],
    );

    log('BACKGROUND MESSAGE HIT ${notification.toString()}', name: 'MESSAGE');
    // final currentState = state as NavigationInitial;
    // emit(NavigationChangeState());
    // emit(currentState.copyWith(deepLinkData: message.data));
  }
}
