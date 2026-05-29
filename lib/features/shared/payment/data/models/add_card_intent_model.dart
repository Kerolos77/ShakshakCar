import 'package:shakshak/features/shared/payment/domain/entities/add_card_intent_entity.dart';

class AddCardIntentModel extends AddCardIntentEntity {
  AddCardIntentModel({
    required super.orderId,
    required super.checkoutUrl,
  });

  factory AddCardIntentModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      return AddCardIntentModel(
        orderId: json['data']['order_id'] ?? '',
        checkoutUrl: json['data']['checkout_url'] ?? '',
      );
    }
    return AddCardIntentModel(orderId: '', checkoutUrl: '');
  }
}
