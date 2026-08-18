import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

abstract class StaticText {
  StaticText._();
  static String appName = 'Order-Up'.hardcoded;
  static const String rupeeSymbol = '₹';
  static const String dateFormat = 'EEEE, d MMM, yyyy';

  static List<Locale> supportLanguage = [
    const Locale('en'),
    const Locale('es'),
  ];
}
