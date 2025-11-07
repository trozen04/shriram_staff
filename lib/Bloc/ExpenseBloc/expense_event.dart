part of 'expense_bloc.dart';

@immutable
abstract class ExpenseEvent {}

class GetAllExpenseEventHandler extends ExpenseEvent {
  final int? page;
  final int? limit;
  final String? fromDate;
  final String? toDate;
  final String? factoryName; // <-- changed from factoryId

  GetAllExpenseEventHandler({this.page, this.limit, this.fromDate, this.toDate, this.factoryName});
}


class CreateExpenseEventHandler extends ExpenseEvent {
  final num amount;
  final String reason;

  CreateExpenseEventHandler({required this.amount, required this.reason});
}
