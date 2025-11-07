part of 'labour_bloc.dart';

@immutable
abstract class LabourEvent {}

class GetAllLabourEventHandler extends LabourEvent {
  final String? fromDate;
  final String? toDate;
  final String? search;
  final String? factory;
  final String? status;

  GetAllLabourEventHandler({this.fromDate, this.toDate, this.search, this.factory, this.status});
}


class CreateLabourEvent extends LabourEvent {
  final List<Map<String, dynamic>> labourItems;

  CreateLabourEvent({required this.labourItems});
}
