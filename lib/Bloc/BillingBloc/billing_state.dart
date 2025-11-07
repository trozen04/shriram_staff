part of 'billing_bloc.dart';

abstract class BillingState {}

class BillingInitialState extends BillingState {}

class BillingLoadingState extends BillingState {}

class BillingSuccessState extends BillingState {
  final dynamic billingData;
  BillingSuccessState(this.billingData);
}

class BillingErrorState extends BillingState {
  final String message;
  BillingErrorState(this.message);
}


class BillingGenerateLoadingState extends BillingState {}

class BillingGenerateSuccessState extends BillingState {
  final billingData;

  BillingGenerateSuccessState({required this.billingData});
}

class BillingGenerateErrorState extends BillingState {
  final String message;

  BillingGenerateErrorState({required this.message});
}