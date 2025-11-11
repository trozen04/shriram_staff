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
  bool isSuperUser;

  GetAllSalesLeadsSubUserEvent({
    this.page,
    this.limit,
    this.search,
    this.fromDate,
    this.toDate,
    this.status,
    required this.isSuperUser,
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

class UpsertLoadingEvent extends SalesEvent {
  final String salesLeadId;
  final String driverName;
  final String phoneNo;
  final String ownerName;
  final String ownerPhoneNo;
  final String? initialWeight; // optional
  final String? finalWeight;   // optional
  final bool? isSave;   // optional

  final File? adharCard;
  final File? driverLicence;
  final File? vehicleRC;
  final File? deliveryProof;

  UpsertLoadingEvent({
    required this.salesLeadId,
    required this.driverName,
    required this.phoneNo,
    required this.ownerName,
    required this.ownerPhoneNo,
    this.initialWeight,
    this.isSave = false,
    this.finalWeight,
    this.adharCard,
    this.driverLicence,
    this.vehicleRC,
    this.deliveryProof,
  });
}

class AcceptSalesLeadEvent extends SalesEvent {
  final String leadId;

  AcceptSalesLeadEvent({required this.leadId});
}
