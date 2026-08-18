import 'package:orderly_ecom/src/features/address/domain/address.dart';
import 'package:orderly_ecom/src/features/delivery/domain/delivery.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/domain/manager_order.dart';
import 'package:orderly_ecom/src/features/orders/domain/order.dart';
import 'package:orderly_ecom/src/features/product/domain/product.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class ManagerOrderDetail {
  factory ManagerOrderDetail.fromJson(Map<String, dynamic> json) =>
      ManagerOrderDetail(
        id: json['_id'],
        customer: json['_customer'] == null
            ? null
            : Customer.fromJson(json['_customer']),
        deliveryType: json['delivery_type'],
        deliveryDate: json['delivery_date'] == null
            ? null
            : DateTime.parse(json['delivery_date']),
        deliverySlot: json['delivery_slot'],
        currency: json['_currency'] == null
            ? null
            : Currency.fromJson(json['_currency']),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        orderItems: json['order_items'] == null
            ? []
            : List<OrderItem>.from(
                json['order_items']!.map((x) => OrderItem.fromJson(x))),
        status: json['status'],
        orderItemsAmount:
            json['order_items_amount'].toString().parsedString.toDouble(),
        producer: json['producer'] == null
            ? null
            : Producer.fromJson(json['producer']),
        destAddress: json['dest_address'] == null
            ? null
            : Address.fromJson(json['dest_address']),
      );
  ManagerOrderDetail({
    required this.id,
    required this.customer,
    required this.deliveryType,
    required this.deliveryDate,
    required this.deliverySlot,
    required this.currency,
    required this.createdAt,
    required this.orderItems,
    required this.status,
    required this.orderItemsAmount,
    required this.producer,
    required this.destAddress,
  });

  final String? id;
  final Customer? customer;
  final String? deliveryType;
  final DateTime? deliveryDate;
  final String? deliverySlot;
  final Currency? currency;
  final DateTime? createdAt;
  final List<OrderItem>? orderItems;
  final String? status;
  final double? orderItemsAmount;
  final Producer? producer;
  final Address? destAddress;
  ManagerOrderDetail copyWith({List<OrderItem>? orders}) {
    return ManagerOrderDetail(
      id: id,
      customer: customer,
      deliveryType: deliveryType,
      deliveryDate: deliveryDate,
      deliverySlot: deliverySlot,
      currency: currency,
      createdAt: createdAt,
      orderItems: orders ?? orderItems,
      status: status,
      orderItemsAmount: orderItemsAmount,
      producer: producer,
      destAddress: destAddress,
    );
  }
}

class Customer {
  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
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
        cart: json['cart'] == null
            ? []
            : List<dynamic>.from(json['cart']!.map((x) => x)),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        imageUrl: json['image_url'],
        customerId: json['id'],
      );
  Customer({
    this.id,
    this.fbId,
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
    this.cart,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.customerId,
  });

  final String? id;
  final String? fbId;
  final String? email;
  final String? phone;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? version;
  final String? signupType;
  final String? deviceId;
  final String? fcmId;
  final String? device;
  final String? latitude;
  final String? longitude;
  final String? userType;
  final bool? status;
  final List<dynamic>? cart;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? imageUrl;
  final String? customerId;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'fb_id': fbId,
        'email': email,
        'phone': phone,
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'version': version,
        'signup_type': signupType,
        'device_id': deviceId,
        'fcm_id': fcmId,
        'device': device,
        'latitude': latitude,
        'longitude': longitude,
        'user_type': userType,
        'status': status,
        'cart': cart == null ? [] : List<dynamic>.from(cart!.map((x) => x)),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'image_url': imageUrl,
        'id': customerId,
      };
}

class OrderItem {
  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json['_id'],
        cancelReason: json['reject_reason'],
        order: json['_order'],
        producer: json['_producer'],
        product: json['_product'] == null
            ? null
            : Product.fromJson(json['_product']),
        productName: json['product_name'],
        productImage: json['product_image'],
        price: json['price'].toString().parsedString.toDouble(),
        qty: json['qty'],
        status: json['status'],
        srcAddress: null,
        // srcAddress: json['src_address'] == null
        //     ? null
        //     : Address.fromJson(json['src_address']),
        history: json['history'] == null
            ? []
            : List<History>.from(
                json['history']!.map((x) => History.fromJson(x))),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        productImageUrl: json['product_image_url'],
        orderItemTotal:
            json['order_item_total'].toString().parsedString.toDouble(),
        orderItemId: json['id'],
      );
  OrderItem({
    this.id,
    this.cancelReason,
    this.order,
    this.producer,
    this.product,
    this.productName,
    this.productImage,
    this.price,
    this.qty,
    this.status,
    this.srcAddress,
    this.history,
    this.createdAt,
    this.updatedAt,
    this.productImageUrl,
    this.orderItemTotal,
    this.orderItemId,
    this.isChecked = false,
  });

  final String? id;
  final String? cancelReason;
  final String? order;
  final String? producer;
  final Product? product;
  final String? productName;
  final String? productImage;
  final double? price;
  final int? qty;
  final String? status;
  final Address? srcAddress;
  final List<History>? history;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? productImageUrl;
  final double? orderItemTotal;
  final String? orderItemId;
  bool isChecked;

  OrderItem copyWith({
    bool? isChecked,
  }) {
    return OrderItem(
      id: id,
      order: order,
      producer: producer,
      product: product,
      productName: productName,
      productImage: productImage,
      price: price,
      qty: qty,
      status: status,
      srcAddress: srcAddress,
      history: history,
      createdAt: createdAt,
      updatedAt: updatedAt,
      productImageUrl: productImageUrl,
      orderItemTotal: orderItemTotal,
      orderItemId: orderItemId,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}



// import 'package:orderly_ecom/src/features/manager/features/orders/domain/manager_order.dart';

// class ManagerOrderDetail {
//   factory ManagerOrderDetail.fromJson(Map<String, dynamic> json) =>
//       ManagerOrderDetail(
//         orders: List<ManagerOrderItem>.from(
//             json['orders'].map((x) => ManagerOrderItem.fromJson(x))),
//         userData: List<OrderUser>.from(
//             json['user_data'].map((x) => OrderUser.fromJson(x))),
//         parentOrder: ManagerOrder.fromJson(json['parent_order']),
//       );
//   ManagerOrderDetail({
//     required this.orders,
//     required this.userData,
//     required this.parentOrder,
//   });

//   List<ManagerOrderItem> orders;
//   List<OrderUser> userData;
//   ManagerOrder parentOrder;

//   ManagerOrderDetail copyWith({List<ManagerOrderItem>? orders}) {
//     return ManagerOrderDetail(
//       orders: orders ?? this.orders,
//       userData: userData,
//       parentOrder: parentOrder,
//     );
//   }
// }

// class ManagerOrderItem {
//   factory ManagerOrderItem.fromJson(Map<String, dynamic> json) =>
//       ManagerOrderItem(
//         orderDetailsId: json['order_details_id'],
//         orderId: json['order_id'],
//         orderNumber: json['order_number'],
//         producerId: json['producer_id'],
//         productId: json['product_id'],
//         qty: json['qty'],
//         productName: json['product_name'],
//         ratePerHour: json['rate_per_hour'],
//         productDesc: json['product_desc'],
//         imgPaths: json['img_paths'],
//         currentStatus: json['current_status'],
//         orderDate: DateTime.parse(json['order_date']),
//         rejectReason: json['reject_reason'],
//         producerName: json['producer_name'],
//         returnTitle: json['return_title'],
//         review: json['review'],
//         totalAmount: json['total_amount'],
//         currency: json['currency'],
//         currencyType: json['currency_type'],
//         producerImageUrl: json['producer_image_url'],
//         producerIconUrl: json['producer_icon_url'],
//         fullDestAddress: json['full_dest_address'],
//       );
//   ManagerOrderItem({
//     this.orderDetailsId,
//     this.orderId,
//     this.orderNumber,
//     this.producerId,
//     this.productId,
//     this.qty,
//     this.productName,
//     this.ratePerHour,
//     this.productDesc,
//     this.imgPaths,
//     this.currentStatus,
//     this.orderDate,
//     this.rejectReason,
//     this.producerName,
//     this.returnTitle,
//     this.review,
//     this.totalAmount,
//     this.currency,
//     this.currencyType,
//     this.producerImageUrl,
//     this.producerIconUrl,
//     this.fullDestAddress,
//     this.isChecked = false,
//   });

//   ManagerOrderItem copyWith({
//     bool? isChecked,
//   }) {
//     return ManagerOrderItem(
//       isChecked: isChecked ?? this.isChecked,
//       orderDetailsId: orderDetailsId,
//       orderId: orderId,
//       orderNumber: orderNumber,
//       producerId: producerId,
//       productId: productId,
//       qty: qty,
//       productName: productName,
//       ratePerHour: ratePerHour,
//       productDesc: productDesc,
//       imgPaths: imgPaths,
//       currentStatus: currentStatus,
//       orderDate: orderDate,
//       rejectReason: rejectReason,
//       producerName: producerName,
//       returnTitle: returnTitle,
//       review: review,
//       totalAmount: totalAmount,
//       currency: currency,
//       currencyType: currencyType,
//       producerImageUrl: producerImageUrl,
//       producerIconUrl: producerIconUrl,
//       fullDestAddress: fullDestAddress,
//     );
//   }

//   int? orderDetailsId;
//   int? orderId;
//   String? orderNumber;
//   int? producerId;
//   int? productId;
//   int? qty;
//   String? productName;
//   int? ratePerHour;
//   String? productDesc;
//   String? imgPaths;
//   int? currentStatus;
//   DateTime? orderDate;
//   dynamic rejectReason;
//   String? producerName;
//   dynamic returnTitle;
//   dynamic review;
//   int? totalAmount;
//   String? currency;
//   String? currencyType;
//   String? producerImageUrl;
//   String? producerIconUrl;
//   String? fullDestAddress;
//   bool isChecked;
// }

// class OrderUser {
//   factory OrderUser.fromJson(Map<String, dynamic> json) => OrderUser(
//         uaId: json['ua_id'],
//         userid: json['userid'],
//         userName: json['user_name'],
//         mobile: json['mobile'],
//         emailId: json['email_id'],
//         streetNo: json['street_no'],
//         flatNo: json['flat_no'],
//         address: json['address'],
//         zipcode: json['zipcode'],
//         city: json['city'],
//         state: json['state'],
//         country: json['country'],
//         addLatitude: json['add_latitude'],
//         addLongitude: json['add_longitude'],
//         addressType: json['address_type'],
//         isDefault: json['is_default'],
//         createdOn: DateTime.parse(json['created_on']),
//       );
//   OrderUser({
//     required this.uaId,
//     required this.userid,
//     required this.userName,
//     required this.mobile,
//     required this.emailId,
//     required this.streetNo,
//     required this.flatNo,
//     required this.address,
//     required this.zipcode,
//     required this.city,
//     required this.state,
//     required this.country,
//     required this.addLatitude,
//     required this.addLongitude,
//     required this.addressType,
//     required this.isDefault,
//     required this.createdOn,
//   });

//   int uaId;
//   String userid;
//   String userName;
//   String mobile;
//   String emailId;
//   String streetNo;
//   String flatNo;
//   String address;
//   String zipcode;
//   String city;
//   String state;
//   String country;
//   String addLatitude;
//   String addLongitude;
//   String addressType;
//   int isDefault;
//   DateTime createdOn;
// }
