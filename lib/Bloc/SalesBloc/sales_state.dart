part of 'sales_bloc.dart';

@immutable
sealed class SalesState {}

class SalesInitial extends SalesState {}

class SalesLoading extends SalesState {}

class SalesSuccess extends SalesState {
  dynamic responseData;
  SalesSuccess(this.responseData);
}

class SalesError extends SalesState {
  String message;
  SalesError(this.message);
}


class SalesCreateSuccess extends SalesState {
  final dynamic responseData;
  SalesCreateSuccess(this.responseData);
}