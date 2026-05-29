import 'package:shakshak/features/driver/online_registration/domain/entities/driver_registration_entity.dart';

class DriverRegistrationModel extends DriverRegistrationEntity {
  DriverRegistrationModel({
    super.success,
    this.data,
    super.message,
    super.status,
  });

  DriverRegistrationModel.fromJson(dynamic json)
      : super(
          success: json['success'],
          message: json['message'],
          status: json['status'],
        ) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['message'] = message;
    return map;
  }
}

class Data {
  Data({
    this.id,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  int? id;
  String? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
