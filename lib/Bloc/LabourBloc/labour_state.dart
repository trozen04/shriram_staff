part of 'labour_bloc.dart';

@immutable
abstract class LabourState {}

class LabourInitialState extends LabourState {}

class LabourLoadingState extends LabourState {}

class LabourSuccessState extends LabourState {
  dynamic labourData;
  LabourSuccessState(this.labourData);
}

class LabourErrorState extends LabourState {
  final String message;
  LabourErrorState(this.message);
}

class LabourCreateSuccessState extends LabourState {
  final dynamic response;
  LabourCreateSuccessState(this.response);
}
