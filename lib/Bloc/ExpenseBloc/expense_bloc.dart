import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../../Constants/ApiConstants.dart';
import '../../utils/pref_utils.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseInitial()) {

    // 🔹 Get all expenses
    on<GetAllExpenseEventHandler>((event, emit) async {
      emit(ExpenseLoadingState());
      try {
        final url = ApiConstants.baseUrl + ApiConstants.getAllExpense;
        final token = PrefUtils.getToken();
        final queryParams = <String, String>{};

        if (event.page != null) queryParams['page'] = event.page.toString();
        if (event.limit != null) queryParams['limit'] = event.limit.toString();
        if (event.fromDate != null) queryParams['fromdate'] = event.fromDate!;
        if (event.toDate != null) queryParams['todate'] = event.toDate!;
        if (event.factoryName  != null) queryParams['factoryname'] = event.factoryName !;

        final uri = Uri.parse(url).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        developer.log('GetAllExpense URL: $uri\nResponse: ${response.body}');

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(ExpenseSuccessState(expenseData: responseData['data'] ?? [], isCreate: false));
        } else {
          emit(ExpenseErrorState(
            message: responseData['message'] ?? 'Failed to fetch expenses.',
          ));
        }
      } catch (e) {
        developer.log('GetAllExpense Exception: $e');
        emit(ExpenseErrorState(message: 'Oops! Something went wrong.'));
      }
    });

    // 🔹 Create expense
    on<CreateExpenseEventHandler>((event, emit) async {
      emit(ExpenseLoadingState());
      try {
        final url = ApiConstants.baseUrl + ApiConstants.createExpense;
        final token = PrefUtils.getToken();

        final body = {
          'amount': event.amount,
          'reason': event.reason,
        };

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        );

        developer.log('CreateExpense URL: $url\nBody: $body\nResponse: ${response.body}');

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(ExpenseSuccessState(isCreate: true));
        } else {
          emit(ExpenseErrorState(
            message: responseData['message'] ?? 'Failed to create expense.',
          ));
        }
      } catch (e) {
        developer.log('CreateExpense Exception: $e');
        emit(ExpenseErrorState(message: 'Oops! Something went wrong.'));
      }
    });

  }
}
