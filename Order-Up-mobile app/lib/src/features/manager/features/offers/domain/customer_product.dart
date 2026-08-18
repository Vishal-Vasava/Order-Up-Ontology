// import 'dart:convert';

// ProductCustomer productCustomerFromJson(String str) =>
//     ProductCustomer.fromJson(json.decode(str));

// class ProductCustomer {
//   factory ProductCustomer.fromJson(Map<String, dynamic> json) =>
//       ProductCustomer(
//         status: json['status'],
//         product:
//             List<Product>.from(json['product'].map((x) => Product.fromJson(x))),
//         customer: List<Customer>.from(
//             json['customer'].map((x) => Customer.fromJson(x))),
//         msg: json['msg'],
//       );
//   ProductCustomer({
//     required this.status,
//     required this.product,
//     required this.customer,
//     required this.msg,
//   });

//   int status;
//   List<Product> product;
//   List<Customer> customer;
//   String msg;
// }

// class Customer {
//   factory Customer.fromJson(Map<String, dynamic> json) => Customer(
//         firstName: json['first_name'],
//         lastName: json['last_name'],
//         mobile: json['mobile'],
//         totalAmountSpend: json['total_amount_spend'],
//         currencyType: json['currency_type'],
//         currency: json['currency'],
//         custId: json['cust_id'],
//         userId: json['user_id'],
//       );
//   Customer({
//     this.firstName,
//     this.lastName,
//     this.mobile,
//     required this.totalAmountSpend,
//     required this.currencyType,
//     required this.currency,
//     required this.custId,
//     required this.userId,
//   });

//   String? firstName;
//   String? lastName;
//   String? mobile;
//   int? totalAmountSpend;
//   dynamic currencyType;
//   dynamic currency;
//   int? custId;
//   int userId;
// }

// class Product {
//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//         productId: json['product_id'],
//         producerid: json['producerid'],
//         productName: json['product_name'],
//         productDesc: json['product_desc'],
//         ratePerHour: json['rate_per_hour'],
//         truckName: json['truck_name'],
//         truckNumber: json['truck_number'],
//         displayStatus: json['display_status'],
//         productQty: json['product_qty'],
//         productImage: json['product_image'],
//         currency: json['currency'],
//         unit: json['unit'],
//       );
//   Product({
//     required this.productId,
//     required this.producerid,
//     required this.productName,
//     required this.productDesc,
//     required this.ratePerHour,
//     this.truckName,
//     this.truckNumber,
//     required this.displayStatus,
//     required this.productQty,
//     required this.productImage,
//     required this.currency,
//     required this.unit,
//   });

//   int productId;
//   int producerid;
//   String productName;
//   String productDesc;
//   String ratePerHour;
//   dynamic truckName;
//   dynamic truckNumber;
//   int displayStatus;
//   int productQty;
//   String productImage;
//   dynamic currency;
//   dynamic unit;
// }

// class EnumValues<T> {
//   EnumValues(this.map);
//   Map<String, T> map;
//   late Map<T, String> reverseMap;

//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
