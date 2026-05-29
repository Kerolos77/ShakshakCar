import 'package:shakshak/features/driver/home/domain/entities/driver_toggle_online_entity.dart';

class DriverToggleOnlineModel extends DriverToggleOnlineEntity {
  DriverToggleOnlineModel({
    this.data,
    super.msg,
    super.status,
    super.statusval,
  }) : super(isOnline: data?.isOnline);

  factory DriverToggleOnlineModel.fromJson(dynamic json) {
    return DriverToggleOnlineModel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      msg: json['msg'],
      status: json['status'],
      statusval: json['statusval'],
    );
  }

  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['msg'] = msg;
    map['status'] = status;
    map['statusval'] = statusval;
    return map;
  }
}

class Data {
  Data({
    this.isOnline,
  });

  Data.fromJson(dynamic json) {
    isOnline = json['is_online'];
  }

  String? isOnline;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_online'] = isOnline;
    return map;
  }
}
