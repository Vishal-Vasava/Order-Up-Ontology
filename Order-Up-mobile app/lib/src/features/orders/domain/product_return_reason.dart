import 'dart:convert';

ProductReturnReason productReturnReasonFromJson(String str) =>
    ProductReturnReason.fromJson(json.decode(str));

class ProductReturnReason {
  ProductReturnReason({
    required this.data,
    required this.statusCode,
  });

  factory ProductReturnReason.fromJson(Map<String, dynamic> json) =>
      ProductReturnReason(
        data: List<Reasons>.from(json['data'].map((x) => Reasons.fromJson(x))),
        statusCode: json['statusCode'],
      );
  List<Reasons> data;
  int statusCode;
}

class Reasons {
  Reasons({
    required this.id,
    required this.type,
    required this.producer,
    required this.title,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reasons.fromJson(Map<String, dynamic> json) => Reasons(
        id: json['_id'],
        type: json['type'],
        producer: json['_producer'],
        title: json['title'],
        deleted: json['deleted'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
  String id;
  String type;
  String producer;
  String title;
  bool deleted;
  DateTime createdAt;
  DateTime updatedAt;
}
