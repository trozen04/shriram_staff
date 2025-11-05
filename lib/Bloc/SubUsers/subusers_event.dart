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
  final String mobileNo;
  final String role;
  final String authority;
  final String salary;
  final String factoryId;
  final String address;
  final String password;
  final String confirmPassword;

  SubusersCreateEvent({
    required this.name,
    required this.mobileNo,
    required this.role,
    required this.authority,
    required this.salary,
    required this.factoryId,
    required this.address,
    required this.password,
    required this.confirmPassword,
  });
}
