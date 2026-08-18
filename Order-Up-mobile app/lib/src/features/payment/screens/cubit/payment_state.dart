part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitialState extends PaymentState {}

class PaymentLoadingState extends PaymentState {}

class PaymentSuccessState extends PaymentState {
  const PaymentSuccessState({required this.message});

  final String message;
}

class PaymentFailedState extends PaymentState {
  const PaymentFailedState({required this.message});

  final String message;
}
