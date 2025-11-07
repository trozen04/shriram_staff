part of 'product_bloc.dart';

@immutable
abstract class ProductState {}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductSuccessState extends ProductState {
  dynamic products;
  ProductSuccessState(this.products);
}

class ProductErrorState extends ProductState {
  final String message;
  ProductErrorState(this.message);
}

class ProductCreateSuccessState extends ProductState {
  dynamic response;
  ProductCreateSuccessState(this.response);
}
