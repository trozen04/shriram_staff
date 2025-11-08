part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

/// LOGIN EVENT
final class LoginRequestEventHandler extends AuthEvent {
  final String email;
  final String password;

  LoginRequestEventHandler({required this.email, required this.password});
}



