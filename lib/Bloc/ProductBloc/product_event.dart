part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class GetAllProductEventHandler extends ProductEvent {
  final String? fromDate;
  final String? toDate;
  final String? search;

  GetAllProductEventHandler({this.fromDate, this.toDate, this.search});
}


class CreateProductEvent extends ProductEvent {
  final String name;

  CreateProductEvent({required this.name});
}