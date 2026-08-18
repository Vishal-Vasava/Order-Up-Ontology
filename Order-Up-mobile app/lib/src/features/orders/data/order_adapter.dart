import 'package:orderly_ecom/src/features/orders/domain/invoice.dart';
import 'package:orderly_ecom/src/features/orders/domain/order.dart';
import 'package:orderly_ecom/src/features/orders/domain/product_return_reason.dart';
import 'package:orderly_ecom/src/features/orders/domain/track_order.dart';

abstract class OrderAdapter {
  Future<List<Order>> getOrderList({
    required String timeType,
    required String duration,
    required String status,
  });

  Future<Invoice?> downloadInvoice({required String orderId});

  Future<TrackOrder?> trackOrder({required String orderDetialId});

  Future<bool> addReview({
    required String orderDetailId,
    required String appRating,
    required String productRating,
    required String orderRating,
    required String paymentRaing,
    required String overall,
    required String comment,
  });

  void searchOrders({required String searchText}) {}

  Future<String> getPaymentUrl();
  Future<ProductReturnReason?> getReturnProductReasonById({
    required String id,
    required String type,
  });

  Future<bool> returnReplaceOrder({
    required String status,
    required String reason,
    required String order,
    required String orderItem,
  });
}
