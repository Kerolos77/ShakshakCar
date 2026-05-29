import 'package:shakshak/features/driver/online_registration/domain/entities/car_brand_entity.dart';

class CarBrandModel {
  CarBrandModel({
    this.status,
    this.statusval,
    this.msg,
    this.data,
  });

  CarBrandModel.fromJson(dynamic json) {
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
            data?.add(CarBrandData.fromJson(v));
          });
        }
      }
    } else if (json is List) {
      data = [];
      for (var v in json) {
        data?.add(CarBrandData.fromJson(v));
      }
      status = 1;
      statusval = true;
    }
  }

  int? status;
  bool? statusval;
  String? msg;
  List<CarBrandData>? data;

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

class CarBrandData extends CarBrandEntity {
  CarBrandData({
    super.id,
    super.name,
  });

  CarBrandData.fromJson(dynamic json)
      : super(
          id: int.tryParse(json['id']?.toString() ?? ''),
          name: (json['title '] ?? json['title'] ?? json['name'])?.toString(),
        );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
