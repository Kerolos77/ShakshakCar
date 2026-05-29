import 'package:shakshak/features/user/user_home/domain/entities/user_home_caption_entity.dart';

class UserHomeCaptionModel implements UserHomeCaptionEntity {
  @override
  final List<CaptionItemEntity> captions;

  UserHomeCaptionModel({required this.captions});

  factory UserHomeCaptionModel.fromJson(List<dynamic> json) {
    return UserHomeCaptionModel(
      captions: json
          .map((item) => CaptionItem.fromJson(item))
          .where((item) => item.caption.isNotEmpty)
          .toList(),
    );
  }
}

class CaptionItem implements CaptionItemEntity {
  final int id;
  final String caption;
  final String lang;
  final int serviceId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Service? service;

  CaptionItem({
    required this.id,
    required this.caption,
    required this.lang,
    required this.serviceId,
    required this.createdAt,
    required this.updatedAt,
    this.service,
  });

  factory CaptionItem.fromJson(Map<String, dynamic> json) {
    return CaptionItem(
      id: json['id'] ?? 0,
      caption: json['caption'] ?? '',
      lang: json['lang'] ?? '',
      serviceId: json['service_id'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      service:
          json['service'] != null ? Service.fromJson(json['service']) : null,
    );
  }
}

class Service implements ServiceEntity {
  final int id;
  final String title;
  final String? image;
  final bool intercityType;
  final String kmCharge;
  final String offerRate;
  final bool enable;
  final dynamic adminCommission;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String serviceType;

  Service({
    required this.id,
    required this.title,
    this.image,
    required this.intercityType,
    required this.kmCharge,
    required this.offerRate,
    required this.enable,
    this.adminCommission,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.serviceType,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'],
      intercityType: json['intercity_type'] ?? false,
      kmCharge: json['km_charge'] ?? '0',
      offerRate: json['offer_rate'] ?? '0',
      enable: json['enable'] ?? false,
      adminCommission: json['admin_commission'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      serviceType: json['service_type'] ?? '',
    );
  }
}
