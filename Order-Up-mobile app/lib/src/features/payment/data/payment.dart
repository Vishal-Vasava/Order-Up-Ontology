// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'package:orderly_ecom/src/utils/exceptions.dart';
import 'package:razorpay_web/razorpay_web.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment {
  static late Razorpay razorpay;

  void initState() {
    razorpay = Razorpay();
  }

  static const String _paymentKey = 'rzp_live_TXhZMyuTJ2hlFe';
  // static const String _paymentKey = 'rzp_test_iKbm4VGG4ePrL6';

  static Future<void> openCheckout({
    required double cartTotal,
    required String userMobileNumber,
    required String userEmailId,
  }) async {
    try {
      final int amount = (cartTotal * 100).round();
      final options = {
        'key': _paymentKey,
        'amount': '$amount',
        'image': '',
        'name': 'Order-Up',
        'description': 'Thank You For Shopping With Us',
        'prefill': {
          'contact': userMobileNumber,
          'email': userEmailId,
        },
        'method': {
          'netbanking': true,
          'card': true,
          'wallet': true,
          'upi': true,
          'emi': false
        },
        'external': {
          'wallets': ['paytm']
        },
        'theme': {'color': '#22BB9B'}
      };
      // if (kIsWeb) {
      //   final data = await _checkout(options);
      //   if (data['razorpayStatus'] == 'SUCCESS') {
      //     // TODO: MAKE API CALL AND VERIFY PAYMET
      //     bool verified = 0 != 0;
      //     if (verified) {
      //       // onSuccess();
      //       return;
      //     }
      //   }
      //   // onFailed();
      // }

      razorpay.open(options);
    } catch (e) {
      throw const AppException(message: 'Razorpay Payment Failed');
    }
  }

  // static Timer? _timer;
  // static const _timerDuration = Duration(seconds: 1);

  /// starts checkout
  // static Future<Map<String, String>> _checkout(
  //     Map<String, dynamic> options) async {
  //   Completer<Map<String, String>> completer = Completer<Map<String, String>>();
  //   // calls js function defined in Step 3
  //   js.context.callMethod('checkout', [jsonEncode(options)]);
  //   _timer = Timer.periodic(_timerDuration, (timer) {
  //     if (html.window.sessionStorage.containsKey('razorpayStatus')) {
  //       Map<String, String> data = Map.fromEntries(
  //         html.window.sessionStorage.entries,
  //       );
  //       html.window.sessionStorage.clear();
  //       completer.complete(data);
  //       _timer!.cancel();
  //       _timer = null;
  //     }
  //   });
  //   return completer.future;
  // }

  /// verify order signature
  // Future<bool> _verifyOrder(
  //   String orderId,
  //   String razorpayOrderId,
  //   String paymentId,
  //   String signature,
  // ) async {
  //   return _apiService.verifyOrder({
  //     'orderId': _orderId,
  //     'razorpayOrderId': razorpayOrderId,
  //     'paymentId': paymentId,
  //     'signature': signature,
  //   });
  // }
}
