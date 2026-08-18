import 'package:orderly_ecom/src/features/manager/features/orders/domain/manager_order.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/domain/manager_order_detail.dart';

abstract class ManagerOrderAdapter {
  Future<List<ManagerOrder>> getOrderList({required String status});

  Future<ManagerOrderDetail?> getOrderDetail({
    required String orderId,
    required String status,
  });

  Future<bool> updateOrderStatus({
    required List<String> orderDetailId,
    required String orderStatus,
    String? reason,
  });

  Future<List<String>> getCancelReason();

  void updateOrderListCheck({required bool value, required String productId}) =>
      throw UnimplementedError();
}
