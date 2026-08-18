import 'dart:convert';

ProductReason productReasonFromJson(String str) =>
    ProductReason.fromJson(json.decode(str));

class ProductReason {
  ProductReason({
    required this.data,
  });

  factory ProductReason.fromJson(Map<String, dynamic> json) => ProductReason(
        data: List<ReasonData>.from(
            json['data'].map((x) => ReasonData.fromJson(x))),
      );
  List<ReasonData> data;
}

class ReasonData {
  ReasonData({
    required this.id,
    required this.title,
    required this.code,
  });

  factory ReasonData.fromJson(Map<String, dynamic> json) => ReasonData(
        id: json['_id'],
        title: json['title'],
        code: json['code'],
      );
  String id;
  String title;
  String code;
}
