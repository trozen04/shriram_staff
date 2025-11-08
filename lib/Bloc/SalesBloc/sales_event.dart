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



/// Subuser: Get all sales leads
class GetAllSalesLeadsSubUserEvent extends SalesEvent {
  int? page;
  int? limit;
  String? search;
  String? fromDate;
  String? toDate;
  String? status;

  GetAllSalesLeadsSubUserEvent({
    this.page,
    this.limit,
    this.search,
    this.fromDate,
    this.toDate,
    this.status,
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


// 🆕 Add this new event for report fetching
class GetSalesReportEvent extends SalesEvent {
  final String? fromDate;
  final String? toDate;
  final String? factory;

  GetSalesReportEvent({this.fromDate, this.toDate, this.factory});
}