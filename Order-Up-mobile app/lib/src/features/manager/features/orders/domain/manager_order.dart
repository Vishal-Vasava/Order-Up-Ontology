import 'package:orderly_ecom/src/features/delivery/domain/delivery.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class ManagerOrder {
  factory ManagerOrder.fromJson(Map<String, dynamic> json) => ManagerOrder(
        id: json['_id'],
        deliveryType: json['delivery_type'],
        deliveryDate: DateTime.parse(json['delivery_date']),
        deliverySlot: json['delivery_slot'],
        currency: Currency.fromJson(json['_currency']),
        createdAt: DateTime.parse(json['createdAt']),
        status: json['status'],
        orderNumber: json['order_number'],
        orderItemsAmount:
            json['order_items_amount'].toString().parsedString.toDouble(),
        producer: Producer.fromJson(json['producer']),
        orderItemsCount: json['order_items_count'],
      );
  ManagerOrder({
    required this.id,
    required this.deliveryType,
    required this.deliveryDate,
    required this.deliverySlot,
    required this.currency,
    required this.orderNumber,
    required this.createdAt,
    required this.status,
    required this.orderItemsAmount,
    required this.producer,
    required this.orderItemsCount,
  });

  String id;
  String deliveryType;
  DateTime deliveryDate;
  String deliverySlot;
  Currency currency;
  DateTime createdAt;
  String orderNumber;
  String status;
  double orderItemsAmount;
  Producer producer;
  int orderItemsCount;
}

class Currency {
  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: !json.containsKey('_id') ? '' : json['_id'],
        name: json['name'],
        locale: json['locale'],
        code: json['code'],
        createdAt: !json.containsKey('createdAt')
            ? DateTime.now()
            : DateTime.parse(json['createdAt']),
        updatedAt: !json.containsKey('updatedAt')
            ? DateTime.now()
            : DateTime.parse(json['updatedAt']),
      );
  Currency({
    this.id,
    this.name,
    this.locale,
    this.createdAt,
    this.updatedAt,
    this.code,
  });

  String? id;
  String? name;
  String? locale;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? code;
}
