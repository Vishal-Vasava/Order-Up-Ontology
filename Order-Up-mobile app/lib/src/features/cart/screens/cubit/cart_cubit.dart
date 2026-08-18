import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/cart/data/cart_adapter.dart';
import 'package:orderly_ecom/src/features/cart/domain/cart_place_order.dart';
import 'package:orderly_ecom/src/features/cart/domain/cart.dart';
import 'package:orderly_ecom/src/features/location/data/location_local_repository.dart';
import 'package:orderly_ecom/src/services/crashlytics/crash_service.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> implements CartAdapter {
  CartCubit({required this.cartAdapter}) : super(CartInitialState());

  final CartAdapter cartAdapter;

  @override
  int get cartLength => cartList.length;

  @override
  String get currency {
    if (cartList.isEmpty) {
      return 'en';
    }
    return 'en';
    // return cartList[0].producer.currency.locale;
    // return cartList[0].currency ?? 'en';
  }

  double _subTotal = 0.0;
  @override
  double get subTotal => _subTotal;

  int _chargeAmount = 0;
  @override
  int get chargeAmount => _chargeAmount;

  int _convFee = 0;
  @override
  int get conveyanceFee => _convFee;

  double _cartTotal = 0.0;
  @override
  double get cartTotal => _cartTotal;

  @override
  void calculateTotal() {
    _cartTotal = 0.0;
    _subTotal = 0.0;
    // for (final cart in cartList) {
    //   if (cart.product.offerPrice != null) {
    //     _cartTotal += (cart.product.offerPrice! * cart.qty).toDouble();
    //     _subTotal += (cart.product.offerPrice! * cart.qty).toDouble();
    //   } else {
    //     _cartTotal += (cart.product.price! * cart.qty).toDouble();
    //     _subTotal += (cart.product.price! * cart.qty).toDouble();
    //   }
    // }
    if (_cartTotal != 0.0) {
      _cartTotal += _convFee;
    }
    if (deliverySlot == 'morning') {
      _cartTotal += _chargeAmount;
    }
  }

  List<CartElement> cartList = [];

  @override
  Future<Cart?> getCartList({
    required String latitude,
    required String longitude,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        emit(const CartLoadingState());
      }
      final cart = await cartAdapter.getCartList(
        latitude: latitude,
        longitude: longitude,
      );
      if (cart != null) {
        if (cart.cart.isEmpty) {
          _convFee = 0;
          _chargeAmount = 0;
          deliverySlot = '';
        }
        cartList = cart.cart;
        // _chargeAmount = int.parse(cart.charges
        //     .firstWhere((element) => element.code == 'urgent_del_fees')
        //     .value);
        // _convFee = int.parse(cart.charges
        //     .firstWhere((element) => element.code == 'conv_fees')
        //     .value);

        emit(CartLoadedState(cartList: cart.cart));
      } else {
        _convFee = 0;
        _chargeAmount = 0;
        deliverySlot = '';
      }
    } catch (e) {
      emit(CartFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: 'View Cart API Failed');
    } finally {
      calculateTotal();
    }
    return null;
  }

  void changeDeliveryTime({
    required String deliveryDate,
    required String deliveryTime,
    required String deliverySlot,
  }) {
    emit(CartDeliverySlotState());
    // _convFee = currentState.convFee;
    this.deliverySlot = deliverySlot;
    this.deliveryDate = deliveryDate;
    this.deliveryTime = deliveryDate;
    emit(CartLoadedState(
      cartList: cartList,
      deliveryTime: deliveryTime,
      deliveryDate: deliveryDate,
      deliverySlot: deliverySlot,
    ));
    calculateTotal();
  }

  @override
  Future<bool> addToCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      emit(CartLoadingState(productId: productId));
      final success =
          await cartAdapter.addToCart(productId: productId, quantity: quantity);
      if (!success) {
        emit(const CartAddFailedState(message: 'Please try again'));
      } else {
        emit(CartAddSuccessState());
      }
    } catch (e) {
      emit(CartAddFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: 'Add to cart failed');
    } finally {
      await getCartList(
        latitude: inject.get<LocationLocalRepository>().latitude,
        longitude: inject.get<LocationLocalRepository>().longitude,
        showLoading: false,
      );
    }
    return false;
  }

  @override
  Future<bool> updateCart({
    required String productId,
    required String quantity,
  }) async {
    try {
      emit(CartUpdateLoadingState());
      final success = await cartAdapter.updateCart(
        productId: productId,
        quantity: quantity,
      );
      if (!success) {
        emit(const CartUpdateFailedState(message: 'Please try again'));
      }
    } catch (e) {
      emit(CartUpdateFailedState(message: e.toString()));
    } finally {
      await getCartList(
        latitude: inject.get<LocationLocalRepository>().latitude,
        longitude: inject.get<LocationLocalRepository>().longitude,
        showLoading: false,
      );
    }
    return false;
  }

  @override
  Future<bool> deleteCart({
    required String productId,
  }) async {
    try {
      emit(const CartLoadingState());
      final success = await cartAdapter.deleteCart(productId: productId);
      if (!success) {
        emit(const CartDeleteFailedState(message: 'Couldn\'t delete item'));
      }
    } catch (e) {
      emit(CartDeleteFailedState(message: e.toString()));
    } finally {
      await getCartList(
        latitude: inject.get<LocationLocalRepository>().latitude,
        longitude: inject.get<LocationLocalRepository>().longitude,
        showLoading: false,
      );
    }
    return false;
  }

  String deliverySlot = '';
  String? deliveryDate;
  String? deliveryTime;

  // @override
  // Future getCharges() async {
  //   try {
  //     deliverySlot = '';
  //     deliveryDate = null;
  //     deliveryTime = null;
  //     final result = await cartAdapter.getCharges();
  //     log(result.toString());
  //     if (result['msg'] == 'Success') {
  //       _chargeAmount = result['charges'][0]['amount'];
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  @override
  Future<bool> checkAddressOnOrder({
    required String addressId,
  }) async {
    try {
      if (addressId.isEmpty) {
        return false;
      }
      final data = await cartAdapter.checkAddressOnOrder(addressId: addressId);
      // getCartList(
      //   latitude: inject.get<LocationLocalRepository>().latitude,
      //   longitude: inject.get<LocationLocalRepository>().longitude,
      //   showLoading: false,
      // );
      return data;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  String destinationId = '';
  @override
  Future<bool> placeOrder({
    required CartPlaceOrder placeOrder,
  }) async {
    try {
      emit(CartPlaceOrderLoadingState());
      final success = await cartAdapter.placeOrder(placeOrder: placeOrder);
      if (success) {
        deliverySlot = '';
        deliveryDate = null;
        deliveryTime = null;
        await getCartList(
          latitude: inject.get<LocationLocalRepository>().latitude,
          longitude: inject.get<LocationLocalRepository>().longitude,
          showLoading: false,
        );
        emit(CartPlaceOrderSuccessState());
      } else {
        emit(const CartPlaceOrderFailedState(message: 'Please try again'));
      }
    } catch (e) {
      emit(CartPlaceOrderFailedState(message: e.toString()));
      inject.get<CrashService>().logError(
            exception: e,
            errorMessage: 'Place Order Error',
          );
    }
    return false;
  }
}
