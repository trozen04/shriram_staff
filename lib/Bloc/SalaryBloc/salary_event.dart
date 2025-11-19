part of 'salary_bloc.dart';

@immutable
abstract class SalaryEvent {}

class CreateSalaryEvent extends SalaryEvent {
  final String name;
  final int totalSalary;
  final int salaryPaid;
  final int totalPresent;

  CreateSalaryEvent({
    required this.name,
    required this.totalSalary,
    required this.salaryPaid,
    required this.totalPresent,
  });
}

class FetchSalaryEvent extends SalaryEvent {
  final String fromDate;
  final String toDate;
  final String? factoryName;
  final bool? isDownload;

  FetchSalaryEvent({required this.fromDate, required this.toDate, this.factoryName, this.isDownload});
}