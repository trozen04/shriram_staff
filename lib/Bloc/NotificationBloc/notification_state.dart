part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final dynamic notificationData;
  NotificationSuccess(this.notificationData);
}

class NotificationMarkReadSuccess extends NotificationState {
  final dynamic responseData;
  NotificationMarkReadSuccess(this.responseData);
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}
