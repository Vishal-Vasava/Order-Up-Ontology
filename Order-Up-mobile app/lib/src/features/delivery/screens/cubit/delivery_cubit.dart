import 'dart:convert';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/delivery/data/delivery_interface.dart';
import 'package:orderly_ecom/src/features/delivery/domain/delivery.dart';
import 'package:orderly_ecom/src/features/delivery/domain/delivery_order_detail.dart';
import 'package:orderly_ecom/src/features/notifications/data/notification_service.dart';
import 'package:orderly_ecom/src/features/notifications/domain/push_notification.dart';
import 'package:orderly_ecom/src/features/notifications/screens/cubit/notification_cubit.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';

part 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> implements DeliveryInterface {
  DeliveryCubit(
      {required this.deliveryInterface, required this.notificationCubit})
      : super(DeliveryInitialState()) {
    notificationCubit.getNotification();
    initNotification();
  }
  final DeliveryInterface deliveryInterface;
  final NotificationCubit notificationCubit;

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
          log(jsonEncode(message.toMap()), name: 'On Message DEV');
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
        },
      );
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      final initialData = await FirebaseMessaging.instance.getInitialMessage();
      if (initialData != null) {
        log('INITIAL MESSAGE');
        log(jsonEncode(initialData.toMap()), name: 'Initial Message DEV');
        notification = PushNotification(
          title: initialData.notification!.title!,
          body: initialData.notification!.body!,
          flag: initialData.data['flag'],
          userType: initialData.data['user_type'],
        );
        await Future.delayed(const Duration(milliseconds: 400));
        if (state is DeliveryOrderFetchedState) {
          final currentState = state as DeliveryOrderFetchedState;
          emit(DeliveryOrderDeepLinkState());
          emit(currentState.copyWith(deepLinkData: initialData.data));
        }
      }

      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        log('MESSAGE CLICKED DEV');
        log(jsonEncode(message.toMap()), name: 'onMessageOpenedApp');
        await notificationCubit.getNotification();
        notification = PushNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          flag: message.data['flag'],
          userType: message.data['user_type'],
        );
        await Future.delayed(const Duration(milliseconds: 400));
        if (state is DeliveryOrderFetchedState) {
          final currentState = state as DeliveryOrderFetchedState;
          emit(DeliveryOrderDeepLinkState());
          emit(currentState.copyWith(deepLinkData: message.data));
        }
      });
      log(notification.toString());
    } catch (e) {
      log(e.toString(), name: 'Nav Cubit Noti Error DEV');
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    log(jsonEncode(message.toMap()), name: 'Background Message DEV');
    final notification = PushNotification(
      title: message.notification!.title!,
      body: message.notification!.body!,
      flag: message.data['flag'],
      userType: message.data['user_type'],
    );

    log('BACKGROUND MESSAGE HIT ${notification.toString()}', name: 'MESSAGE');
    // final currentState = state as DeliveryOrderFetchedState;
    // emit(currentState.copyWith(deepLinkData: message.data));
  }

  List<Delivery> deliveryList = [];
  String orderStatus = '';
  @override
  Future<List<Delivery>> getOrders({
    required String status,
    bool showLoading = true,
  }) async {
    try {
      orderStatus = status;
      if (showLoading) {
        emit(DeliveryOrderFetchingState());
      }
      final data = await deliveryInterface.getOrders(status: status);
      if (data.isNotEmpty) {
        emit(DeliveryOrderFetchedState(
          deliveryList: data,
          deepLinkData: const {},
        ));
        deliveryList = data;
      } else {
        emit(const DeliveryOrderFetchFailedState(
            message: 'No delivery orders.'));
      }
    } catch (e) {
      emit(DeliveryOrderFetchFailedState(message: e.toString()));
    }
    return [];
  }

  @override
  Future<DeliveryOrderDetail?> orderDetail(
      {required String orderDetailId}) async {
    try {
      emit(DeliveryDetailFetchingState());
      final data =
          await deliveryInterface.orderDetail(orderDetailId: orderDetailId);
      if (data != null) {
        emit(DeliveryDetailFetchedState(deliveryOrderDetail: data));
      } else {
        emit(const DeliveryDetailFailedState(message: 'Please refresh'));
      }
    } catch (e) {
      emit(DeliveryDetailFailedState(message: e.toString()));
    }
    return null;
  }

  void updateOrderListCheck(
      {required bool value, required int index, required bool status}) {
    try {
      final currentState = state as DeliveryDetailFetchedState;
      emit(DeliveryDetailUpdateCheckboxState());
      final list = currentState.deliveryOrderDetail.orderItems!;
      list[index].isChecked = value;
      emit(currentState.copyWith(
        deliveryOrderDetail:
            currentState.deliveryOrderDetail.copyWith(orderItems: list),
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<bool> updateOrderStatus({
    required List<String> orderDetailId,
    required String status,
  }) async {
    try {
      emit(DeliveryUpdateLoadingState());
      await deliveryInterface.updateOrderStatus(
        orderDetailId: orderDetailId,
        status: status,
      );
      await getOrders(status: orderStatus, showLoading: false);
      emit(DeliveryUpdateSuccessState());
    } catch (e) {
      emit(DeliveryUpdateFailedState(message: e.toString()));
    }
    return false;
  }
}
