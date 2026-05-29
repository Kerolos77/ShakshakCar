import 'package:shakshak/features/driver/online_registration/domain/entities/car_model_entity.dart';

class CarModelModel {
  CarModelModel({
    this.status,
    this.statusval,
    this.msg,
    this.data,
  });

  CarModelModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      status = json['status'] is int
          ? json['status']
          : (json['code'] is int ? json['code'] : null);
      statusval = json['statusval'] is bool
          ? json['statusval']
          : (json['status'] is bool ? json['status'] : false);
      msg = json['msg'] ?? json['message'];
      if (json['data'] != null) {
        data = [];
        if (json['data'] is List) {
          json['data'].forEach((v) {
            data?.add(CarModelData.fromJson(v));
          });
        }
      }
    } else if (json is List) {
      data = [];
      for (var v in json) {
        data?.add(CarModelData.fromJson(v));
      }
      status = 1;
      statusval = true;
    }
  }

  int? status;
  bool? statusval;
  String? msg;
  List<CarModelData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['statusval'] = statusval;
    map['msg'] = msg;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class CarModelData extends CarModelEntity {
  CarModelData({
    super.id,
    super.name,
    super.brandId,
  });

  CarModelData.fromJson(dynamic json)
      : super(
          id: int.tryParse(json['id']?.toString() ?? ''),
          name: (json['title '] ?? json['title'] ?? json['name'])?.toString(),
          brandId: int.tryParse(json['brand_id']?.toString() ?? ''),
        );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['brand_id'] = brandId;
    return map;
  }
}
