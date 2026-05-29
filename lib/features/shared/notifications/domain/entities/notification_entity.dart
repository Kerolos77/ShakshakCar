class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  bool isRead;
  final String? type;
  final Map<String, dynamic>? payload;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.isRead = false,
    this.type,
    this.payload,
  });
}

class PaginatedNotificationEntity {
  final List<NotificationEntity> notifications;
  final bool hasMore;

  PaginatedNotificationEntity({required this.notifications, required this.hasMore});
}
