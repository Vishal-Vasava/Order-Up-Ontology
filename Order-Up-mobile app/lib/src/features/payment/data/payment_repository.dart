import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/constants/app_keys.dart';
import 'package:orderly_ecom/src/features/payment/data/stripe_checkout_web.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:stripe_checkout/stripe_checkout.dart';

class PaymentRepository {
  PaymentRepository({
    required this.networkAdapter,
  });

  final NetworkAdapter networkAdapter;

  Future<String> getStripeCheckout({
    required BuildContext context,
    required String successUrl,
    required String cancelUrl,
    required String deliveryType,
    required String deliveryDate,
    required String deliverySlot,
    required String destinationAddressId,
  }) async {
    try {
      final String sessionId = await createCheckoutSession(
        deliveryType: deliveryType,
        deliveryDate: deliveryDate,
        deliverySlot: deliverySlot,
        destinationAddressId: destinationAddressId,
      );
      if (context.mounted) {
        final result = await redirectToCheckout(
          context: context,
          sessionId: sessionId,
          publishableKey: AppKey.stripeKey,
          successUrl: successUrl,
          canceledUrl: cancelUrl,
        );
        if (context.mounted) {
          final text = result.when(
            success: () => 'Paid succesfully',
            canceled: () => 'Checkout canceled',
            error: (e) => 'Error $e',
            redirected: () => 'Redirected succesfully',
          );
          return text;
        }
      } else {
        return '';
      }
      return '';
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<String> createCheckoutSession({
    required String deliveryType,
    required String deliveryDate,
    required String deliverySlot,
    required String destinationAddressId,
  }) async {
    try {
      const url = '/create-checkout-session';
      final data = {
        'delivery_type': deliveryType,
        'delivery_date': deliveryDate,
        'delivery_slot': deliverySlot,
        'address_id': destinationAddressId,
        if (kIsWeb) 'port': getUrlPort(),
      };

      final response = await networkAdapter.post(
        url,
        data: jsonEncode(data),
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        final id = response.data['id'] as String;
        log('Checkout session id $id');
        return id;
      }
      return '';
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }
}
