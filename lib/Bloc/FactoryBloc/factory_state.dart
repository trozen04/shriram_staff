part of 'factory_bloc.dart';

@immutable
abstract class FactoryState {}

class FactoryInitial extends FactoryState {}

class FactoryLoadingState extends FactoryState {}

class FactorySuccessState extends FactoryState {
  final dynamic factoryData;
  FactorySuccessState({required this.factoryData});
}

class FactoryInventorySuccessState extends FactoryState {
  final dynamic responseData;

  FactoryInventorySuccessState({this.responseData});
}

class FactoryErrorState extends FactoryState {
  final String message;
  FactoryErrorState({required this.message});
}
