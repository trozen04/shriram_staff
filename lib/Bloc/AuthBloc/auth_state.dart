part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

// ---------------- OTP STATES ----------------
final class LoginLoading extends AuthState {}

final class LoginSuccess extends AuthState {
  dynamic response;
  LoginSuccess({required this.response});
}

final class LoginError extends AuthState {
  final String message;
  LoginError({required this.message});
}

// ---------------- REGISTER STATES ----------------
final class RegisterLoading extends AuthState {}

final class RegisterSuccess extends AuthState {
  final dynamic response;
  RegisterSuccess({required this.response});
}

final class RegisterError extends AuthState {
  final String message;
  RegisterError({required this.message});
}
