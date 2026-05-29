import 'package:shakshak/features/shared/rides/data/models/rides_data.dart';
import 'package:shakshak/features/shared/rides/domain/entities/rides_entity.dart';

class RideModel extends RidesEntity {
  RideModel({
    super.data,
    super.msg,
    super.status,
    super.statusval,
  });

  factory RideModel.fromJson(dynamic json) {
    return RideModel(
      data: json['data'] != null ? RidesData.fromJson(json['data']) : null,
      msg: json['msg'],
      status: json['status'],
      statusval: json['statusval'],
    );
  }
}
