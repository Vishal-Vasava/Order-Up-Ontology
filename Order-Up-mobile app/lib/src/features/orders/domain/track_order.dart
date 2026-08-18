import 'package:orderly_ecom/src/features/address/domain/address.dart';
import 'package:orderly_ecom/src/features/delivery/domain/delivery.dart';
import 'package:orderly_ecom/src/features/orders/domain/order.dart';
import 'package:orderly_ecom/src/features/product/domain/product.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class TrackOrder {
  factory TrackOrder.fromJson(Map<String, dynamic> json) => TrackOrder(
        id: json['_id'],
        cancelReason: json['reject_reason'],
        order: json['_order'] == null ? null : Order.fromJson(json['_order']),
        producer: json['_producer'] == null
            ? null
            : Producer.fromJson(json['_producer']),
        product: json['_product'] == null
            ? null
            : Product.fromJson(json['_product']),
        productName: json['product_name'],
        productImage: json['product_image'],
        price: json['price'].toString().parsedString.toDouble(),
        qty: json['qty'],
        status: json['status'],
        srcAddress: null,
        // srcAddress: json['src_address'] == null
        //     ? null
        //     : Address.fromJson(json['src_address']),
        history: json['history'] == null
            ? []
            : List<History>.from(
                json['history']!.map((x) => History.fromJson(x))),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        deliveryAgent: json['_delivery_agent'],
        productImageUrl: json['product_image_url'],
        orderItemTotal:
            json['order_item_total'].toString().parsedString.toDouble(),
        productDesc: json['product_desc'],
        trackOrderId: json['id'],
      );
  TrackOrder({
    this.id,
    this.cancelReason,
    this.order,
    this.producer,
    this.product,
    this.productName,
    this.productImage,
    this.price,
    this.qty,
    this.status,
    this.srcAddress,
    this.history,
    this.createdAt,
    this.updatedAt,
    this.deliveryAgent,
    this.productImageUrl,
    this.orderItemTotal,
    this.productDesc,
    this.trackOrderId,
  });

  final String? id;
  final Order? order;
  final Producer? producer;
  final Product? product;
  final String? productName;
  final String? productImage;
  final double? price;
  final int? qty;
  final String? status;
  final Address? srcAddress;
  final List<History>? history;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? deliveryAgent;
  final String? productImageUrl;
  final double? orderItemTotal;
  final String? productDesc;
  final String? trackOrderId;
  final String? cancelReason;
}
