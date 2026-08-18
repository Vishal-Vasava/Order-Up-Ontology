import 'package:orderly_ecom/src/features/notifications/domain/notification_model.dart';

abstract class Notifications {
  Future<List<NotificationModel>> getNotification();
  Future<bool> deleteNotification({required String notificationId});

  Future<bool> init() {
    throw UnimplementedError('Notification Init not defined');
  }
}
