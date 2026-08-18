import 'package:orderly_ecom/src/features/delivery/domain/delivery.dart';
import 'package:orderly_ecom/src/features/delivery/domain/delivery_order_detail.dart';

abstract class DeliveryInterface {
  Future<List<Delivery>> getOrders({required String status});

  Future<DeliveryOrderDetail?> orderDetail({required String orderDetailId});

  Future<bool> updateOrderStatus({
    required List<String> orderDetailId,
    required String status,
  });
}
