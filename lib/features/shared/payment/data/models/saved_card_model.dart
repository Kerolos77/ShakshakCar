import 'package:shakshak/features/shared/payment/domain/entities/saved_card_entity.dart';

class SavedCardModel extends SavedCardEntity {
  SavedCardModel({
    required super.id,
    required super.cardSubtype,
    required super.maskedPan,
    required super.isDefault,
    required super.expiryMonth,
    required super.expiryYear,
    required super.cardHolderName,
  });

  factory SavedCardModel.fromJson(Map<String, dynamic> json) {
    return SavedCardModel(
      id: json['id'] ?? 0,
      cardSubtype: json['card_subtype'] ?? '',
      maskedPan: json['masked_pan'] ?? '',
      isDefault: json['is_default'] ?? false,
      expiryMonth: json['expiry_month'] ?? '',
      expiryYear: json['expiry_year'] ?? '',
      cardHolderName: json['holder_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_subtype': cardSubtype,
      'masked_pan': maskedPan,
      'is_default': isDefault,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
      'holder_name': cardHolderName,
    };
  }
}
