part of 'subusers_bloc.dart';

@immutable
abstract class SubusersState {}

class SubusersInitial extends SubusersState {}

class SubusersLoadingState extends SubusersState {}

class SubusersSuccessState extends SubusersState {
    final dynamic subusersData;
    SubusersSuccessState({required this.subusersData});
  }

/// Create new subuser

class SubusersCreateSuccessState extends SubusersState {
  final dynamic createdData;
  SubusersCreateSuccessState({required this.createdData});
}

class SubusersErrorState extends SubusersState {
  final String message;
  SubusersErrorState({required this.message});
}
