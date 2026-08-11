import 'package:shakshak/features/shared/notifications/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.date,
    super.isRead = false,
    super.type,
    super.imageUrl,
    super.payload,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    var dataObj = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : <String, dynamic>{};

    String? img = dataObj['image'] ??
        dataObj['image_url'] ??
        dataObj['imageUrl'] ??
        dataObj['picture'] ??
        dataObj['photo'] ??
        json['image'] ??
        json['image_url'] ??
        json['imageUrl'] ??
        json['picture'] ??
        json['photo'];

    String? parsedType = dataObj['type'] ?? json['type'] ?? json['notification_type'];

    Map<String, dynamic>? parsedPayload = (dataObj['payload'] is Map<String, dynamic>)
        ? dataObj['payload']
        : ((json['payload'] is Map<String, dynamic>)
            ? json['payload']
            : (dataObj.isNotEmpty ? dataObj : null));

    return NotificationModel(
      id: json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: dataObj['title'] ?? json['title'] ?? '',
      body: dataObj['body'] ?? json['body'] ?? '',
      date: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : (json['date'] != null
              ? DateTime.tryParse(json['date']) ?? DateTime.now()
              : DateTime.now()),
      isRead: json['read_at'] != null || (json['is_read'] == true),
      type: parsedType,
      imageUrl: (img != null && img.isNotEmpty) ? img : null,
      payload: parsedPayload,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'date': date.toIso8601String(),
      'is_read': isRead,
      'type': type,
      'image_url': imageUrl,
      'payload': payload,
    };
  }
}
