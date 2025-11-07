part of 'sales_bloc.dart';

@immutable
sealed class SalesEvent {}

/// Superuser: Get all sales leads
class GetAllSalesLeadsSuperUserEvent extends SalesEvent {
  int? page;
  int? limit;
  String? search;
  String? fromDate;
  String? toDate;
  String? status;
  String? factory;

  GetAllSalesLeadsSuperUserEvent({
    this.page,
    this.limit,
    this.search,
    this.fromDate,
    this.toDate,
    this.status,
    this.factory,
  });
}

class CreateSalesLeadEvent extends SalesEvent {
  final String customerName;
  final String phoneNo;
  final String address;
  final String city;
  final String factoryId;
  final List<Map<String, dynamic>> finalQCItems; // List of QC items with items inside

  CreateSalesLeadEvent({
    required this.customerName,
    required this.phoneNo,
    required this.address,
    required this.city,
    required this.factoryId,
    required this.finalQCItems,
  });
}