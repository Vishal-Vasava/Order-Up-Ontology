import 'package:orderly_ecom/src/features/delivery/domain/delivery.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/filters.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/inventory.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/domain/manager_order.dart';
import 'package:orderly_ecom/src/features/product/domain/review.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class Product {
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productList: json['data'] == null
            ? []
            : List<ProductData>.from(
                json['data']!.map((x) => ProductData.fromJson(x))),
        nextCursor: json.containsKey('next_cursor') ? json['next_cursor'] : '',
      );
  Product({
    this.productList,
    this.nextCursor,
  });

  final List<ProductData>? productList;
  final String? nextCursor;
}

class ProductData {
  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        id: json['id'],
        name: json['name'],
        desc: json['desc'],
        image: json['image'],
        price: json['price'].toString().parsedString.toDouble(),
        qty: json['qty'],
        visible: json['visible'],
        deleted: json['deleted'],
        currency: json['_currency'] == null
            ? null
            : Currency.fromJson(json['_currency']),
        producer: null,
        // producer: json['_producer'] == null
        //     ? null
        //     : Producer.fromJson(json['_producer']),
        creator: json['_creator'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        imageUrl: json['image_url'],
        unit: json['unit'],
        productId: json['id'],
        offerPrice: json['offer_price']?.toDouble(),
        averageRatings:
            json.containsKey('average_rating') ? json['average_rating'] : 0,
        totalRatings:
            json.containsKey('total_rating') ? json['total_rating'] : 0,
        reviews: json.containsKey('reviews')
            ? (json['reviews'] as List)
                .map(
                  (e) => Review.fromJson(e),
                )
                .toList()
            : null,
        // estimatedPickup: json['_estimatedPickup'],
        estimatedPickup: json['_estimatedPickup'] == null
            ? null
            : EstimatedPickup.fromJson(json['_estimatedPickup']),
        returnPolicy: json['_returnPolicy'] == null
            ? null
            : ReturnPolicy.fromJson(json['_returnPolicy']),
        filters: json['_filters'] == null
            ? []
            : List<Filters>.from(
                json['_filters'].map((x) => Filters.fromJson(x))),
      );
  ProductData({
    this.id,
    this.name,
    this.desc,
    this.image,
    this.price,
    this.qty,
    this.visible,
    this.deleted,
    this.currency,
    this.producer,
    this.creator,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.unit,
    this.productId,
    this.offerPrice,
    this.averageRatings,
    this.totalRatings,
    this.reviews,
    this.estimatedPickup,
    this.returnPolicy,
    this.filters,
  });

  final String? id;
  final String? name;
  final String? desc;
  final String? image;
  final double? price;
  final int? qty;
  final bool? visible;
  final bool? deleted;
  final Currency? currency;
  final Producer? producer;
  final String? creator;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? imageUrl;
  final String? unit;
  final String? productId;
  final double? offerPrice;
  final int? averageRatings;
  final int? totalRatings;
  final List<Review>? reviews;
  // String? estimatedPickup;
  EstimatedPickup? estimatedPickup;
  ReturnPolicy? returnPolicy;
  final List<Filters>? filters;
}

class ReturnPolicy {
  ReturnPolicy({
    this.id,
    this.title,
    this.code,
    this.returnPolicyId,
  });

  factory ReturnPolicy.fromJson(Map<String, dynamic> json) => ReturnPolicy(
        id: json['_id'],
        title: json['title'],
        code: json['code'],
        returnPolicyId: json['id'],
      );
  String? id;
  String? title;
  String? code;
  String? returnPolicyId;
}
