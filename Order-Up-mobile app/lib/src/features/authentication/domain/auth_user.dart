import 'package:hive_flutter/hive_flutter.dart';
import 'package:orderly_ecom/src/config/config.dart';
import 'package:orderly_ecom/src/features/address/domain/address.dart';

part 'auth_user.g.dart';

@HiveType(typeId: HiveTypes.authUser)
class AuthUser {
  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['_id'],
        fbId: json['fb_id'],
        email: json['email'],
        phone: json['phone'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        gender: json['gender'],
        version: json['version'],
        signupType: json['signup_type'],
        deviceId: json['device_id'],
        fcmId: json['fcm_id'],
        device: json['device'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        userType: json['user_type'],
        status: json['status'],
        addressLine: json['address_line'],
        zipCode: json['zip_code'],
        cart: List<dynamic>.from(json['cart'].map((x) => x)),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        address: json.containsKey('address')
            ? List<Address>.from(
                json['address'].map((x) => Address.fromJson(x)))
            : null,
        imageUrl: json['image_url'],
        authUserId: json['id'],
      );
  AuthUser({
    required this.id,
    required this.fbId,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.gender,
    this.version,
    this.signupType,
    this.deviceId,
    this.fcmId,
    this.device,
    this.latitude,
    this.longitude,
    this.userType,
    this.status,
    this.addressLine,
    this.zipCode,
    this.cart,
    this.createdAt,
    this.updatedAt,
    this.address,
    this.imageUrl,
    this.authUserId,
  });
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? fbId;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? phone;
  @HiveField(4)
  final String? firstName;
  @HiveField(5)
  final String? lastName;
  @HiveField(6)
  final String? gender;
  @HiveField(7)
  final String? version;
  @HiveField(8)
  final String? signupType;
  @HiveField(9)
  final String? deviceId;
  @HiveField(10)
  final String? fcmId;
  @HiveField(11)
  final String? device;
  @HiveField(12)
  final String? latitude;
  @HiveField(13)
  final String? longitude;
  @HiveField(14)
  final String? userType;
  @HiveField(15)
  final bool? status;
  @HiveField(16)
  final String? addressLine;
  @HiveField(17)
  final String? zipCode;
  @HiveField(18)
  final List<dynamic>? cart;
  @HiveField(19)
  final DateTime? createdAt;
  @HiveField(20)
  final DateTime? updatedAt;
  @HiveField(21)
  final List<Address>? address;
  @HiveField(22)
  final String? imageUrl;
  @HiveField(23)
  final String? authUserId;

  AuthUser copyWith({
    String? firstName,
    String? lastName,
    String? emailId,
    String? mobile,
    String? address,
    String? zipCode,
    String? latitude,
    String? longitude,
    String? profilePicture,
  }) {
    return AuthUser(
      id: id,
      fbId: fbId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: emailId ?? email,
      phone: mobile ?? phone,
      userType: userType,
      addressLine: address,
      zipCode: zipCode ?? this.zipCode,
      signupType: signupType,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: profilePicture ?? imageUrl,
    );
  }
}
