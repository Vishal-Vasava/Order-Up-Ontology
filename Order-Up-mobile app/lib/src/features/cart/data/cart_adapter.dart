import 'package:orderly_ecom/src/features/cart/domain/cart.dart';
import 'package:orderly_ecom/src/features/cart/domain/cart_place_order.dart';

abstract class CartAdapter {
  Future<Cart?> getCartList({
    required String latitude,
    required String longitude,
  });

  Future<bool> addToCart({
    required String productId,
    required int quantity,
  });

  Future<bool> updateCart({
    required String productId,
    required String quantity,
  });

  Future<bool> deleteCart({
    required String productId,
  });

  Future<bool> placeOrder({
    required CartPlaceOrder placeOrder,
  });

  Future<bool> checkAddressOnOrder({
    required String addressId,
  });

  void calculateTotal() {}

  double get cartTotal {
    return 0.0;
  }

  double get subTotal {
    return 0.0;
  }

  int get cartLength {
    return 0;
  }

  String get currency {
    return '';
  }

  int get conveyanceFee {
    return 0;
  }

  int get chargeAmount {
    return 0;
  }
}
