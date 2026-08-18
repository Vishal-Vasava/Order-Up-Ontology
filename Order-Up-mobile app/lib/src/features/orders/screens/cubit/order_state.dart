part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitialState extends OrderState {}

class OrderLoadingState extends OrderState {}

class OrderLoadedState extends OrderState {
  const OrderLoadedState({
    required this.orderList,
    required this.searchOrderList,
  });

  final List<Order> orderList;
  final List<Order> searchOrderList;

  OrderLoadedState copyWith({List<Order>? searchList}) {
    return OrderLoadedState(
      orderList: orderList,
      searchOrderList: searchList ?? searchOrderList,
    );
  }
}

class OrderFailedState extends OrderState {
  const OrderFailedState({required this.message});

  final String message;
}

class OrderSearchState extends OrderState {}

/// [TRACK ORDER] STATE
class OrderTrackLoadingState extends OrderState {}

class OrderTrackLoadedState extends OrderState {
  const OrderTrackLoadedState({
    required this.trackOrder,
    required this.cancelReason,
  });

  final TrackOrder trackOrder;
  final String cancelReason;
}

class OrderTrackFailedState extends OrderState {
  const OrderTrackFailedState({required this.message});

  final String message;
}

/// [ADD REVIEW] State
class OrderAddReviewLoadingState extends OrderState {}

class OrderAddReviewSuccessState extends OrderState {}

class OrderAddReviewFailedState extends OrderState {
  const OrderAddReviewFailedState({required this.message});

  final String message;
}

class OrderPaymenUrlLoadingState extends OrderState {}

class OrderPaymenUrlLoadedState extends OrderState {
  const OrderPaymenUrlLoadedState(this.url);

  final String url;
}

class OrderPaymenUrlFailedState extends OrderState {
  const OrderPaymenUrlFailedState(this.message);
  final String message;
}

class OrderReturnReasonLoadingState extends OrderState {}

class OrderReturnReasonLoadedState extends OrderState {
  const OrderReturnReasonLoadedState({required this.productReasonList});

  final ProductReturnReason productReasonList;
}

class OrderReturnReasonFailedState extends OrderState {
  const OrderReturnReasonFailedState({required this.message});

  final String message;
}

class OrderReturnReplaceLoadingState extends OrderState {}

class OrderReturnReplaceLoadedState extends OrderState {
  const OrderReturnReplaceLoadedState({required this.status});

  final bool status;
}

class OrderReturnReplaceFailedState extends OrderState {
  const OrderReturnReplaceFailedState({required this.message});

  final String message;
}
