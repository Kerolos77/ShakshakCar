import 'package:shakshak/features/shared/authentication/domain/entities/country_entity.dart';

class CountryModel implements CountryEntity {
  CountryModel({
    this.data,
    this.msg,
    this.status,
    this.statusval,
  });

  CountryModel.fromJson(dynamic json) {
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

class Data implements CountryDataEntity {
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
