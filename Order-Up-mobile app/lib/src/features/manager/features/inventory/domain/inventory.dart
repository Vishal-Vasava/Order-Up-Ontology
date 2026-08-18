import 'package:orderly_ecom/src/features/delivery/domain/delivery.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/filters.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/domain/manager_order.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class Inventory {
  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        data: List<InventoryItem>.from(
            json['data'].map((x) => InventoryItem.fromJson(x))),
        nextCursor: json.containsKey('next_curso') ? json['next_cursor'] : '',
      );
  Inventory({
    required this.data,
    required this.nextCursor,
  });

  List<InventoryItem> data;
  String nextCursor;
}

class InventoryItem {
  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
      id: json['_id'],
      name: json['name'],
      desc: json['desc'],
      image: json['image'],
      price: json['price'].toString().parsedString.toDouble(),
      qty: json['qty'],
      visible: json['visible'],
      deleted: json['deleted'],
      currency: Currency.fromJson(json['_currency']),
      producer: Producer.fromJson(json['_producer']),
      creator: json['_creator'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      imageUrl: json['image_url'],
      unit: json['unit'],
      datumId: json['id'],
      returnPolicy: json['_returnPolicy'] == null
          ? null
          : ReturnPolicy.fromJson(json['_returnPolicy']),
      estimatedPickup: json['_estimatedPickup'] == null
          ? null
          : EstimatedPickup.fromJson(json['_estimatedPickup']),
      filters: json['_filters'] == null
          ? []
          : List<Filters>.from(
              json['_filters'].map((x) => Filters.fromJson(x))));
  InventoryItem({
    this.id,
    this.name,
    this.desc,
    this.image,
    this.price,
    this.qty,
    this.visible,
    this.deleted,
    this.currency,
    this.producer,
    this.creator,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.unit,
    this.datumId,
    this.returnPolicy,
    this.estimatedPickup,
    this.filters,
  });

  String? id;
  String? name;
  String? desc;
  String? image;
  double? price;
  int? qty;
  bool? visible;
  bool? deleted;
  Currency? currency;
  Producer? producer;
  String? creator;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? imageUrl;
  String? unit;
  String? datumId;
  ReturnPolicy? returnPolicy;
  EstimatedPickup? estimatedPickup;
  List<Filters>? filters;
}

class ReturnPolicy {
  ReturnPolicy({
    this.id,
    this.title,
    this.code,
    this.returnPolicyId,
  });

  factory ReturnPolicy.fromJson(Map<String, dynamic> json) => ReturnPolicy(
        id: json['_id'],
        title: json['title'],
        code: json['code'],
        returnPolicyId: json['id'],
      );
  String? id;
  String? title;
  String? code;
  String? returnPolicyId;
}

class EstimatedPickup {
  EstimatedPickup({
    this.id,
    this.producer,
    this.title,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.estimatedPickupId,
  });

  factory EstimatedPickup.fromJson(Map<String, dynamic> json) =>
      EstimatedPickup(
        id: json['_id'],
        producer: json['_producer'],
        title: json['title'],
        deleted: json['deleted'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        estimatedPickupId: json['id'],
      );
  String? id;
  String? producer;
  String? title;
  bool? deleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? estimatedPickupId;
}
