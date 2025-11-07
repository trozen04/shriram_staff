import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shree_ram_staff/Constants/ApiConstants.dart';
import '../../utils/pref_utils.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceBloc() : super(AttendanceInitialState()) {

    /// Fetch Attendance
    on<FetchAttendanceEventHandler>((event, emit) async {
      emit(AttendanceLoadingState());

      try {
        final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getAttendance);
        final userToken = PrefUtils.getToken();

        final queryParams = {
          'month': event.month.toString(),
          'year': event.year.toString(),
          if (event.factoryName.isNotEmpty) 'factoryname': event.factoryName,
        };

        final finalUri = uri.replace(queryParameters: queryParams);
        developer.log("📤 Attendance API Request: $finalUri");

        final response = await http.get(
          finalUri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        );

        developer.log("📥 Response: ${response.statusCode}");
        developer.log(response.body);
        final data = json.decode(response.body);

        if (response.statusCode == 200) {
          emit(AttendanceSuccessState(attendanceData: data));
        } else {
          emit(AttendanceErrorState(data['message'] ?? 'No Data Found.'));
        }
      } catch (e) {
        developer.log("❌ AttendanceBloc Error: $e");
        emit(AttendanceErrorState( 'Oops! Something went wrong. Please try again later.'));
      }
    });
  }
}
