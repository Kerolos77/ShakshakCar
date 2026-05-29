import 'package:shakshak/features/user/user_home/domain/entities/price_entity.dart';

class PriceModel implements PriceEntity {
  PriceModel({
    required this.km,
    required this.price,
    required this.min,
  });

  PriceModel.fromJson(Map<String, dynamic> json)
      : km = json['km'],
        price = json['price'],
        min = json['min'];

  num km;
  String price;
  String min;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['km'] = km;
    data['price'] = price;
    data['min'] = min;
    return data;
  }
}
