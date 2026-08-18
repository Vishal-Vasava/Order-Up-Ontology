// To parse this JSON data, do
//
//     final offersById = offersByIdFromJson(jsonString);

import 'dart:convert';

OffersById offersByIdFromJson(String str) =>
    OffersById.fromJson(json.decode(str));

String offersByIdToJson(OffersById data) => json.encode(data.toJson());

class OffersById {
  OffersById({
    required this.data,
    required this.statusCode,
  });

  factory OffersById.fromJson(Map<String, dynamic> json) => OffersById(
        data: Data.fromJson(json['data']),
        statusCode: json['statusCode'],
      );
  Data data;
  int statusCode;

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
        'statusCode': statusCode,
      };
}

class Data {
  Data({
    required this.id,
    required this.producer,
    required this.offerPercentage,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.allCustomers,
    required this.allProducts,
    required this.customers,
    required this.products,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.title,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['_id'],
        producer: json['_producer'],
        offerPercentage: json['offerPercentage'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        status: json['status'],
        allCustomers: json['allCustomers'],
        allProducts: json['allProducts'],
        customers: List<Customers>.from(
            json['customers'].map((x) => Customers.fromJson(x))),
        products: List<Products>.from(
            json['products'].map((x) => Products.fromJson(x))),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
        title: json['title'],
      );
  String id;
  String producer;
  int offerPercentage;
  DateTime startDate;
  DateTime endDate;
  bool status;
  bool allCustomers;
  bool allProducts;
  List<Customers> customers;
  List<Products> products;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String title;

  Map<String, dynamic> toJson() => {
        '_id': id,
        '_producer': producer,
        'offerPercentage': offerPercentage,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'status': status,
        'allCustomers': allCustomers,
        'allProducts': allProducts,
        'customers': List<dynamic>.from(customers.map((x) => x.toJson())),
        'products': List<dynamic>.from(products.map((x) => x.toJson())),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
        'title': title,
      };
}

class Customers {
  Customers({
    required this.id,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.isSelected,
  });

  factory Customers.fromJson(Map<String, dynamic> json) => Customers(
        id: json['_id'],
        email: json['email'],
        phone: json['phone'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        isSelected: json['is_selected'],
      );
  String id;
  String email;
  String phone;
  String firstName;
  String lastName;
  bool isSelected;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'email': email,
        'phone': phone,
        'first_name': firstName,
        'last_name': lastName,
        'is_selected': isSelected,
      };
}

class Products {
  Products({
    required this.id,
    required this.name,
    required this.isSelected,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        id: json['_id'],
        name: json['name'],
        isSelected: json['is_selected'],
      );
  String id;
  String name;
  bool isSelected;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'is_selected': isSelected,
      };
}
