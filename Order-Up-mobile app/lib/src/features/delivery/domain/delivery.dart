import 'package:orderly_ecom/src/features/address/domain/address.dart';

class Delivery {
  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        createdAt: DateTime.parse(json['createdAt']),
        orderNumber: json['order_number'],
        producer: Producer.fromJson(json['_producer']),
        status: json['status'],
        srcAddress: null, // Address.fromJson(json['src_address']),
        destAddress: Address.fromJson(json['dest_address']),
        deliveryType: json['delivery_type'],
        deliveryDate: DateTime.parse(json['delivery_date']),
        deliverySlot: json['delivery_slot'],
        id: json['_id'],
      );
  Delivery({
    this.createdAt,
    this.orderNumber,
    this.producer,
    this.status,
    this.srcAddress,
    this.destAddress,
    this.deliveryType,
    this.deliveryDate,
    this.deliverySlot,
    this.id,
  });

  DateTime? createdAt;
  String? orderNumber;
  Producer? producer;
  String? status;
  Address? srcAddress;
  Address? destAddress;
  String? deliveryType;
  DateTime? deliveryDate;
  String? deliverySlot;
  String? id;
}

class Producer {
  factory Producer.fromJson(Map<String, dynamic> json) => Producer(
        id: json['_id'],
        name: json['name'],
        desc: json['desc'],
        iconUrl: json['icon_url'],
        bannerUrl: json['banner_url'],
      );
  Producer({
    required this.id,
    this.name,
    this.desc,
    this.iconUrl,
    this.bannerUrl,
  });

  final String? id;
  final String? name;
  final String? desc;
  final String? iconUrl;
  final String? bannerUrl;
}
