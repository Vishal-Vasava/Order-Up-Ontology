import 'package:firebase_auth/firebase_auth.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_user.dart';
import 'package:orderly_ecom/src/features/authentication/domain/login.dart';
import 'package:orderly_ecom/src/features/authentication/domain/register.dart';

abstract class AuthAdapter extends SocialAuth {
  String? verificationId;
  Future<bool> authCheck() {
    throw UnimplementedError('Auth Check Not Implemented');
  }

  Future<AuthUser?> login({
    required Login login,
  });

  Future<AuthUser?> managerLogin({required Login login}) {
    throw UnimplementedError('Not Implemented');
  }

  Future<AuthUser?> deliveryLogin({required Login login}) {
    throw UnimplementedError('Not Implemented');
  }

  Future<AuthUser?> register({required Register register});
  Future<bool> logout();

  Future<bool> deleteAccount({required String reason});
}

abstract class SocialAuth {
  Future<UserCredential?> loginWithGoogle({required String userType});
  Future<UserCredential?> loginWithApple({required String userType});
  Future<UserCredential?> loginWithGuest({required String userType});

  Future<UserCredential?> loginWithPhone({
    required PhoneAuthCredential credential,
    required String userType,
    required String guestToken,
  });
  Future<bool> sendOTP({
    required String userType,
    required String phoneNumber,
    required String guestToken,
  }) {
    throw UnimplementedError('Not Implemented');
  }

  Future<PhoneAuthCredential?> verifyOTP({
    required String userType,
    required String otpNumber,
    required String verificationId,
    required String guestToken,
  });
}
