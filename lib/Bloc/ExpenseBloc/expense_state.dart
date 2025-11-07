part of 'expense_bloc.dart';

@immutable
abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoadingState extends ExpenseState {}

class ExpenseSuccessState extends ExpenseState {
  final List<dynamic>? expenseData;
  final bool isCreate;

  ExpenseSuccessState({this.expenseData, this.isCreate = false});
}

class ExpenseErrorState extends ExpenseState {
  final String message;
  ExpenseErrorState({required this.message});
}
