import 'package:orderly_ecom/src/utils/extensions.dart';

class Claim {
  factory Claim.fromJson(Map<String, dynamic> json) => Claim(
        claimData: List<ClaimData>.from(
            json['order_details'].map((x) => ClaimData.fromJson(x))),
        paidAmount: json['paid_amount'].toString().parsedString.toDouble(),
        pendingAmount:
            json['pending_amount'].toString().parsedString.toDouble(),
        totalAmount: json['total_amount'].toString().parsedString.toDouble(),
      );
  Claim({
    required this.claimData,
    required this.paidAmount,
    required this.pendingAmount,
    required this.totalAmount,
  });

  final List<ClaimData> claimData;
  final double paidAmount;
  final double pendingAmount;
  final double totalAmount;

  Claim copyWith({List<ClaimData>? claimData}) {
    return Claim(
      claimData: claimData ?? this.claimData,
      paidAmount: paidAmount,
      pendingAmount: pendingAmount,
      totalAmount: totalAmount,
    );
  }
}

class ClaimData {
  factory ClaimData.fromJson(Map<String, dynamic> json) => ClaimData(
        id: json['_id'],
        price: json['price'].toString().parsedString.toDouble(),
        qty: json['qty'],
        createdAt: DateTime.parse(json['createdAt']),
        customer: ClaimCustomer.fromJson(json['_customer']),
        orderId: json['order_number'],
        currency: ClaimCurrency.fromJson(json['_currency']),
        paidStatus: json['paid_status'],
        orderSum: json['order_sum'].toString().parsedString.toDouble(),
      );
  ClaimData({
    required this.id,
    required this.price,
    required this.customer,
    required this.orderId,
    required this.qty,
    required this.createdAt,
    required this.currency,
    required this.paidStatus,
    required this.orderSum,
  });

  String id;
  double price;
  int qty;
  DateTime createdAt;
  ClaimCustomer customer;
  ClaimCurrency currency;
  String orderId;
  bool paidStatus;
  double orderSum;
}

class ClaimCurrency {
  factory ClaimCurrency.fromJson(Map<String, dynamic> json) => ClaimCurrency(
        name: json['name'],
        locale: json['locale'],
      );
  ClaimCurrency({
    this.name,
    this.locale,
  });

  String? name;
  String? locale;
}

class ClaimCustomerDetails {
  factory ClaimCustomerDetails.fromJson(Map<String, dynamic> json) =>
      ClaimCustomerDetails(
        uaId: json['ua_id'],
        userid: json['userid'],
        userName: json['user_name'],
        mobile: json['mobile'],
        emailId: json['email_id'],
        streetNo: json['street_no'],
        flatNo: json['flat_no'],
        address: json['address'],
        zipcode: json['zipcode'],
        city: json['city'],
        state: json['state'],
        country: json['country'],
        addLatitude: json['add_latitude'],
        addLongitude: json['add_longitude'],
        addressType: json['address_type'],
        isDefault: json['is_default'],
        createdOn: DateTime.parse(json['created_on']),
      );
  ClaimCustomerDetails({
    this.uaId,
    this.userid,
    this.userName,
    this.mobile,
    this.emailId,
    this.streetNo,
    this.flatNo,
    this.address,
    this.zipcode,
    this.city,
    this.state,
    this.country,
    this.addLatitude,
    this.addLongitude,
    this.addressType,
    this.isDefault,
    this.createdOn,
  });

  int? uaId;
  String? userid;
  String? userName;
  String? mobile;
  String? emailId;
  String? streetNo;
  String? flatNo;
  String? address;
  String? zipcode;
  String? city;
  String? state;
  String? country;
  String? addLatitude;
  String? addLongitude;
  String? addressType;
  int? isDefault;
  DateTime? createdOn;
}

class ClaimCustomer {
  factory ClaimCustomer.fromJson(Map<String, dynamic> json) => ClaimCustomer(
        email: json['email'],
        phone: json['phone'],
        firstName: json['first_name'],
        lastName: json['last_name'],
      );
  ClaimCustomer({
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
  });

  String? email;
  String? phone;
  String? firstName;
  String? lastName;
}
