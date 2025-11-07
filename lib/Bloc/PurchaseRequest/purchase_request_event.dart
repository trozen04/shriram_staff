part of 'purchase_request_bloc.dart';

@immutable
sealed class PurchaseRequestEvent {}

final class PurchaseRequestEventHandler extends PurchaseRequestEvent {
  int? page;
  int? limit;
  String? search;
  String? fromDate;
  String? toDate;
  String? status;
  String? factoryName;

  PurchaseRequestEventHandler({
    this.page,
    this.limit,
    this.search,
    this.fromDate,
    this.toDate,
    this.status,
    this.factoryName,
  });
}

final class NewPurchaseRequestEvent extends PurchaseRequestEvent {
  final String paddyType;
  final String name;
  final String mobileNo;
  final String address;
  final String city;
  final String state;
  final int quantity;
  final String weight;

  NewPurchaseRequestEvent({
    required this.paddyType,
    required this.name,
    required this.mobileNo,
    required this.address,
    required this.city,
    required this.state,
    required this.quantity,
    required this.weight,
  });
}


// New Event for Approve / Reject
class ApproveRejectPurchaseEvent extends PurchaseRequestEvent {
  final String purchaseId;
  final String status; // "Approve" or "Cancel"

  ApproveRejectPurchaseEvent({required this.purchaseId, required this.status});
}