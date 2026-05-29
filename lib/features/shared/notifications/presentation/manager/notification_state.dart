part of 'notification_cubit.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final bool hasMore;
  final bool isFetchingMore;
  final int unreadCount;
  
  NotificationLoaded(
    this.notifications, {
    this.hasMore = false,
    this.isFetchingMore = false,
    this.unreadCount = 0,
  });
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

class NotificationNewMessage extends NotificationState {
  final NotificationEntity notification;
  NotificationNewMessage(this.notification);
}
