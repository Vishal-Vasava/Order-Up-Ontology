import 'dart:async';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_adapter.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_repository.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_role_enum.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_user.dart';
import 'package:orderly_ecom/src/features/authentication/domain/register.dart';
import 'package:orderly_ecom/src/features/authentication/domain/login.dart';
import 'package:orderly_ecom/src/features/location/data/location_local_repository.dart';
import 'package:orderly_ecom/src/services/crashlytics/crash_service.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> implements AuthAdapter {
  AuthCubit({required this.authRepository}) : super(AuthInitialState()) {
    emit(AuthCheckLoadingState());
    Timer(const Duration(seconds: 3), () async {
      authCheck();
    });
    inject.get<FirebaseAuth>().authStateChanges().listen((event) async {
      if (event == null) {
        emit(AuthCheckLoadingState());
        await Future.delayed(const Duration(seconds: 3));
        if (inject.get<LocationLocalRepository>().latitude.isEmpty) {
          emit(AuthLocationCheckState());
        } else {
          emit(AuthLoggedOutState());
          authRepository.authLocalRepository.clearBox();
        }
      }
    });
  }
  final AuthRepository authRepository;

  @override
  Future<bool> authCheck() async {
    try {
      if (inject.get<LocationLocalRepository>().latitude.isEmpty ||
          (kIsWeb && authRepository.authLocalRepository.apiUrl.isEmpty)) {
        emit(AuthLocationCheckState());
      } else {
        final user = authRepository.authLocalRepository.userBox.get('userBox');
        if (user != null) {
          emit(AuthLoggedInState(user: user, firebaseUser: null));
          return true;
        } else {
          emit(AuthLoggedOutState());
          return false;
        }
      }
    } catch (e, stk) {
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: e.toString(), stack: stk);
    }
    return false;
  }

  String firebaseId = '';
  String _verifiedPhoneNumber = '';
  @override
  Future<AuthUser?> login({required Login login}) async {
    late final AuthUser? user;
    try {
      emit(AuthLoadingState(
        isApple: login.isApple,
        isGoogle: login.isGoogle,
        isGuest: login.isGuest,
      ));
      firebaseId = login.firebaseId;
      if (login.userType == AuthRole.consumer.name) {
        /// [E01]: Reference
        user = await authRepository.login(
          login: Login(
            userType: AuthRole.consumer.name,
            firebaseId: login.firebaseId,
            fcmId: login.fcmId,
            deviceId: login.deviceId,
            isGoogle: login.isGoogle,
            isApple: login.isApple,
            isGuest: login.isGuest,
            mobile: login.mobile,
          ),
        );
      } else if (login.userType == AuthRole.producer.name) {
        user = await authRepository.managerLogin(
          login: Login(
            userType: AuthRole.producer.name,
            firebaseId: login.firebaseId,
            fcmId: login.fcmId,
            deviceId: login.deviceId,
            isGoogle: login.isGoogle,
            isApple: login.isApple,
            isGuest: login.isGuest,
            mobile: login.mobile,
          ),
        );
      } else if (login.userType == AuthRole.agent.name) {
        user = await authRepository.deliveryLogin(
          login: Login(
            userType: AuthRole.agent.name,
            firebaseId: login.firebaseId,
            fcmId: login.fcmId,
            deviceId: login.deviceId,
            isGoogle: login.isGoogle,
            isApple: login.isApple,
            isGuest: login.isGuest,
            mobile: login.mobile,
          ),
        );
      }
      if (user != null) {
        // if (user.address != null) {
        // await inject
        //     .get<AuthLocalRepository>()
        //     .setUserAddress(user.address ?? '');
        // }
        emit(AuthLoggedInState(user: user, firebaseUser: null));
      } else {
        emit(const AuthFailedState('Something went wrong'));
      }
    } catch (e, stk) {
      emit(AuthFailedState(e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: e.toString(), stack: stk);
    }
    return null;
  }

  @override
  Future<PhoneAuthCredential?> verifyOTP({
    required String userType,
    required String otpNumber,
    required String verificationId,
    required String guestToken,
    String phoneNumber = '',
  }) async {
    try {
      if (phoneNumber.isNotEmpty) {
        _verifiedPhoneNumber = phoneNumber.startsWith('+1')
            ? phoneNumber.substring(2)
            : phoneNumber.replaceFirst(RegExp(r'^\+'), '');
      }
      emit(const AuthLoadingState(
          isApple: false, isGoogle: false, isGuest: false));
      PhoneAuthCredential? credential = await authRepository.verifyOTP(
        userType: userType,
        otpNumber: otpNumber,
        verificationId: this.verificationId ?? '',
        guestToken: guestToken,
      );
      await loginWithPhone(
        userType: userType,
        credential: credential!,
        guestToken: guestToken,
      );
    } catch (e) {
      emit(AuthFailedState(e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: e.toString());
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
      //TOOO
      emit(AuthLoadingState(
          isApple: false, isGoogle: false, isGuest: guestToken.isNotEmpty));
      final userCredential = await authRepository.loginWithPhone(
        credential: credential,
        userType: userType,
        guestToken: guestToken,
      );
      if (userCredential?.user != null) {
        final fcmToken = await authRepository.getFcmToken();
        final deviceId = await authRepository.getDeviceToken();
        final firebasePhoneNumber =
            userCredential!.user!.phoneNumber ?? _verifiedPhoneNumber;
        final loginPhoneNumber = firebasePhoneNumber.startsWith('+1')
            ? firebasePhoneNumber.substring(2)
            : firebasePhoneNumber.replaceFirst(RegExp(r'^\+'), '');
        await login(
          login: Login(
            userType: userType,
            firebaseId: userCredential.user!.uid,
            fcmId: fcmToken!,
            deviceId: deviceId!,
            isGoogle: false,
            isApple: false,
            isGuest: guestToken.isNotEmpty,
            mobile: loginPhoneNumber,
          ),
        );
      }
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        case 'session-expired':
          emit(const AuthFailedState('Please Check Mobile Number'));
          break;

        case 'invalid-verification-code':
          emit(const AuthFailedState(
              'Incorrect OTP, Please enter OTP you have received'));
          break;
        default:
          emit(AuthFailedState(ex.message.toString()));
      }
    } catch (e) {
      emit(AuthFailedState(e.toString()));
    }
    return null;
  }

  @override
  Future<UserCredential?> loginWithGuest({required String userType}) async {
    try {
      emit(const AuthLoadingState(
          isApple: false, isGoogle: false, isGuest: true));
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      final fcmToken = await authRepository.getFcmToken();
      final deviceId = await authRepository.getDeviceToken();
      await login(
        login: Login(
          userType: userType,
          firebaseId: userCredential.user!.uid,
          fcmId: fcmToken!,
          deviceId: deviceId!,
          isGoogle: false,
          isApple: false,
          isGuest: true,
        ),
      );
    } catch (e) {
      emit(AuthFailedState(e.toString()));
    }
    return null;
  }

  @override
  String? verificationId;

  @override
  Future<bool> sendOTP({
    required String phoneNumber,
    required String userType,
    required String guestToken,
  }) async {
    try {
      _verifiedPhoneNumber = phoneNumber.startsWith('+1')
          ? phoneNumber.substring(2)
          : phoneNumber.replaceFirst(RegExp(r'^\+'), '');
      emit(const AuthLoadingState(
          isApple: false, isGoogle: false, isGuest: false));
      await authRepository.firebaseInstance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (vID, forceResendingToken) {
          verificationId = vID;
          emit(AuthCodeSentState());
        },
        timeout: const Duration(seconds: 60),
        verificationCompleted: (phoneAuthCredential) async {
          await loginWithPhone(
            userType: userType,
            credential: phoneAuthCredential,
            guestToken: guestToken,
          );
        },
        verificationFailed: (error) {
          emit(AuthFailedState(error.message.toString()));
        },
        codeAutoRetrievalTimeout: (verificationId) {
          verificationId = verificationId;
        },
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthFailedState(e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: e.toString());
    } catch (e) {
      emit(AuthFailedState(e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: e.toString());
    }
    return false;
  }

  @override
  Future<AuthUser?> register({required Register register}) async {
    try {
      emit(AuthRegisterLoadingState());
      final data = await authRepository.register(register: register);
      if (data != null) {
        final fcmToken = await authRepository.getFcmToken();
        final deviceId = await authRepository.getDeviceToken();
        await login(
          login: Login(
            userType: data.userType!,
            firebaseId: data.fbId!,
            fcmId: fcmToken!,
            deviceId: deviceId!,
            isGoogle: false,
            isApple: false,
            isGuest: false,
          ),
        );
      }
    } catch (e) {
      emit(AuthRegisterFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: e.toString());
    }
    return null;
  }

  @override
  Future<AuthUser?> deliveryLogin({required Login login}) async {
    throw UnimplementedError();
  }

  @override
  Future<AuthUser?> managerLogin({required Login login}) async {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential?> loginWithApple({required String userType}) async {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential?> loginWithGoogle({required String userType}) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> logout() async {
    try {
      emit(AuthLogoutLoadingState());
      await authRepository.firebaseInstance.signOut();
      // final data = await authRepository.logout();
      await authRepository.authLocalRepository.clearBox();
      emit(AuthLoggedOutState());
      return true;
    } catch (e) {
      emit(AuthLogoutFailedState(e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: e.toString());
      return false;
    }
  }

  String deleteReason = '';
  @override
  Future<bool> deleteAccount({required String reason}) async {
    try {
      emit(AuthDeleteLoadingState());
      final success = await authRepository.deleteAccount(reason: deleteReason);
      if (success) {
        emit(AuthDeleteSuccessState());
        await logout();
      } else {
        emit(const AuthDeleteFailedState(message: 'Please try again'));
      }
    } catch (e) {
      log(e.toString());
      emit(AuthDeleteFailedState(message: e.toString()));
    }
    return false;
  }
}
