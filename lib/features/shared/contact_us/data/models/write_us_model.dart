import 'package:shakshak/features/shared/contact_us/domain/entities/write_us_entity.dart';

class WriteUsModel extends WriteUsEntity {
  WriteUsModel({
    super.success,
    super.message,
    super.data,
  });

  WriteUsModel.fromJson(dynamic json)
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

class Data extends WriteUsDataEntity {
  Data({
    super.email,
    super.description,
    super.message,
    super.updatedAt,
    super.createdAt,
    super.id,
  });

  Data.fromJson(dynamic json)
      : super(
          email: json['email'],
          description: json['description'],
          message: json['message'],
          updatedAt: json['updated_at'],
          createdAt: json['created_at'],
          id: json['id'],
        );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['description'] = description;
    map['message'] = message;
    map['updated_at'] = updatedAt;
    map['created_at'] = createdAt;
    map['id'] = id;
    return map;
  }
}
