import 'package:shakshak/features/shared/faq/domain/entities/faqs_entity.dart';

class FaqsModel extends FaqsEntity {
  FaqsModel({
    super.success,
    super.data,
    super.message,
  });

  FaqsModel.fromJson(dynamic json)
      : super(
          success: json['success'],
          message: json['message'],
        ) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Faq.fromJson(v));
      });
    }
  }

  @override
  List<Faq>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    return map;
  }
}

class Faq extends FaqEntity {
  Faq({
    super.id,
    super.title,
    super.description,
    super.createdAt,
  });

  Faq.fromJson(dynamic json)
      : super(
          id: json['id'],
          title: json['title'],
          description: json['description'],
          createdAt: json['created_at'],
        );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['created_at'] = createdAt;
    return map;
  }
}
