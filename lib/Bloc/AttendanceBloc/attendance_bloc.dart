import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shree_ram_staff/Constants/ApiConstants.dart';
import '../../utils/pref_utils.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceBloc() : super(AttendanceInitialState()) {

    /// Fetch Attendance
    on<FetchAttendanceEventHandler>((event, emit) async {
      try {
        final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getAttendance);
        final userToken = PrefUtils.getToken();
        developer.log("📤 Attendance API uri: $uri");

        final queryParams = <String, String>{
          'month': event.month.toString(),
          'year': event.year.toString(),
          if (event.factoryName.isNotEmpty) 'factoryname': event.factoryName,
          if (event.isDownload) 'download': 'pdf', // handle download
        };

        final finalUri = uri.replace(queryParameters: queryParams);
        developer.log("📤 Attendance API Request: $finalUri");

        // Emit loading only if not downloading
        if (!event.isDownload) {
          emit(AttendanceLoadingState());
        }

        final response = await http.get(
          finalUri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        );

        final contentType = response.headers['content-type'] ?? '';
        developer.log("📥 Response: ${response.statusCode}");

        // Handle PDF download
        if (event.isDownload && contentType.contains('application/pdf')) {
          final bytes = response.bodyBytes;

          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/attendance_report.pdf');
          await file.writeAsBytes(bytes);

          await OpenFile.open(file.path);

          // Skip emitting any state for download
          return;
        }

        // Normal JSON response
        final data = json.decode(response.body);
        if (response.statusCode == 200) {
          emit(AttendanceSuccessState(attendanceData: data));
        } else {
          emit(AttendanceErrorState(
            data['message'] ?? 'No Data Found.',
          ));
        }
      } catch (e) {
        developer.log("❌ AttendanceBloc Error: $e");
        emit(AttendanceErrorState(
          'Oops! Something went wrong. Please try again later.',
        ));
      }
    });
  }
}
