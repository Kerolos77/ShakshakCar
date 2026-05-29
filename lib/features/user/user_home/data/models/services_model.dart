import 'package:shakshak/features/user/user_home/domain/entities/services_entity.dart';

class ServicesModel implements ServicesEntity {
  ServicesModel({
    this.data,
  });

  ServicesModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ServiceData.fromJson(v));
      });
    }
  }

  @override
  List<ServiceDataEntity>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => (v as ServiceData).toJson()).toList();
    }
    return map;
  }
}

class ServiceData implements ServiceDataEntity {
  ServiceData({
    this.id,
    this.name,
    this.image,
    this.offerRate,
    this.serviceType,
  });

  ServiceData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    offerRate = json['offer_rate'];
    serviceType = json['service_type'];
  }

  num? id;
  String? name;
  String? image;
  String? offerRate;
  String? serviceType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    map['offer_rate'] = offerRate;
    map['service_type'] = serviceType;
    return map;
  }
}
