import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/notifications/data/notification_service.dart';
import 'package:orderly_ecom/src/features/notifications/data/notifications.dart';
import 'package:orderly_ecom/src/features/notifications/domain/notification_model.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState>
    implements Notifications {
  NotificationCubit({
    required this.notificationRepository,
    required this.notificationService,
  }) : super(NotificationInitialState()) {
    getNotification();
  }

  bool isNotificationEnabled = true;
  Notifications notificationRepository;
  NotificationService notificationService;

  @override
  Future<List<NotificationModel>> getNotification(
      {bool showLoading = true}) async {
    try {
      if (showLoading) {
        emit(NotificationLoadingState());
      }
      final notificationList = await notificationRepository.getNotification();
      emit(NotificationLoadedState(notificationList: notificationList));
    } catch (e) {
      emit(NotificationFailedState(message: e.toString()));
    }
    return [];
  }

  @override
  Future<bool> deleteNotification({required String notificationId}) async {
    try {
      emit(NotificationDeleteState());
      await notificationRepository.deleteNotification(
          notificationId: notificationId);
      await getNotification(showLoading: false);
    } catch (e) {
      emit(NotificationFailedState(message: e.toString()));
    }
    return false;
  }

  @override
  Future<bool> init() {
    throw UnimplementedError();
  }

  // @override
  // FirebaseMessaging get messageInstance => throw UnimplementedError();
}
