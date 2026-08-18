// class SkuGallery {
//   factory SkuGallery.fromJson(Map<String, dynamic> json) => SkuGallery(
//         status: json['status'],
//         skuGallery: List<SkuGalleryItem>.from(
//             json['sku_gallery'].map((x) => SkuGalleryItem.fromJson(x))),
//         msg: json['msg'],
//         totalPages: json['total_pages'],
//       );
//   SkuGallery({
//     this.status,
//     required this.skuGallery,
//     this.msg,
//     this.totalPages,
//   });

//   int? status;
//   List<SkuGalleryItem> skuGallery;
//   String? msg;
//   int? totalPages;
// }

// class SkuGalleryItem {
//   factory SkuGalleryItem.fromJson(Map<String, dynamic> json) => SkuGalleryItem(
//         id: json['id'],
//         image: json['image'],
//         title: json['title'],
//         description: json['description'],
//       );
//   SkuGalleryItem({
//     this.id,
//     this.image,
//     this.title,
//     this.description,
//   });

//   int? id;
//   String? image;
//   String? title;
//   String? description;
// }

// To parse this JSON data, do
//
//     final skuGallery = skuGalleryFromJson(jsonString);

import 'dart:convert';

SkuGallery skuGalleryFromJson(String str) =>
    SkuGallery.fromJson(json.decode(str));

class SkuGallery {
  SkuGallery({
    required this.data,
    required this.statusCode,
  });
  factory SkuGallery.fromJson(Map<String, dynamic> json) => SkuGallery(
        data: Data.fromJson(json['data']),
        statusCode: json['statusCode'],
      );
  Data data;
  int statusCode;
}

class Data {
  Data({
    required this.data,
  });
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: List<SkuGalleryItem>.from(
            json['data'].map((x) => SkuGalleryItem.fromJson(x))),
      );
  List<SkuGalleryItem> data;
}

class SkuGalleryItem {
  SkuGalleryItem({
    this.id,
    this.image,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.datumId,
  });

  factory SkuGalleryItem.fromJson(Map<String, dynamic> json) => SkuGalleryItem(
        id: json['_id'],
        image: json['image'],
        title: json['title'],
        description: json['description'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        imageUrl: json['image_url'],
        datumId: json['id'],
      );
  String? id;
  String? image;
  String? title;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? imageUrl;
  String? datumId;
}
