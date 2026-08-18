import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_adapter.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_role_enum.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_user.dart';
import 'package:orderly_ecom/src/features/authentication/domain/pin_code.dart';
import 'package:orderly_ecom/src/features/authentication/domain/register.dart';
import 'package:orderly_ecom/src/features/authentication/domain/login.dart';
import 'package:orderly_ecom/src/features/location/data/location_local_repository.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/utils/exceptions.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository extends AuthAdapter {
  AuthRepository({
    required this.networkAdapter,
    required this.firebaseInstance,
    required this.authLocalRepository,
  });
  final NetworkAdapter networkAdapter;
  final FirebaseAuth firebaseInstance;
  final AuthLocalRepository authLocalRepository;

  Future<String?> getFcmToken() async {
    // Push notifications are optional for authentication. On the web,
    // requesting an FCM token requires browser notification permission and
    // must not prevent a user from signing in when that permission is denied.
    if (kIsWeb) {
      const webToken = 'web-notifications-disabled';
      await authLocalRepository.setUserFcmToken(webToken);
      return webToken;
    }

    final String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await authLocalRepository.setUserFcmToken(fcmToken);
    }
    return fcmToken;
  }

  Future<String?> getDeviceToken() async {
    final deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      return 'web';
    }
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidDeviceId = await deviceInfo.androidInfo;
      authLocalRepository.setuserDeviceId(androidDeviceId.id);
      return androidDeviceId.id;
    } else {
      final IosDeviceInfo iosDeviceId = await deviceInfo.iosInfo;
      authLocalRepository.setuserDeviceId(iosDeviceId.identifierForVendor!);
      return iosDeviceId.identifierForVendor ?? '';
    }
  }

  Future<PostalCode?> fetchPincode({required String pinCode}) async {
    try {
      final finalUrl = Endpoints.worldPostalLocationApi(pinCode: pinCode);
      final response = await networkAdapter.get(finalUrl);
      return PostalCode.fromJson(response.data);
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<AuthUser?> login({required Login login}) async {
    try {
      const String url = Endpoints.customerLogin;
      final Map<String, dynamic> data = login.toJson();
      if (login.isGuest) {
        data['is_guest'] = true;
        data['old_token'] = inject.get<LocationLocalRepository>().guestToken;
      }
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        final isModernResponse = response.data['statusCode'] == 200;
        final isLegacyResponse = response.data['status'] == 200 &&
            response.data['user']?['is_registered'] == 'true';
        if (isModernResponse || isLegacyResponse) {
          final rawUserData = isModernResponse
              ? response.data['data']['user']
              : response.data['user'];
          final accessToken = isModernResponse
              ? response.data['data']['tokens']['access_token']
              : rawUserData['access_token'];
          final refreshToken = isModernResponse
              ? response.data['data']['tokens']['refresh_token']
              : rawUserData['refresh_token'];

          final Map<String, dynamic> userData = isModernResponse
              ? Map<String, dynamic>.from(rawUserData)
              : <String, dynamic>{
                  ...Map<String, dynamic>.from(rawUserData),
                  '_id': rawUserData['user_id']?.toString(),
                  'email': rawUserData['email_id'],
                  'phone': rawUserData['mobile'],
                  'address_line': rawUserData['address'],
                  'address': <dynamic>[],
                  'cart': <dynamic>[],
                  'status': true,
                  'createdAt': DateTime.fromMillisecondsSinceEpoch(0)
                      .toIso8601String(),
                  'updatedAt': DateTime.fromMillisecondsSinceEpoch(0)
                      .toIso8601String(),
                };

          final authUser = AuthUser.fromJson(userData);
          if (authUser.signupType!.toLowerCase() != 'guest') {
            await authLocalRepository.setAccessToken(accessToken);
            await authLocalRepository.setRefreshToken(refreshToken);
            await authLocalRepository.setGuestAccessToken('');
            await inject.get<LocationLocalRepository>().setGuestToken('');
            await authLocalRepository.setGuestRefreshAccessToken('');
          } else {
            await authLocalRepository.setGuestAccessToken(accessToken);
            await authLocalRepository.setGuestRefreshAccessToken(accessToken);
            await inject
                .get<LocationLocalRepository>()
                .setGuestToken(accessToken);
          }

          await authLocalRepository.setUserModel(user: authUser);

          await authLocalRepository.setUserAddress(authUser.addressLine ?? '');

          return authUser;
        } else if (response.data['status'] == 200 &&
            response.data['user']?['is_registered'] == 'false') {
          throw const AppException(message: 'Customer Not Found');
        } else if (response.data['statusCode'] == 400) {
          if (response.data['message'] == 'Customer Not Found') {
            /// [E01]: Throws Exception
            throw AppException(message: response.data['message']);
          }
        }
      } else {
        throw const AppException(message: 'Please try again');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw AppException(message: e.response?.data['message']);
      }
      throw DioExceptions.fromDioError(e).toString();
    }
    return null;
  }

  @override
  Future<AuthUser?> managerLogin({required Login login}) async {
    try {
      const String url = Endpoints.storeLogin;
      final Map<String, dynamic> data = login.toJson();
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        final isModernResponse = response.data['statusCode'] == 200;
        final isLegacyResponse = response.data['status'] == 200 &&
            response.data['user']?['is_registered'] == 'true';
        if (isModernResponse || isLegacyResponse) {
          final rawUserData = isModernResponse
              ? response.data['data']['user']
              : response.data['user'];
          final accessToken = isModernResponse
              ? response.data['data']['tokens']['access_token']
              : rawUserData['access_token'];
          final refreshToken = isModernResponse
              ? response.data['data']['tokens']['refresh_token']
              : rawUserData['refresh_token'];

          final Map<String, dynamic> userData = isModernResponse
              ? Map<String, dynamic>.from(rawUserData)
              : <String, dynamic>{
                  ...Map<String, dynamic>.from(rawUserData),
                  '_id': rawUserData['user_id']?.toString(),
                  'email': rawUserData['email_id'],
                  'phone': rawUserData['mobile'],
                  'user_type': AuthRole.producer.name,
                  'address_line': rawUserData['address'],
                  'address': <dynamic>[],
                  'cart': <dynamic>[],
                  'status': true,
                  'createdAt': DateTime.fromMillisecondsSinceEpoch(0)
                      .toIso8601String(),
                  'updatedAt': DateTime.fromMillisecondsSinceEpoch(0)
                      .toIso8601String(),
                };

          final authUser = AuthUser.fromJson(userData);

          await authLocalRepository.setAccessToken(accessToken);
          await authLocalRepository.setRefreshToken(refreshToken);

          await authLocalRepository.setUserModel(user: authUser);

          return authUser;
        } else {
          final registrationState = response.data['user']?['is_registered'];
          throw AppException(
            message: registrationState == 'false'
                ? 'No active store manager matches this phone number'
                : 'Producer login returned an unsupported response',
          );
        }
      } else {
        throw const AppException(message: 'Please try again');
      }
    } on DioException catch (e) {
      final validationErrors = e.response?.data is Map
          ? e.response?.data['errors']
          : null;
      if (validationErrors != null) {
        throw AppException(
          message: 'Producer login validation failed: $validationErrors',
        );
      }
      throw AppException(
        message:
            'Producer login HTTP ${e.response?.statusCode ?? 'connection error'}',
      );
    }
  }

  @override
  Future<AuthUser?> deliveryLogin({required Login login}) async {
    try {
      const String url = Endpoints.agentLogin;
      final Map<String, dynamic> data = login.toJson();
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          final accessToken = response.data['data']['tokens']['access_token'];
          final refreshToken = response.data['data']['tokens']['refresh_token'];

          final authUser = AuthUser.fromJson(response.data['data']['user']);

          await authLocalRepository.setAccessToken(accessToken);
          await authLocalRepository.setRefreshToken(refreshToken);

          await authLocalRepository.setUserModel(user: authUser);

          return authUser;
        } else {
          return null;
        }
      } else {
        throw const AppException(message: 'Please try again');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<AuthUser?> register({required Register register}) async {
    try {
      const String url = Endpoints.customerRegister;
      final Map<String, dynamic> data = register.toJson();
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        final dynamic responseStatus =
            response.data['statusCode'] ?? response.data['status'];
        if (responseStatus == 200) {
          final bool isModernResponse = response.data['statusCode'] == 200;
          final dynamic rawUserData = isModernResponse
              ? response.data['data']['user']
              : response.data['user'];
          final Map<String, dynamic> userData = isModernResponse
              ? Map<String, dynamic>.from(rawUserData)
              : <String, dynamic>{
                  ...Map<String, dynamic>.from(rawUserData),
                  '_id': rawUserData['user_id']?.toString(),
                  'email': rawUserData['email_id'],
                  'phone': rawUserData['mobile'],
                  'user_type': rawUserData['user_type']?.toString() ?? '0',
                  'address_line': rawUserData['address'],
                  'address': <dynamic>[],
                  'cart': <dynamic>[],
                  'status': true,
                  'createdAt': DateTime.fromMillisecondsSinceEpoch(0)
                      .toIso8601String(),
                  'updatedAt': DateTime.fromMillisecondsSinceEpoch(0)
                      .toIso8601String(),
                };
          final AuthUser authUser = AuthUser.fromJson(userData);
          return authUser;
        } else {
          return null;
        }
      } else {
        throw const AppException(message: 'Please try again');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<UserCredential?> loginWithGoogle({required String userType}) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await firebaseInstance.signInWithCredential(credential);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw const AppException(
            message: 'The account already exists with a different credential');
      } else if (e.code == 'invalid-credential') {
        throw const AppException(
            message: 'Error occurred while accessing credentials. Try again.');
      }
    } on PlatformException {
      throw const AppException(
          message: 'Try again. Oops cant connect to google');
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  Future<UserCredential?> loginWithPhone({
    required PhoneAuthCredential credential,
    required String userType,
    required String guestToken,
  }) async {
    try {
      UserCredential userCredential =
          await firebaseInstance.signInWithCredential(credential);
      return userCredential;
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        case 'session-expired':
          throw const AppException(message: 'Please Check Mobile Number');

        case 'invalid-verification-code':
          throw const AppException(
              message: 'Incorrect OTP, Please enter OTP you have received');
        default:
          throw AppException(message: ex.message.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PhoneAuthCredential?> verifyOTP({
    required String userType,
    required String otpNumber,
    required String verificationId,
    required String guestToken,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpNumber,
      );
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<UserCredential?> loginWithApple({required String userType}) async {
    try {
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteAccount({required String reason}) async {
    try {
      String url = '';
      final authUser = inject.get<AuthLocalRepository>().authUser;
      if (authUser.userType! == AuthRole.consumer.name) {
        url = Endpoints.customerDeleteAccount;
      } else if (authUser.userType! == AuthRole.producer.name) {
        url = Endpoints.storeDeleteAccount;
      } else if (authUser.userType! == AuthRole.agent.name) {
        url = Endpoints.agentDeleteAccount;
      }
      final data = inject.get<FirebaseAuth>().currentUser;
      await data?.delete();
      final payload = {'reason': reason};
      final response = await networkAdapter.delete(
        url,
        data: payload,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 200) {
        //  {"data":{"isRemoved":true},"statusCode":200}
        if (response.data['statusCode'] == 200) {
          if (response.data['data']['isRemoved']) {
            authLocalRepository.userBox.clear();
            authLocalRepository.authBox.clear();
            return true;
          } else {
            return false;
          }
        } else {
          throw const AppException(message: 'Please try again');
        }
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw const AppException(
            message:
                'We need you to logout and login and attempt delete with fresh verification');
      } else {
        throw const AppException(message: 'Please try again!');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<bool> logout() async {
    // try {
    //   const String url = Endpoints.logout;
    //   final response = await networkAdapter.get(url);
    //   if (response.statusCode! >= 200 && response.statusCode! <= 299) {
    //     if ('Please try again' == 'Success') {
    //       return true;
    //     } else {
    //       return false;
    //     }
    //   } else {
    //     throw const AppException(message: 'Please try to logout again');
    //   }
    // } catch (e) {
    //   rethrow;
    // }
    throw UnimplementedError();
  }

  @override
  Future<UserCredential?> loginWithGuest({required String userType}) {
    throw UnimplementedError();
  }
}
