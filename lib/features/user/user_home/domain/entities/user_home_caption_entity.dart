class UserHomeCaptionEntity {
  final List<CaptionItemEntity> captions;

  UserHomeCaptionEntity({required this.captions});
}

class CaptionItemEntity {
  final int id;
  final String caption;
  final String lang;
  final int serviceId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ServiceEntity? service;

  CaptionItemEntity({
    required this.id,
    required this.caption,
    required this.lang,
    required this.serviceId,
    required this.createdAt,
    required this.updatedAt,
    this.service,
  });
}

class ServiceEntity {
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

  ServiceEntity({
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
}
