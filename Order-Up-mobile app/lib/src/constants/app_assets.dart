import 'package:flutter/foundation.dart';

abstract class AppAssets {
  const AppAssets._();

  static const String _assetPath = kIsWeb ? 'images' : 'assets/images';

  static String appLogo = '$_assetPath/app_logo.png';
  static String razorpayLogo = '$_assetPath/razorpay_logo.png';
  static String stripeLogo = '$_assetPath/stripe_logo.png';
  static String locationImage = '$_assetPath/user_location.png';
  static String backgroundImage = '$_assetPath/background_image.png';
  static String successPaymentImage = '$_assetPath/success_payment.png';

  static String customerIcon = '$_assetPath/customer_ic.png';
  static String customerOrangeIcon = '$_assetPath/customer_orange_ic.png';
  static String managerOrangeIcon = '$_assetPath/manager_orange_ic.png';
  static String deliveryOrangeIcon = '$_assetPath/delivery_orange_ic.png';

  static String notiIcon = '';
  static String warningImage = '$_assetPath/warning_image.png';
  static String emptyStateImage = '$_assetPath/empty_state.png';
  static const String search = '$_assetPath/search.png';

  static const String paymentSuccess = 'assets/animation/payment_success.json';
}
