part of 'subusers_bloc.dart';

@immutable
abstract class SubusersEvent {}

/// Fetch existing subusers
class SubUsersFetchEvent extends SubusersEvent {
  final int? page;
  final int? limit;
  final String? search;
  final String? factoryId;

  SubUsersFetchEvent({this.page, this.limit, this.search, this.factoryId});
}


/// Create new subuser
final class SubusersCreateEvent extends SubusersEvent {
  final String name;
  final String email;
  final String phone;
  final String role;
  final List<String> authorities;
  final String salary;
  final String factoryId;
  final String address;
  final String password;
  final String confirmPassword;

  SubusersCreateEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.authorities,
    required this.salary,
    required this.factoryId,
    required this.address,
    required this.password,
    required this.confirmPassword,
  });
}
