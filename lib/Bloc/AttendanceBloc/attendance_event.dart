part of 'attendance_bloc.dart';

abstract class AttendanceEvent {}

class FetchAttendanceEventHandler extends AttendanceEvent {
  final String factoryName;
  final int month;
  final int year;

  FetchAttendanceEventHandler({
    required this.factoryName,
    required this.month,
    required this.year,
  });
}
