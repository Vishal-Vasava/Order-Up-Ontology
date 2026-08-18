import 'dart:convert';

ProductCustomer productCustomerFromJson(String str) =>
    ProductCustomer.fromJson(json.decode(str));

class ProductCustomer {
  factory ProductCustomer.fromJson(Map<String, dynamic> json) =>
      ProductCustomer(
        data: Data.fromJson(json['data']),
        statusCode: json['statusCode'],
      );
  ProductCustomer({
    required this.data,
    required this.statusCode,
  });

  Data data;
  int statusCode;
}

class Data {
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        customerDetails: List<CustomerDetail>.from(
            json['customer_details'].map((x) => CustomerDetail.fromJson(x))),
        productDetails: List<ProductDetail>.from(
            json['product_details'].map((x) => ProductDetail.fromJson(x))),
      );
  Data({
    required this.customerDetails,
    required this.productDetails,
  });

  List<CustomerDetail> customerDetails;
  List<ProductDetail> productDetails;
}

class CustomerDetail {
  factory CustomerDetail.fromJson(Map<String, dynamic> json) => CustomerDetail(
        id: json['_id'],
        email: json['email'],
        phone: json['phone'],
        firstName: json['first_name'],
        lastName: json['last_name'],
      );
  CustomerDetail({
    this.id,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
  });

  String? id;
  String? email;
  String? phone;
  String? firstName;
  String? lastName;
}

class ProductDetail {
  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        id: json['_id'],
        name: json['name'],
      );
  ProductDetail({
    this.id,
    this.name,
  });

  String? id;
  String? name;
}
