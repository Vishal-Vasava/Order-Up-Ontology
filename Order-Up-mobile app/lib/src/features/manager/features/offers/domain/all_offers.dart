// import 'dart:convert';

// AllOffers allOffersFromJson(String str) => AllOffers.fromJson(json.decode(str));

// class AllOffers {
//   factory AllOffers.fromJson(Map<String, dynamic> json) => AllOffers(
//         status: json['status'],
//         offers: List<Offer>.from(json['offers'].map((x) => Offer.fromJson(x))),
//         msg: json['msg'],
//       );
//   AllOffers({
//     required this.status,
//     required this.offers,
//     required this.msg,
//   });

//   int status;
//   List<Offer> offers;
//   String msg;
// }

// class Offer {
//   factory Offer.fromJson(Map<String, dynamic> json) => Offer(
//         id: json['id'],
//         fleetId: json['fleet_id'],
//         offerPer: json['offer_per'],
//         startDate: DateTime.parse(json['start_date']),
//         endDate: DateTime.parse(json['end_date']),
//         status: json['status'],
//         customers: List<CustomerData>.from(
//             json['customers'].map((x) => CustomerData.fromJson(x))),
//         products: List<Product>.from(
//             json['products'].map((x) => Product.fromJson(x))),
//       );
//   Offer({
//     required this.id,
//     required this.fleetId,
//     required this.offerPer,
//     required this.startDate,
//     required this.endDate,
//     required this.status,
//     required this.customers,
//     required this.products,
//   });

//   int id;
//   String fleetId;
//   String offerPer;
//   DateTime startDate;
//   DateTime endDate;
//   int status;
//   List<CustomerData> customers;
//   List<Product> products;
// }

// class CustomerData {
//   factory CustomerData.fromJson(Map<String, dynamic> json) => CustomerData(
//         id: json['id'],
//         custId: json['cust_id'],
//         offerId: json['offer_id'],
//         userId: json['user_id'],
//         firstName: json['first_name'],
//         lastName: json['last_name'],
//         middleName: json['middle_name'],
//         gender: json['gender'],
//         emailId: json['email_id'],
//         mobile: json['mobile'],
//         fbId: json['fb_id'],
//         password: json['password'],
//         deviceId: json['device_id'],
//         fcmId: json['fcm_id'],
//         profilePic: json['profile_pic'],
//         address: json['address'],
//         zipCode: json['zip_code'],
//         countryCode: json['country_code'],
//         signupType: json['signup_type'],
//         userType: json['user_type'],
//         version: json['version'],
//         device: json['device'],
//         latitude: json['latitude'],
//         longitude: json['longitude'],
//         distance: json['distance'],
//         status: json['status'],
//         removeAccountReason: json['remove_account_reason'],
//         producerid: json['producerid'],
//         registerDt: json['register_dt'],
//         registerAt: DateTime.parse(json['register_at']),
//       );
//   CustomerData({
//     required this.id,
//     required this.custId,
//     required this.offerId,
//     required this.userId,
//     required this.firstName,
//     required this.lastName,
//     this.middleName,
//     this.gender,
//     required this.emailId,
//     required this.mobile,
//     required this.fbId,
//     this.password,
//     required this.deviceId,
//     required this.fcmId,
//     this.profilePic,
//     required this.address,
//     required this.zipCode,
//     this.countryCode,
//     required this.signupType,
//     required this.userType,
//     required this.version,
//     required this.device,
//     required this.latitude,
//     required this.longitude,
//     required this.distance,
//     required this.status,
//     this.removeAccountReason,
//     required this.producerid,
//     this.registerDt,
//     required this.registerAt,
//   });

//   int id;
//   int custId;
//   int offerId;
//   int userId;
//   String firstName;
//   String lastName;
//   dynamic middleName;
//   dynamic gender;
//   String emailId;
//   String mobile;
//   String fbId;
//   dynamic password;
//   String deviceId;
//   String fcmId;
//   dynamic profilePic;
//   String address;
//   String zipCode;
//   dynamic countryCode;
//   String signupType;
//   int userType;
//   String version;
//   String device;
//   String latitude;
//   String longitude;
//   int distance;
//   int status;
//   dynamic removeAccountReason;
//   int producerid;
//   dynamic registerDt;
//   DateTime registerAt;
// }

// class Product {
//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//         id: json['id'],
//         prodId: json['prod_id'],
//         offerId: json['offer_id'],
//         productId: json['product_id'],
//         producerid: json['producerid'],
//         productName: json['product_name'],
//         productDesc: json['product_desc'],
//         ratePerHour: json['rate_per_hour'],
//         truckName: json['truck_name'],
//         truckNumber: json['truck_number'],
//         displayStatus: json['display_status'],
//         productQty: json['product_qty'],
//         imgPaths: json['img_paths'],
//         currencyId: json['currency_id'],
//         unitId: json['unit_id'],
//         status: json['status'],
//         createdOn: DateTime.parse(json['created_on']),
//       );
//   Product({
//     required this.id,
//     required this.prodId,
//     required this.offerId,
//     required this.productId,
//     required this.producerid,
//     required this.productName,
//     required this.productDesc,
//     required this.ratePerHour,
//     this.truckName,
//     this.truckNumber,
//     required this.displayStatus,
//     required this.productQty,
//     this.imgPaths,
//     required this.currencyId,
//     required this.unitId,
//     required this.status,
//     required this.createdOn,
//   });

//   int id;
//   int prodId;
//   int offerId;
//   int productId;
//   int producerid;
//   String productName;
//   String productDesc;
//   String ratePerHour;
//   dynamic truckName;
//   dynamic truckNumber;
//   int displayStatus;
//   int productQty;
//   dynamic imgPaths;
//   int currencyId;
//   int unitId;
//   int status;
//   DateTime createdOn;
// }

// To parse this JSON data, do
//
//     final allOffers = allOffersFromJson(jsonString);

import 'dart:convert';

AllOffers allOffersFromJson(String str) => AllOffers.fromJson(json.decode(str));

class AllOffers {
  factory AllOffers.fromJson(Map<String, dynamic> json) => AllOffers(
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
        statusCode: json['statusCode'],
      );
  AllOffers({
    required this.data,
    required this.statusCode,
  });

  List<Datum> data;
  int statusCode;
}

class Datum {
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        title: json['title'],
        id: json['_id'],
        producer: json['_producer'],
        offerPercentage: json['offerPercentage'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        status: json['status'],
        allCustomers: json['allCustomers'],
        allProducts: json['allProducts'],
        customers: List<String>.from(json['customers'].map((x) => x)),
        products: List<String>.from(json['products'].map((x) => x)),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
  Datum({
    this.title,
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
  });

  String? title;
  String id;
  String producer;
  int offerPercentage;
  DateTime startDate;
  DateTime endDate;
  bool status;
  bool allCustomers;
  bool allProducts;
  List<String> customers;
  List<String> products;
  DateTime createdAt;
  DateTime updatedAt;
}
