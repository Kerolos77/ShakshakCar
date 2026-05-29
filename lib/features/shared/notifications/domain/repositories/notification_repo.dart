import 'package:shakshak/features/shared/notifications/domain/entities/notification_entity.dart';

abstract class NotificationRepo {
  Future<PaginatedNotificationEntity> getNotifications({int page = 1});
  Future<int> getUnreadCount();
  Future<void> saveNotification(NotificationEntity notification);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<void> clearAll();
  Future<void> updateFcmToken(String token);
}
