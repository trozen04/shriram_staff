part of 'qc_bloc.dart';

@immutable
sealed class QcState {}

final class QcInitial extends QcState {}

class CreateInitialQcLoadingState extends QcState{}

class CreateInitialQcSuccessState extends QcState{
  dynamic responseData;
  CreateInitialQcSuccessState({required this.responseData});
}

class CreateInitialQcErrorState extends QcState{
  String message;
  CreateInitialQcErrorState({required this.message});
}

///GetAllQC

class GetAllQcLoadingState extends QcState{}

class GetAllQcSuccessState extends QcState{
  dynamic responseData;
  GetAllQcSuccessState({required this.responseData});
}

class GetAllQcErrorState extends QcState{
  String message;
  GetAllQcErrorState({required this.message});
}

/// Final QC Submit
class FinalQcLoadingState extends QcState {}

class FinalQcSuccessState extends QcState {
  dynamic response;
  FinalQcSuccessState(this.response);
}

class FinalQcErrorState extends QcState {
  final String message;
  FinalQcErrorState({required this.message});
}
