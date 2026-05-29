class AcceptOfferEntity {
  AcceptOfferEntity({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  AcceptOfferDataEntity? data;
}

class AcceptOfferDataEntity {
  AcceptOfferDataEntity({
    this.email,
    this.description,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String? email;
  String? description;
  String? updatedAt;
  String? createdAt;
  int? id;
}
