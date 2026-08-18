import 'package:dio/dio.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/data/manager_order_adapter.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/domain/manager_order.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/domain/manager_order_detail.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/utils/exceptions.dart';

class ManagerOrderRepository extends ManagerOrderAdapter {
  ManagerOrderRepository({required this.networkAdapter});

  final NetworkAdapter networkAdapter;
  @override
  Future<List<ManagerOrder>> getOrderList({required String status}) async {
    try {
      const String url = Endpoints.storeOrders;
      final data = {'status': status};
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return (response.data['data']['orders'] as List)
              .map((e) => ManagerOrder.fromJson(e))
              .toList();
        } else {
          return [];
        }
      } else {
        throw const AppException(message: 'Couldn\'t fetch orders');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<ManagerOrderDetail?> getOrderDetail({
    required String orderId,
    required String status,
  }) async {
    try {
      final String url = '${Endpoints.storeOrderDetailView}/$orderId';
      final data = {'status': status};
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return ManagerOrderDetail.fromJson(response.data['data']);
        } else {
          throw const AppException(message: 'Please try again');
        }
      } else {
        throw const AppException(message: 'Couldn\'t fetch orders');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<bool> updateOrderStatus({
    required List<String> orderDetailId,
    required String orderStatus,
    String? reason,
  }) async {
    try {
      const url = Endpoints.storeUpdateOrderStatus;
      final data = {'order_items_id': orderDetailId, 'status': orderStatus};
      if (reason != null) {
        data['reason'] = reason;
      }
      final response = await networkAdapter.post(url, data: data);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        throw const AppException(message: 'Couldn\'t update orders');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<List<String>> getCancelReason() async {
    try {
      const String url = Endpoints.storeCancelReason;

      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return (response.data['data'] as List)
              .map((e) => e.toString())
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
}
