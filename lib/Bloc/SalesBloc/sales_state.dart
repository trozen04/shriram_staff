part of 'sales_bloc.dart';

@immutable
sealed class SalesState {}

class SalesInitial extends SalesState {}

class SalesLoading extends SalesState {}

class SalesSuccess extends SalesState {
  dynamic responseData;
  SalesSuccess(this.responseData);
}

class SalesError extends SalesState {
  String message;
  SalesError(this.message);
}


class SalesCreateSuccess extends SalesState {
  final dynamic responseData;
  SalesCreateSuccess(this.responseData);
}

// 🆕 Add new report success state
class SalesReportSuccess extends SalesState {
  final dynamic reportData;
  SalesReportSuccess(this.reportData);
}


///Subuser
class getSubUserSalesLeadLoading extends SalesState {}

class getSubUserSalesLeadSuccess extends SalesState {
  dynamic responseData;
  getSubUserSalesLeadSuccess(this.responseData);
}

class getSubUserSalesLeadError extends SalesState {
  String message;
  getSubUserSalesLeadError(this.message);
}

/// 🆕 NEW STATE
class SalesLoadingUpsertSuccess extends SalesState {
  final dynamic data;
  final bool isSave;
  SalesLoadingUpsertSuccess({required this.data, required this.isSave});
}

class AcceptSalesLeadLoading extends SalesState {}

class AcceptSalesLeadSuccess extends SalesState {
  final Map<String, dynamic> response;

  AcceptSalesLeadSuccess(this.response);
}

class AcceptSalesLeadError extends SalesState {
  final String message;

  AcceptSalesLeadError(this.message);
}