import 'package:shakshak/features/shared/chat/domain/entities/send_message_entity.dart';

class SendMessageModel extends SendMessageEntity {
  SendMessageModel({
    super.success,
    super.message,
    super.data,
  });

  SendMessageModel.fromJson(dynamic json)
      : super(
          success: json['success'],
          message: json['message'],
          data: json['data'] != null ? Data.fromJson(json['data']) : null,
        );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = (data as Data).toJson();
    }
    return map;
  }
}

class Data extends SendMessageDataEntity {
  Data({
    super.email,
    super.description,
    super.updatedAt,
    super.createdAt,
    super.id,
  });

  Data.fromJson(dynamic json)
      : super(
          email: json['email'],
          description: json['description'],
          updatedAt: json['updated_at'],
          createdAt: json['created_at'],
          id: json['id'],
        );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['description'] = description;
    map['updated_at'] = updatedAt;
    map['created_at'] = createdAt;
    map['id'] = id;
    return map;
  }
}
