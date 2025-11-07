import 'dart:convert';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../../Constants/ApiConstants.dart';
import '../../utils/pref_utils.dart';

part 'salary_event.dart';
part 'salary_state.dart';

class SalaryBloc extends Bloc<SalaryEvent, SalaryState> {
  SalaryBloc() : super(SalaryInitialState()) {

    /// Create Salary
    on<CreateSalaryEvent>((event, emit) async {
      emit(SalaryLoadingState());
      try {
        final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.createSalary);
        developer.log("📤 Create Salary URI: $uri");

        final userToken = PrefUtils.getToken();
        developer.log("📤 User Token: $userToken");

        final body = json.encode({
          "name": event.name,
          "totalsalary": event.totalSalary,
          "salarypaid": event.salaryPaid,
          "totalpresent": event.totalPresent,
        });

        developer.log("📤 Create Salary Request: $body");

        final response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
          body: body,
        );

        developer.log("📥 Response: ${response.statusCode}");
        developer.log(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = json.decode(response.body);
          emit(SalaryCreateSuccessState(data));
        } else {
          emit(SalaryErrorState('Failed to create salary'));
        }
      } catch (e) {
        developer.log("❌ SalaryBloc Error: $e");
        emit(SalaryErrorState(e.toString()));
      }
    });
  }
}
