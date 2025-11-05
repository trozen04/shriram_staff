part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

/// LOGIN EVENT
final class LoginRequestEventHandler extends AuthEvent {
  final String phone;
  final String password;

  LoginRequestEventHandler({required this.phone, required this.password});
}



