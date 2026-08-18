part of 'manager_order_cubit.dart';

abstract class ManagerOrderState extends Equatable {
  const ManagerOrderState();

  @override
  List<Object> get props => [];
}

class ManagerOrderInitialState extends ManagerOrderState {}

///--------------- Fetching [Orders] State ---------------///
class ManagerOrderLoadingState extends ManagerOrderState {}

class ManagerOrderLoadedState extends ManagerOrderState {
  const ManagerOrderLoadedState({required this.orderList});

  final List<ManagerOrder> orderList;
}

class ManagerOrderFailedState extends ManagerOrderState {
  const ManagerOrderFailedState({required this.message});

  final String message;
}

///--------------- Fetching [Order Detail] State ---------------///
class ManagerOrderDetailLoadingState extends ManagerOrderState {}

class ManagerOrderDetailLoadedState extends ManagerOrderState {
  const ManagerOrderDetailLoadedState({required this.orderDetail});

  final ManagerOrderDetail? orderDetail;
}

class ManagerOrderDetailFailedState extends ManagerOrderState {
  const ManagerOrderDetailFailedState({required this.message});

  final String message;
}

///--------------- Fetching [Order Update Status] State ---------------///
class ManagerOrderStatusUiLoadingState extends ManagerOrderState {}

class ManagerOrderStatusLoadingState extends ManagerOrderState {}

class ManagerOrderStatusSuccessState extends ManagerOrderState {}

class ManagerOrderStatusFailedState extends ManagerOrderState {
  const ManagerOrderStatusFailedState({required this.message});

  final String message;
}
