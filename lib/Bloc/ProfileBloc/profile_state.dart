part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState{}

class ProfileSuccessState extends ProfileState{
  dynamic responseData;
  ProfileSuccessState({required this.responseData});
}

class ProfileErrorState extends ProfileState{
  String message;
  ProfileErrorState({required this.message});
}
