part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

/// Notification Data
class NotificationEventHandler extends NotificationEvent {}

/// Notification Mark read
class NotificationMarkReadEventHandler extends NotificationEvent {
  final String notificationId;

  NotificationMarkReadEventHandler(this.notificationId);
}
