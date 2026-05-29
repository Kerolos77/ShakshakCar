import 'package:shakshak/features/shared/payment/domain/entities/card_entity.dart';

class CardModel extends CardEntity {
  CardModel({
    super.id,
    super.cardNumber,
    super.holderName,
    super.expiryDate,
    super.cvv,
    super.type,
    super.token,
  });

  CardModel.fromJson(Map<String, dynamic> json)
      : super(
          id: json['id'],
          cardNumber: json['card_number'],
          holderName: json['holder_name'],
          expiryDate: json['expiry_date'],
          cvv: json['cvv'],
          type: json['type'],
          token: json['token'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['card_number'] = cardNumber;
    data['holder_name'] = holderName;
    data['expiry_date'] = expiryDate;
    data['cvv'] = cvv;
    data['type'] = type;
    data['token'] = token;
    return data;
  }
}
