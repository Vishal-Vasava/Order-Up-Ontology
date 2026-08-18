import 'package:image_picker/image_picker.dart';

class InventoryModel {
  InventoryModel({
    required this.productId,
    required this.productName,
    required this.productDesc,
    required this.rate,
    required this.productQty,
    required this.filters,
    this.image,
    this.imageId,
    this.returnPolicy,
    this.estimatedPickup,
  });

  final String? productId;
  final String productName;
  final String productDesc;
  final String rate;
  final String productQty;
  final List<String> filters;
  final XFile? image;
  final String? imageId;
  final String? returnPolicy;
  final String? estimatedPickup;
}
