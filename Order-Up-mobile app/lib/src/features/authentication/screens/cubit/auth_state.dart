part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthCheckLoadingState extends AuthState {}

class AuthLocationCheckState extends AuthState {}

class AuthLoadingState extends AuthState {
  const AuthLoadingState({
    required this.isApple,
    required this.isGoogle,
    required this.isGuest,
  });

  final bool isApple;
  final bool isGoogle;
  final bool isGuest;
}

class AuthCodeSentState extends AuthState {}

class AuthCodeVerifiedState extends AuthState {}

class AuthLoggedInState extends AuthState {
  const AuthLoggedInState({required this.user, required this.firebaseUser});

  final AuthUser user;
  final User? firebaseUser;
}

class AuthLoggedOutState extends AuthState {}

class AuthLogoutLoadingState extends AuthState {}

class AuthLogoutFailedState extends AuthState {
  const AuthLogoutFailedState(this.message);

  final String message;
}

class AuthFailedState extends AuthState {
  const AuthFailedState(this.error);
  final String error;
  @override
  List<Object> get props => [error];
}

/// DELETE ACCOUNT STATE
class AuthDeleteLoadingState extends AuthState {}

class AuthDeleteSuccessState extends AuthState {}

class AuthDeleteFailedState extends AuthState {
  const AuthDeleteFailedState({required this.message});

  final String message;
}

/// REGISTER ACCOUNT STATE
class AuthRegisterLoadingState extends AuthState {}

class AuthRegisterSuccessState extends AuthState {}

class AuthRegisterFailedState extends AuthState {
  const AuthRegisterFailedState({required this.message});

  final String message;
}
