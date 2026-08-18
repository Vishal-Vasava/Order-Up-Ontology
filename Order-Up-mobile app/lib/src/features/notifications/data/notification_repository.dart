import 'package:dio/dio.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_role_enum.dart';
import 'package:orderly_ecom/src/features/notifications/domain/notification_model.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/features/notifications/data/notifications.dart';

class NotificationRepository extends Notifications {
  NotificationRepository({required this.networkAdapter});
  final NetworkAdapter networkAdapter;

  @override
  Future<List<NotificationModel>> getNotification() async {
    try {
      String url = '';
      final authUser = inject.get<AuthLocalRepository>().authUser;
      if (authUser.userType! == AuthRole.consumer.name) {
        url = Endpoints.customerNotification;
      } else if (authUser.userType! == AuthRole.producer.name) {
        url = Endpoints.storeNotification;
      } else {
        url = Endpoints.agentNotification;
      }
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return (response.data['data'] as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<bool> deleteNotification({required String notificationId}) async {
    try {
      String url = '';
      final authUser = inject.get<AuthLocalRepository>().authUser;
      if (authUser.userType! == AuthRole.consumer.name) {
        url = '${Endpoints.customerDeleteNotification}/$notificationId';
      } else if (authUser.userType! == AuthRole.producer.name) {
        url = '${Endpoints.storeDeleteNotification}/$notificationId';
      } else {
        url = '${Endpoints.agentDeleteNotification}/$notificationId';
      }
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['msg'] == 'Success') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  // @override
  // FirebaseMessaging get messageInstance => throw UnimplementedError();
}
