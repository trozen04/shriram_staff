part of 'broker_bloc.dart';

@immutable
abstract class BrokerState {}

class BrokerInitialState extends BrokerState {}

class BrokerLoadingState extends BrokerState {}

class BrokerSuccessState extends BrokerState {
  final brokerData;
  BrokerSuccessState({required this.brokerData});
}

class BrokerErrorState extends BrokerState {
  final String message;
  BrokerErrorState({required this.message});
}


class BrokerApprovalLoadingState extends BrokerState {}

class BrokerApprovalSuccessState extends BrokerState {
  final String message;
  BrokerApprovalSuccessState({required this.message});
}

class BrokerApprovalErrorState extends BrokerState {
  final String message;
  BrokerApprovalErrorState({required this.message});
}
