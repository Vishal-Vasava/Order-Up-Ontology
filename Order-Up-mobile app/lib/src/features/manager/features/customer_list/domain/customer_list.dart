import 'package:orderly_ecom/src/features/manager/features/orders/domain/manager_order.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class CustomerList {
  factory CustomerList.fromJson(Map<String, dynamic> json) => CustomerList(
        id: json['_id'],
        email: json['email'],
        phone: json['phone'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        currency: List<Currency>.from(
            json['_currency'].map((x) => Currency.fromJson(x))),
        orderSum: json['order_sum'].toString().parsedString.toDouble(),
      );
  CustomerList({
    required this.id,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.currency,
    required this.orderSum,
  });

  String id;
  String email;
  String phone;
  String firstName;
  String lastName;
  List<Currency> currency;
  double orderSum;
}
