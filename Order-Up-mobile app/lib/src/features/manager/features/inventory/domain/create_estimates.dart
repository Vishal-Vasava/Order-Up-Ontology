import 'dart:convert';

CreateEstimates createEstimatesFromJson(String str) =>
    CreateEstimates.fromJson(json.decode(str));

class CreateEstimates {
  CreateEstimates({
    required this.data,
    required this.statusCode,
  });

  factory CreateEstimates.fromJson(Map<String, dynamic> json) =>
      CreateEstimates(
        data: Data.fromJson(json['data']),
        statusCode: json['statusCode'],
      );
  Data data;
  int statusCode;
}

class Data {
  Data({
    required this.estimatedPickup,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        estimatedPickup: EstimatedPickup.fromJson(json['estimatedPickup']),
      );
  EstimatedPickup estimatedPickup;
}

class EstimatedPickup {
  EstimatedPickup({
    required this.producer,
    required this.title,
    required this.deleted,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EstimatedPickup.fromJson(Map<String, dynamic> json) =>
      EstimatedPickup(
        producer: Producer.fromJson(json['_producer']),
        title: json['title'],
        deleted: json['deleted'],
        id: json['_id'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
  Producer producer;
  String title;
  bool deleted;
  String id;
  DateTime createdAt;
  DateTime updatedAt;
}

class Producer {
  Producer({
    required this.id,
    required this.name,
    required this.desc,
    required this.banner,
    required this.icon,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.bannerUrl,
    required this.iconUrl,
    required this.producerId,
  });

  factory Producer.fromJson(Map<String, dynamic> json) => Producer(
        id: json['_id'],
        name: json['name'],
        desc: json['desc'],
        banner: json['banner'],
        icon: json['icon'],
        status: json['status'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        bannerUrl: json['banner_url'],
        iconUrl: json['icon_url'],
        producerId: json['id'],
      );
  String id;
  String name;
  String desc;
  String banner;
  String icon;
  bool status;
  DateTime createdAt;
  DateTime updatedAt;
  String bannerUrl;
  String iconUrl;
  String producerId;
}
