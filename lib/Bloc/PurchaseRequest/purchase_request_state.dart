part of 'purchase_request_bloc.dart';

@immutable
sealed class PurchaseRequestState {}

final class PurchaseRequestInitial extends PurchaseRequestState {}

class PurchaseRequestLoadingState extends PurchaseRequestState {}

class PurchaseRequestSuccessState extends PurchaseRequestState {
  dynamic purchaseRequestData;
  PurchaseRequestSuccessState({required this.purchaseRequestData});
}

class PurchaseRequestErrorState extends PurchaseRequestState {
  String message;
  PurchaseRequestErrorState({required this.message});
}

///New Purchase PurchaseRequestErrorState
class NewPurchaseRequestSuccessState extends PurchaseRequestState {
  final dynamic responseData;
  NewPurchaseRequestSuccessState({required this.responseData});
}
