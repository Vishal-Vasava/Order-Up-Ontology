import 'package:hive_flutter/hive_flutter.dart';
import 'package:orderly_ecom/src/config/config.dart';

part 'address.g.dart';

@HiveType(typeId: HiveTypes.userAddress)
class Address {
  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json['_id'],
        customer: json['_customer'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        phone: json['phone'],
        houseNo: json['house_no'],
        address: json['address'],
        street: json['street'],
        zipCode: json['zip_code'],
        city: json['city'],
        state: json['state'],
        country: json['country'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        type: json['type'],
        isDefault: json['is_default'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
  Address({
    required this.id,
    this.customer,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.houseNo,
    this.address,
    this.street,
    this.zipCode,
    this.city,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    this.type,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? customer;
  @HiveField(2)
  final String? firstName;
  @HiveField(3)
  final String? lastName;
  @HiveField(4)
  final String? email;
  @HiveField(5)
  final String? phone;
  @HiveField(6)
  final int? houseNo;
  @HiveField(7)
  final String? address;
  @HiveField(8)
  final String? street;
  @HiveField(9)
  final String? zipCode;
  @HiveField(10)
  final String? city;
  @HiveField(11)
  final String? state;
  @HiveField(12)
  final String? country;
  @HiveField(13)
  final String? latitude;
  @HiveField(14)
  final String? longitude;
  @HiveField(15)
  final String? type;
  @HiveField(16)
  final bool? isDefault;
  @HiveField(17)
  final DateTime? createdAt;
  @HiveField(18)
  final DateTime? updatedAt;
}
