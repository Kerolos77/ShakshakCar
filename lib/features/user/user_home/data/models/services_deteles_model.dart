import 'package:shakshak/features/user/user_home/domain/entities/price_entity.dart';
import 'package:shakshak/features/user/user_home/domain/entities/services_entity.dart';
import 'price_model.dart';
import 'services_model.dart';

class ServicesDetailsModel {
  ServicesDetailsModel({
    required this.service,
    this.price,
  });

  ServiceDataEntity service;
  PriceEntity? price;

  ServicesDetailsModel.fromJson(Map<String, dynamic> json)
      : service = ServiceData.fromJson(json['service']),
        price = json['km'] != null ? PriceModel.fromJson(json) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service'] = (service as ServiceData).toJson();
    if (price != null) {
      data.addAll((price as PriceModel).toJson());
    }
    return data;
  }
}
