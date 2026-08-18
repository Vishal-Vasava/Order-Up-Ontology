part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitialState extends CartState {}

/// VIEW CART LIST STATE

class CartLoadingState extends CartState {
  const CartLoadingState({this.productId = ''});

  final String productId;
}

class CartLoadedState extends CartState {
  const CartLoadedState({
    required this.cartList,
    this.deliveryTime = '',
    this.deliveryDate = '',
    this.deliverySlot = '',
  });

  final List<CartElement> cartList;

  final String deliveryTime;
  final String deliveryDate;
  final String deliverySlot;
}

class CartFailedState extends CartState {
  const CartFailedState({required this.message});

  final String message;
}

class CartDeliverySlotState extends CartState {}

/// ADD TO CART STATE
class CartAddSuccessState extends CartState {}

class CartAddFailedState extends CartState {
  const CartAddFailedState({required this.message});

  final String message;
}

/// DELETE TO CART STATE
class CartDeleteSuccessState extends CartState {}

class CartDeleteFailedState extends CartState {
  const CartDeleteFailedState({required this.message});

  final String message;
}

/// UPDATE TO CART STATE
class CartUpdateLoadingState extends CartState {}

class CartUpdateSuccessState extends CartState {}

class CartUpdateFailedState extends CartState {
  const CartUpdateFailedState({required this.message});

  final String message;
}

/// PLACE ORDER STATE
class CartPlaceOrderLoadingState extends CartState {}

class CartPlaceOrderSuccessState extends CartState {}

class CartPlaceOrderFailedState extends CartState {
  const CartPlaceOrderFailedState({required this.message});

  final String message;
}
