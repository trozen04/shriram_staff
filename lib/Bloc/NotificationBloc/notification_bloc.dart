import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Constants/ApiConstants.dart';
import '../../utils/pref_utils.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    // 🔹 Fetch notifications
    on<NotificationEventHandler>((event, emit) async {
      try {
        emit(NotificationLoading());

        final url = ApiConstants.baseUrl + ApiConstants.getAllNotification;
        //final userToken = PrefUtils.getToken();
        final userToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5MGY0MmMzNzljY2M4NDhjMGM5YWMzMCIsImVtYWlsIjoiYW1hbkBnbWFpbC5jb20iLCJyb2xlIjoic3VidXNlciIsImlhdCI6MTc2Mjc2NzcxMCwiZXhwIjoxNzYzNjMxNzEwfQ.Sx1ZAIo0-g055EfXbHMwvFsLwK7aV4BteR5TmPwymm0';

        developer.log('🔔 Fetch Notifications API: $url');
        developer.log('🔑 Token: $userToken');

        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        );

        developer.log('Response: ${response.statusCode}\n${response.body}');

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(NotificationSuccess(responseData));
        } else {
          emit(
            NotificationError(
              responseData['message'] ?? 'Failed to load notifications.',
            ),
          );
        }
      } catch (e) {
        developer.log('❌ Notification Fetch Error: $e');
        emit(NotificationError('Something went wrong. Please try again.'));
      }
    });

    // 🔹 Mark notification as read
    on<NotificationMarkReadEventHandler>((event, emit) async {
      try {
        emit(NotificationLoading());

        final url = '${ApiConstants.baseUrl}${ApiConstants.markNotificationAsRead}/${event.notificationId}';

        final userToken = PrefUtils.getToken();

        developer.log('🔔 Mark Read API: $url');

        final response = await http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        );

        developer.log('Response: ${response.statusCode}\n${response.body}');

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(NotificationMarkReadSuccess(responseData));
        } else {
          emit(
            NotificationError(
              responseData['message'] ?? 'Failed to mark notification as read.',
            ),
          );
        }
      } catch (e) {
        developer.log('❌ Notification Mark Read Error: $e');
        emit(NotificationError('Something went wrong. Please try again.'));
      }
    });
  }
}
