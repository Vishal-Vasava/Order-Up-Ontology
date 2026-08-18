import 'package:orderly_ecom/src/features/manager/features/orders/domain/manager_order.dart';
import 'package:orderly_ecom/src/features/product/domain/product.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class InvoiceModel {
  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json['_id'],
        subTotal: json['sub_total'].toString().parsedString.toDouble(),
        deliveryCharge:
            json['delivery_charge'].toString().parsedString.toDouble(),
        conveyanceCharge:
            json['conveyance_charge'].toString().parsedString.toDouble(),
        discount: json['discount'].toString().parsedString.toDouble(),
        currency: json['_currency'] == null
            ? null
            : Currency.fromJson(json['_currency']),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        incrId: json['incr_id'],
        orderItems: json['order_items'] == null
            ? []
            : List<InvoiceData>.from(
                json['order_items']!.map((x) => InvoiceData.fromJson(x))),
        orderTotal: json['order_total'].toString().parsedString.toDouble(),
        orderNumber: json['order_number'],
        invoiceModelId: json['id'],
        invoiceNumber: json['invoice_number'],
      );
  InvoiceModel({
    this.id,
    this.subTotal,
    this.deliveryCharge,
    this.conveyanceCharge,
    this.discount,
    this.currency,
    this.createdAt,
    this.incrId,
    this.orderItems,
    this.orderTotal,
    this.orderNumber,
    this.invoiceModelId,
    this.invoiceNumber,
  });

  final String? id;
  final double? subTotal;
  final double? deliveryCharge;
  final double? conveyanceCharge;
  final double? discount;
  final Currency? currency;
  final DateTime? createdAt;
  final int? incrId;
  final List<InvoiceData>? orderItems;
  final double? orderTotal;
  final String? orderNumber;
  final String? invoiceModelId;
  final String? invoiceNumber;
}

class InvoiceData {
  factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
        id: json['_id'],
        order: json['_order'],
        product: json['_product'] == null
            ? null
            : Product.fromJson(json['_product']),
        productName: json['product_name'],
        productImage: json['product_image'],
        price: json['price'].toString().parsedString.toDouble(),
        qty: json['qty'],
        status: json['status'],
        productImageUrl: json['product_image_url'],
        orderItemTotal:
            json['order_item_total'].toString().parsedString.toDouble(),
        productDesc: json['product_desc'],
        orderItemId: json['id'],
      );
  InvoiceData({
    this.id,
    this.order,
    this.product,
    this.productName,
    this.productImage,
    this.price,
    this.qty,
    this.status,
    this.productImageUrl,
    this.orderItemTotal,
    this.productDesc,
    this.orderItemId,
  });

  final String? id;
  final String? order;
  final Product? product;
  final String? productName;
  final String? productImage;
  final double? price;
  final int? qty;
  final String? status;
  final String? productImageUrl;
  final double? orderItemTotal;
  final String? productDesc;
  final String? orderItemId;
}
