import 'package:orderly_ecom/src/features/address/domain/address.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/domain/manager_order.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class Order {
  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['_id'],
        customer: json['_customer'],
        deliveryType: json['delivery_type'],
        deliveryDate: json['delivery_date'] == null
            ? null
            : DateTime.parse(json['delivery_date']),
        deliverySlot: json['delivery_slot'],
        subTotal: json['sub_total'].toString().parsedString.toDouble(),
        deliveryCharge: json['delivery_charge'],
        conveyanceCharge: json['conveyance_charge'],
        discount: json['discount'],
        destAddress: json['dest_address'] == null
            ? null
            : Address.fromJson(json['dest_address']),
        transactionId: json['transaction_id'],
        paymentMode: json['payment_mode'],
        currency: json['_currency'] == null
            ? null
            : Currency.fromJson(json['_currency']),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        incrId: json['incr_id'],
        orderItems: json['order_items'] == null
            ? []
            : List<OrderItem>.from(
                json['order_items']!.map((x) => OrderItem.fromJson(x))),
        orderTotal: json['order_total'].toString().parsedString.toDouble(),
        orderNumber: json['order_number'],
        orderId: json['id'],
      );
  Order({
    this.id,
    this.customer,
    this.deliveryType,
    this.deliveryDate,
    this.deliverySlot,
    this.subTotal,
    this.deliveryCharge,
    this.conveyanceCharge,
    this.discount,
    this.destAddress,
    this.transactionId,
    this.paymentMode,
    this.currency,
    this.createdAt,
    this.updatedAt,
    this.incrId,
    this.orderItems,
    this.orderTotal,
    this.orderNumber,
    this.orderId,
  });

  final String? id;
  final String? customer;
  final String? deliveryType;
  final DateTime? deliveryDate;
  final String? deliverySlot;
  final double? subTotal;
  final int? deliveryCharge;
  final int? conveyanceCharge;
  final int? discount;
  final Address? destAddress;
  final String? transactionId;
  final String? paymentMode;
  final Currency? currency;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? incrId;
  final List<OrderItem>? orderItems;
  final double? orderTotal;
  final String? orderNumber;
  final String? orderId;
}

class OrderItem {
  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json['_id'],
        order: json['_order'],
        producer: json['_producer'],
        // producer: json['_producer'] == null
        //     ? null
        //     : Producer.fromJson(json['_producer']),
        product: ProductItems.fromJson(json['_product']),
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
        productImageUrl: json['product_image_url'],
        orderItemTotal:
            json['order_item_total'].toString().parsedString.toDouble(),
        productDesc: json['product_desc'],
        orderItemId: json['id'],
        showReviewForm: json['show_review_form'],
      );
  OrderItem({
    this.id,
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
    this.productImageUrl,
    this.orderItemTotal,
    this.productDesc,
    this.orderItemId,
    this.showReviewForm,
  });

  final String? id;
  final String? order;
  // final Producer? producer;
  String? producer;
  final ProductItems? product;
  final String? productName;
  final String? productImage;
  final double? price;
  final int? qty;
  final String? status;
  final Address? srcAddress;
  final List<History>? history;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? productImageUrl;
  final double? orderItemTotal;
  final String? productDesc;
  final String? orderItemId;
  final bool? showReviewForm;
}

class History {
  factory History.fromJson(Map<String, dynamic> json) => History(
        status: json['status'],
        id: json['_id'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
      );
  History({
    this.status,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  final String? status;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => {
        'status': status,
        '_id': id,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class ProductItems {
  ProductItems({
    required this.id,
    required this.name,
    required this.desc,
    required this.image,
    required this.price,
    required this.qty,
    required this.visible,
    required this.deleted,
    required this.currency,
    required this.producer,
    required this.creator,
    this.returnPolicy,
    this.estimatedPickup,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrl,
    required this.unit,
    required this.productId,
  });

  factory ProductItems.fromJson(Map<String, dynamic> json) => ProductItems(
        id: json['_id'],
        name: json['name'],
        desc: json['desc'],
        image: json['image'],
        price: json['price'],
        qty: json['qty'],
        visible: json['visible'],
        deleted: json['deleted'],
        currency: json['_currency'],
        producer: json['_producer'],
        creator: json['_creator'],
        returnPolicy: json['_returnPolicy'] == null
            ? null
            : ReturnPolicyItems.fromJson(json['_returnPolicy']),
        estimatedPickup: json['_estimatedPickup'] == null
            ? null
            : EstimatedPickupItems.fromJson(json['_estimatedPickup']),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        imageUrl: json['image_url'],
        unit: json['unit'],
        productId: json['id'],
      );
  String id;
  String name;
  String desc;
  String image;
  int price;
  int qty;
  bool visible;
  bool deleted;
  String? currency;
  String producer;
  String creator;
  ReturnPolicyItems? returnPolicy;
  EstimatedPickupItems? estimatedPickup;
  DateTime createdAt;
  DateTime updatedAt;
  String imageUrl;
  String unit;
  String productId;
}

class EstimatedPickupItems {
  EstimatedPickupItems({
    required this.id,
    required this.producer,
    required this.title,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
    required this.estimatedPickupId,
  });

  factory EstimatedPickupItems.fromJson(Map<String, dynamic> json) =>
      EstimatedPickupItems(
        id: json['_id'],
        producer: json['_producer'],
        title: json['title'],
        deleted: json['deleted'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        estimatedPickupId: json['id'],
      );
  String id;
  String? producer;
  String title;
  bool deleted;
  DateTime createdAt;
  DateTime updatedAt;
  String estimatedPickupId;
}

class ReturnPolicyItems {
  ReturnPolicyItems({
    required this.id,
    required this.title,
    required this.code,
    required this.returnPolicyId,
  });

  factory ReturnPolicyItems.fromJson(Map<String, dynamic> json) =>
      ReturnPolicyItems(
        id: json['_id'],
        title: json['title'],
        code: json['code'],
        returnPolicyId: json['id'],
      );
  String id;
  String title;
  String code;
  String returnPolicyId;
}
