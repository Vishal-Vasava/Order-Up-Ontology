class CartPlaceOrder {
  CartPlaceOrder({
    required this.deliveryType,
    required this.deliveryDate,
    required this.deliverySlot,
    required this.destAddressId,
    required this.discount,
    required this.paymentTransactionId,
    required this.paymentMode,
  });

  final String deliveryType;
  final String deliveryDate;
  final String deliverySlot;
  final String destAddressId;
  final String discount;
  final String paymentTransactionId;
  final String paymentMode;

  Map<String, dynamic> toJson() => {
        'delivery_type': deliveryType,
        'delivery_date': deliveryDate,
        'delivery_slot': deliverySlot,
        'address_id': destAddressId,
        'discount': discount,
        'transaction_id': paymentTransactionId,
        'payment_mode': paymentMode,
      };
}
