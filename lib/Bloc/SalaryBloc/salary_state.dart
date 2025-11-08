part of 'salary_bloc.dart';

@immutable
abstract class SalaryState {}

class SalaryInitialState extends SalaryState {}

class SalaryLoadingState extends SalaryState {}

class SalaryCreateSuccessState extends SalaryState {
  final dynamic responseData;
  SalaryCreateSuccessState(this.responseData);
}

class SalaryErrorState extends SalaryState {
  final String message;
  SalaryErrorState(this.message);
}


class SalarySuccessState extends SalaryState {
  dynamic salaryData;
  SalarySuccessState({required this.salaryData});
}