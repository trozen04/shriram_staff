part of 'billing_bloc.dart';

abstract class BillingEvent {}

class GetAllBillingEventHandler extends BillingEvent {
  final int page;
  final int limit;
  final String? fromDate;
  final String? toDate;
  final String? search;
  final String? factoryId;
  final String? status;

  GetAllBillingEventHandler({
    required this.page,
    required this.limit,
    this.fromDate,
    this.toDate,
    this.search,
    this.factoryId,
    this.status,
  });
}

class GenerateBillingEvent extends BillingEvent {
  final String finalQCId;
  final List<Map<String, dynamic>> billingItems;
  final dynamic deductions;

  GenerateBillingEvent({
    required this.finalQCId,
    required this.billingItems,
    required this.deductions,
  });
}