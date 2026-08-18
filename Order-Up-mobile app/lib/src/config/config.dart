import 'dart:io';

import 'package:flutter/foundation.dart';

abstract class Config {
  const Config._();

  /// `NOT GLOBAL`sadd
  /// WILL ONLY BE USED IN `UI`
  ///
  static const String _androidVersion = '0.0.1';
  static const String _iosVersion = '0.0.5';
  static const String _webVersion = '0.0.1';

  static String appVersion = !kIsWeb
      ? Platform.isIOS
          ? _iosVersion
          : _androidVersion
      : _webVersion;

  static const bool isDebug = kDebugMode;
  static const bool isAppLive = false;

  static const int receiveTimeout = 60000;
  static const int connectionTimeout = 60000;

  static const String baseUrl = 'https://api.dev.order-up.in/';
  static const String prodBaseUrl = 'https://api.order-up.in/';
  // static const String baseUrl =
  //     'https://w2z2p284cl.execute-api.us-east-1.amazonaws.com/prod';
  // static const String baseUrl = 'https://api.order-up.in';
  // static const String baseUrl = '	https://api.dev.order-up.in:3003';
  // static const String serverLessUrl =
  //     'https://5obvj0bxzk.execute-api.ap-south-1.amazonaws.com/dev';
  // static const String prodUrl = 'http://ecomm.orderlyinc.com:3002';

  static const String zipCodeApiKey =
      '1081-6628f4e8-d6eb2c39-f12e308d-948aac6589accf4ede3';
}

abstract class HiveTypes {
  const HiveTypes._();
  // PART OF User Model
  static const int authUser = 0;
  static const int userAddress = 1;
}
