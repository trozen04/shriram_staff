import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../Constants/ApiConstants.dart';
import '../../utils/pref_utils.dart';

part 'salary_event.dart';
part 'salary_state.dart';

class SalaryBloc extends Bloc<SalaryEvent, SalaryState> {
  SalaryBloc() : super(SalaryInitialState()) {

    on<FetchSalaryEvent>((event, emit) async {
      try {
        final userToken = PrefUtils.getToken();

        // Build query parameters dynamically
        final queryParams = {
          'fromdate': event.fromDate,
          'todate': event.toDate,
          if (event.factoryName != null && event.factoryName!.isNotEmpty)
            'factoryname': event.factoryName!,
          if (event.isDownload == true) 'download': 'pdf',
        };

        // Build URI with query parameters
        final uri = Uri.parse('${ApiConstants.baseUrl}/api/salary/getall')
            .replace(queryParameters: queryParams);

        developer.log('Salary API URL: $uri');
        developer.log('Salary queryParams: $queryParams');

        // Emit loading only for JSON requests
        if (event.isDownload == false) {
          emit(SalaryLoadingState());
        }

        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        );

        developer.log('Salary API response: ${response.statusCode}\n${response.body}');

        final contentType = response.headers['content-type'] ?? '';

        // PDF handling
        if (event.isDownload == true && contentType.contains('application/pdf')) {
          final bytes = response.bodyBytes;
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/salary_report.pdf');
          await file.writeAsBytes(bytes);
          await OpenFile.open(file.path);
          return; // skip emitting any other state
        }

        // Normal JSON response
        final responseData = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          developer.log('Salary API responseData: $responseData');
          emit(SalarySuccessState(salaryData: responseData));
        } else {
          emit(SalaryErrorState(
            responseData['message'] ?? 'Failed to fetch salary data.',
          ));
        }
      } catch (e) {
        developer.log('Salary API error: $e');
        emit(SalaryErrorState(
          'Oops! Something went wrong. Please try again later.',
        ));
      }
    });


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
