import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/payment/data/payment_repository.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit({required this.paymentRepository})
      : super(PaymentInitialState());

  final PaymentRepository paymentRepository;

  Future<void> openStripeCheckout({
    required BuildContext context,
    required String successUrl,
    required String cancelUrl,
    required String deliveryType,
    required String deliveryDate,
    required String deliverySlot,
    required String destinationAddressId,
  }) async {
    try {
      emit(PaymentLoadingState());
      final data = await paymentRepository.getStripeCheckout(
        context: context,
        successUrl: successUrl,
        cancelUrl: cancelUrl,
        deliveryType: deliveryType,
        deliveryDate: deliveryDate,
        deliverySlot: deliverySlot,
        destinationAddressId: destinationAddressId,
      );
      if (data.isNotEmpty) {
        if (data == 'Paid succesfully') {
          emit(const PaymentSuccessState(
            message: 'Payment done.',
          ));
        } else {
          emit(PaymentFailedState(
            message: data,
          ));
        }
      } else {
        emit(const PaymentFailedState(
          message: 'Please try again.',
        ));
      }
    } catch (e) {
      emit(PaymentFailedState(message: e.toString()));
    }
  }
}
