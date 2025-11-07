part of 'broker_bloc.dart';

@immutable
abstract class BrokerEvent {}

class GetAllBrokerEventHandler extends BrokerEvent {
  final int? page;
  final int? limit;
  final String? search;
  final String? fromDate;
  final String? toDate;
  final String? factoryName;
  final String? status;

  GetAllBrokerEventHandler({
    this.page,
    this.limit,
    this.search,
    this.fromDate,
    this.toDate,
    this.factoryName,
    this.status,
  });
}

class ApproveRejectBrokerEvent extends BrokerEvent {
  final String brokerId;
  final String status;

  ApproveRejectBrokerEvent({required this.brokerId, required this.status});
}

