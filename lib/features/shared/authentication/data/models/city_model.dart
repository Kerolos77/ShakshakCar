import 'package:shakshak/features/shared/authentication/domain/entities/city_entity.dart';

class CityModel implements CityEntity {
  CityModel({
    this.data,
    this.msg,
    this.status,
    this.statusval,
  });

  CityModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    msg = json['msg'];
    status = json['status'];
    statusval = json['statusval'];
  }

  List<Data>? data;
  String? msg;
  int? status;
  bool? statusval;
}

class Data implements CityDataEntity {
  Data({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  int? id;
  String? name;
  String? latitude;
  String? longitude;
}
