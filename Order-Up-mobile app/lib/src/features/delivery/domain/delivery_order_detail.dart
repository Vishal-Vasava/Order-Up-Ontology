import 'package:orderly_ecom/src/features/address/domain/address.dart';
import 'package:orderly_ecom/src/features/delivery/domain/delivery.dart';

class DeliveryOrderDetail {
  factory DeliveryOrderDetail.fromJson(Map<String, dynamic> json) =>
      DeliveryOrderDetail(
        id: json['_id'],
        deliveryType: json['delivery_type'],
        deliveryDate: DateTime.parse(json['delivery_date']),
        deliverySlot: json['delivery_slot'],
        destAddress: Address.fromJson(json['dest_address']),
        createdAt: DateTime.parse(json['createdAt']),
        orderItems: List<OrderItem>.from(
            json['order_items'].map((x) => OrderItem.fromJson(x))),
        orderTotal: json['order_total'],
        orderNumber: json['order_number'],
        deliveryOrderDetailId: json['id'],
        srcAddress: null, // Address.fromJson(json['src_address']),
        producer: Producer.fromJson(json['_producer']),
      );
  DeliveryOrderDetail({
    this.id,
    this.deliveryType,
    this.deliveryDate,
    this.deliverySlot,
    this.destAddress,
    this.createdAt,
    this.orderItems,
    this.orderTotal,
    this.orderNumber,
    this.deliveryOrderDetailId,
    this.srcAddress,
    this.producer,
  });

  final String? id;
  final String? deliveryType;
  final DateTime? deliveryDate;
  final String? deliverySlot;
  final Address? destAddress;
  final DateTime? createdAt;
  final List<OrderItem>? orderItems;
  final dynamic orderTotal;
  final String? orderNumber;
  final String? deliveryOrderDetailId;
  final Address? srcAddress;
  final Producer? producer;

  DeliveryOrderDetail copyWith({
    List<OrderItem>? orderItems,
  }) {
    return DeliveryOrderDetail(
      id: id,
      deliveryType: deliveryType,
      deliveryDate: deliveryDate,
      deliverySlot: deliverySlot,
      destAddress: destAddress,
      createdAt: createdAt,
      orderItems: orderItems ?? this.orderItems,
      orderNumber: orderNumber,
      deliveryOrderDetailId: deliveryOrderDetailId,
      srcAddress: srcAddress,
      producer: producer,
    );
  }
}

class OrderItem {
  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json['_id'],
        order: json['_order'],
        producer: Producer.fromJson(json['_producer']),
        productName: json['product_name'],
        productImage: json['product_image'],
        productImageUrl: json['product_image_url'],
        orderItemTotal: json['order_item_total'],
        orderItemId: json['id'],
        productDesc: json['product_desc'],
        qty: json['qty'],
        status: json['status'],
      );
  OrderItem({
    this.id,
    this.order,
    this.producer,
    this.productName,
    this.productImage,
    this.productImageUrl,
    this.orderItemTotal,
    this.orderItemId,
    this.productDesc,
    this.qty,
    this.status,
    this.isChecked = false,
  });

  final String? id;
  final String? order;
  final String? productName;
  final String? productImage;
  final int? qty;
  final String? status;
  final Producer? producer;
  final String? productImageUrl;
  final dynamic orderItemTotal;
  final String? orderItemId;
  final String? productDesc;
  bool isChecked;
}
