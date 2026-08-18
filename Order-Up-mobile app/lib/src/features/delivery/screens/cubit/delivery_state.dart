part of 'delivery_cubit.dart';

abstract class DeliveryState extends Equatable {
  const DeliveryState();

  @override
  List<Object> get props => [];
}

class DeliveryInitialState extends DeliveryState {}

class DeliveryOrderFetchingState extends DeliveryState {}

class DeliveryOrderDeepLinkState extends DeliveryState {}

class DeliveryOrderFetchedState extends DeliveryState {
  const DeliveryOrderFetchedState({
    required this.deliveryList,
    required this.deepLinkData,
  });

  final List<Delivery> deliveryList;
  final Map<String, dynamic> deepLinkData;

  DeliveryOrderFetchedState copyWith({Map<String, dynamic>? deepLinkData}) {
    return DeliveryOrderFetchedState(
      deliveryList: deliveryList,
      deepLinkData: deepLinkData ?? this.deepLinkData,
    );
  }
}

class DeliveryOrderFetchFailedState extends DeliveryState {
  const DeliveryOrderFetchFailedState({required this.message});

  final String message;
  @override
  List<Object> get props => [message];
}

class DeliveryDetailFetchingState extends DeliveryState {}

class DeliveryDetailUpdateCheckboxState extends DeliveryState {}

class DeliveryDetailFetchedState extends DeliveryState {
  const DeliveryDetailFetchedState({required this.deliveryOrderDetail});

  final DeliveryOrderDetail deliveryOrderDetail;
  DeliveryDetailFetchedState copyWith(
      {DeliveryOrderDetail? deliveryOrderDetail}) {
    return DeliveryDetailFetchedState(
      deliveryOrderDetail: deliveryOrderDetail ?? this.deliveryOrderDetail,
    );
  }
}

class DeliveryDetailFailedState extends DeliveryState {
  const DeliveryDetailFailedState({required this.message});

  final String message;
  @override
  List<Object> get props => [message];
}

class DeliveryUpdateLoadingState extends DeliveryState {}

class DeliveryUpdateSuccessState extends DeliveryState {}

class DeliveryUpdateFailedState extends DeliveryState {
  const DeliveryUpdateFailedState({required this.message});

  final String message;
}
