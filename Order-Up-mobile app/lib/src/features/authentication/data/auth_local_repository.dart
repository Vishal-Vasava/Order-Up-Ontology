import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:orderly_ecom/src/config/config.dart';
import 'package:orderly_ecom/src/features/address/domain/address.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_user.dart';

class AuthLocalRepository {
  /// STORE ONLY THOSE DATA WHICH WILL ONLY BE REMOVED
  /// WHEN USER DELETE APP
  static const _authBox = 'authBox';
  static const _userBox = 'userBox';

  static const _userIdKey = 'userId';
  static const _userFcmToken = 'userFcmToken';
  static const _userDeviceId = 'userDeviceId';
  static const _nameKey = 'name';
  static const _apiToken = 'apiToken';
  static const _guestAccessToken = 'guestAccessToken';
  static const _guestRefreshAccessToken = 'guestRefreshToken';
  static const _apiRefreshToken = 'apiRefreshToken';
  static const _latitude = 'latitude';
  static const _longitude = 'longitude';
  static const _profilePicture = 'profilePicture';

  static const _userAddress = 'userAddress';
  static const _userAddressId = 'userAddressId';

  static const _stripeSecretKey = 'stripeSecretKey';
  static const _publishableKey = 'publishable_key';
  static const _stripeMerchantId = 'stripeMerchantId';
  static const _razoryPayKey = 'razoryPayKey';
  static const _apiUrl = 'apiUrl';

  late Box<dynamic> authBox;
  late Box<AuthUser> userBox;

  Future<void> init() async {
    try {
      authBox = await Hive.openBox(_authBox);

      if (!Hive.isAdapterRegistered(HiveTypes.userAddress)) {
        Hive.registerAdapter(AddressAdapter());
      }
      if (!Hive.isAdapterRegistered(HiveTypes.authUser)) {
        Hive.registerAdapter(AuthUserAdapter());
      }
      userBox = await Hive.openBox<AuthUser>(_userBox);
    } catch (e) {
      log(e.toString(), name: 'Auth Init Error');
    }
  }

  String get token {
    if (guestAccessToken.isEmpty) {
      return accessToken;
    } else {
      return guestAccessToken;
    }
  }

  String get refreshTokenApi {
    if (guestRefreshAccessToken.isEmpty) {
      return refreshToken;
    } else {
      return guestRefreshAccessToken;
    }
  }

  String get accessToken => authBox.get(_apiToken) ?? '';
  Future<String> setAccessToken(String apiToken) async {
    await authBox.put(_apiToken, apiToken);
    return apiToken;
  }

  String get guestAccessToken => authBox.get(_guestAccessToken) ?? '';
  Future<String> setGuestAccessToken(String guestAccessToken) async {
    await authBox.put(_guestAccessToken, guestAccessToken);
    return _guestAccessToken;
  }

  String get guestRefreshAccessToken =>
      authBox.get(_guestRefreshAccessToken) ?? '';
  Future<String> setGuestRefreshAccessToken(
      String guestRefreshAccessToken) async {
    await authBox.put(_guestRefreshAccessToken, guestRefreshAccessToken);
    return _guestRefreshAccessToken;
  }

  String get refreshToken => authBox.get(_apiRefreshToken) ?? '';
  Future<String> setRefreshToken(String apiRefreshToken) async {
    await authBox.put(_apiRefreshToken, apiRefreshToken);
    return apiRefreshToken;
  }

  String get userFcmToken => authBox.get(_userFcmToken) ?? '';
  Future<String> setUserFcmToken(String userFcmToken) async {
    await authBox.put(_userFcmToken, userFcmToken);
    return userFcmToken;
  }

  String get userDeviceId => authBox.get(_userDeviceId) ?? '';
  Future<String> setuserDeviceId(String userDeviceId) async {
    await authBox.put(_userDeviceId, userDeviceId);
    return userDeviceId;
  }

  AuthUser get authUser => userBox.values.elementAt(0);
  Future<void> setUserModel({required AuthUser user}) async {
    await userBox.put(_userBox, user);
    await setProfilePicture(user.imageUrl ?? '');
  }

  String get userId => authBox.get(_userIdKey) ?? '';
  Future<String> setUserId(String userId) async {
    await authBox.put(_userIdKey, userId);
    return userId;
  }

  String get name => authBox.get(_nameKey) ?? '';
  Future<String> setName(String name) async {
    await authBox.put(_nameKey, name);
    return name;
  }

  String get latitude => authBox.get(_latitude) ?? '';
  Future<String> setLatitude(String latitude) async {
    await authBox.put(_latitude, latitude);
    return latitude;
  }

  String get longitude => authBox.get(_longitude) ?? '';
  Future<String> setLongitude(String longitude) async {
    await authBox.put(_longitude, longitude);
    return longitude;
  }

  String get profilePicture => authBox.get(_profilePicture) ?? '';
  Future<String> setProfilePicture(String profilePicture) async {
    await authBox.put(_profilePicture, profilePicture);
    return profilePicture;
  }

  String get userAddress => authBox.get(_userAddress) ?? '';
  Future<String> setUserAddress(String address) async {
    await authBox.put(_userAddress, address);
    return address;
  }

  String get userAddressId => authBox.get(_userAddressId) ?? '';
  Future<String> setUserAddressId(String id) async {
    await authBox.put(_userAddressId, id);
    return id;
  }

  String get stripeSecretKey => authBox.get(_stripeSecretKey) ?? '';
  Future<String> setStripeSecretKey(String key) async {
    await authBox.put(_stripeSecretKey, key);
    return stripeSecretKey;
  }

  String get publishableKey => authBox.get(_publishableKey) ?? '';
  Future<String> setStripePublishableKey(String key) async {
    await authBox.put(_publishableKey, key);
    return publishableKey;
  }

  String get stripeMerchantId => authBox.get(_stripeMerchantId) ?? '';
  Future<String> setStripeMerchantId(String key) async {
    await authBox.put(_stripeMerchantId, key);
    return stripeMerchantId;
  }

  String get razoryPayKey => authBox.get(_razoryPayKey) ?? '';
  Future<String> setRazorpayKey(String key) async {
    await authBox.put(_razoryPayKey, key);
    return razoryPayKey;
  }

  String get apiUrl => authBox.get(_apiUrl) ?? '';
  Future<String> setApiUrl(String key) async {
    await authBox.put(_apiUrl, key);
    return apiUrl;
  }

  Future<int> clearBox() async {
    return await userBox.clear();
  }
}
