part of 'customer_list_cubit.dart';

abstract class CustomerListState extends Equatable {
  const CustomerListState();

  @override
  List<Object> get props => [];
}

class CustomerListInitialState extends CustomerListState {}

class CustomerListLoadingState extends CustomerListState {}

class CustomerListLoadedState extends CustomerListState {
  const CustomerListLoadedState({required this.customerList});

  final List<CustomerList> customerList;
}

class CustomerListFailedState extends CustomerListState {
  const CustomerListFailedState({required this.message});

  final String message;
}
