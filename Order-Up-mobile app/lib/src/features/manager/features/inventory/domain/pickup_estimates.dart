import 'dart:convert';

PickupEstimates pickupEstimatesFromJson(String str) =>
    PickupEstimates.fromJson(json.decode(str));

class PickupEstimates {
  PickupEstimates({
    required this.data,
  });

  factory PickupEstimates.fromJson(Map<String, dynamic> json) =>
      PickupEstimates(
        data: List<ProductEstimates>.from(
            json['data'].map((x) => ProductEstimates.fromJson(x))),
      );
  List<ProductEstimates> data;
}

class ProductEstimates {
  ProductEstimates({
    required this.id,
    required this.producer,
    required this.title,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductEstimates.fromJson(Map<String, dynamic> json) =>
      ProductEstimates(
        id: json['_id'],
        producer: json['_producer'],
        title: json['title'],
        deleted: json['deleted'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
  String id;
  String? producer;
  String title;
  bool deleted;
  DateTime createdAt;
  DateTime updatedAt;
}
