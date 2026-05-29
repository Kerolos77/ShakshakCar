import 'package:shakshak/features/user/user_home/domain/entities/accept_offer_entity.dart';

class AcceptOfferModel implements AcceptOfferEntity {
  AcceptOfferModel({
    this.success,
    this.message,
    this.data,
  });

  AcceptOfferModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  @override
  bool? success;
  @override
  String? message;
  @override
  AcceptOfferDataEntity? data;

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

class Data implements AcceptOfferDataEntity {
  Data({
    this.email,
    this.description,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  Data.fromJson(dynamic json) {
    email = json['email'];
    description = json['description'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  String? email;
  String? description;
  String? updatedAt;
  String? createdAt;
  int? id;

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
