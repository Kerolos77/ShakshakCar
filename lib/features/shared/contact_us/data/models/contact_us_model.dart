import 'package:shakshak/features/shared/contact_us/domain/entities/contact_us_entity.dart';

class ContactUsModel extends ContactUsEntity {
  ContactUsModel({
    super.success,
    super.data,
    super.message,
  });

  ContactUsModel.fromJson(dynamic json)
      : super(
          success: json['success'],
          data: json['data'] != null ? Data.fromJson(json['data']) : null,
          message: json['message'],
        );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) {
      map['data'] = (data as Data).toJson();
    }
    map['message'] = message;
    return map;
  }
}

class Data extends ContactUsDataEntity {
  Data({
    super.phone,
    super.email1,
  });

  Data.fromJson(dynamic json)
      : super(
          phone: json['phone'],
          email1: json['email_1'],
        );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = phone;
    map['email_1'] = email1;
    return map;
  }
}
