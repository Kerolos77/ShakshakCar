import 'package:shakshak/features/shared/static_pages/domain/entities/static_pages_entity.dart';

class StaticPagesModel extends StaticPagesEntity {
  StaticPagesModel({
    super.success,
    super.data,
    super.message,
  });

  StaticPagesModel.fromJson(dynamic json)
      : super(
          success: json['success'],
          data: json['data'] != null ? Data.fromJson(json['data']) : null,
          message: json['message'],
        );
}

class Data extends StaticPagesDataEntity {
  Data({
    super.id,
    super.name,
    super.slug,
    super.content,
  });

  Data.fromJson(dynamic json)
      : super(
          id: json['id'],
          name: json['name'],
          slug: json['slug'],
          content: json['content'],
        );
}
