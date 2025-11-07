part of 'attendance_bloc.dart';

abstract class AttendanceState {}

class AttendanceInitialState extends AttendanceState {}

class AttendanceLoadingState extends AttendanceState {}

class AttendanceSuccessState extends AttendanceState {
  final dynamic attendanceData; // can be List or Map depending on API
  AttendanceSuccessState({required this.attendanceData});
}

class AttendanceErrorState extends AttendanceState {
  final String message;
  AttendanceErrorState(this.message);
}
