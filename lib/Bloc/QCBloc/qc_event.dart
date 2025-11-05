part of 'qc_bloc.dart';

@immutable
sealed class QcEvent {}

///Create QC
class CreateInitialQcEventHandler extends QcEvent{
  final String intialWeight;
  final String moisture;
  final String ricein;
  final String huskin;
  final String discolor;
  final String transportId;
  CreateInitialQcEventHandler(
      {required this.intialWeight, required this.moisture, required this.ricein, required this.huskin, required this.discolor, required this.transportId});

}


///Get All QC
final class GetAllQcEventHandler extends QcEvent {
  int? page;
  int? limit;
  String? search;
  String? fromDate;
  String? toDate;
  String? status;

  GetAllQcEventHandler({
    this.page,
    this.limit,
    this.search,
    this.fromDate,
    this.toDate,
    this.status,
  });
}

/// Final QC Submit
class SubmitFinalQcEvent extends QcEvent {
  final String qcNumber;
  final List<Map<String, dynamic>> paddyQc;
  final List<Map<String, dynamic>> riceQc;
  final File? deliveryProof;
  final String transportId;
  final String finalWeight;

  SubmitFinalQcEvent({
    required this.qcNumber,
    required this.paddyQc,
    required this.riceQc,
    this.deliveryProof,
    required this.transportId,
    required this.finalWeight,
  });
}