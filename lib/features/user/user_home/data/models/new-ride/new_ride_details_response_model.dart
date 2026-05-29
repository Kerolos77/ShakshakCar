import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';

class NewRideDetailsResponse {
  final NewRideData data;
  final String msg;
  final int status;
  final bool statusVal;

  NewRideDetailsResponse({
    required this.data,
    required this.msg,
    required this.status,
    required this.statusVal,
  });

  factory NewRideDetailsResponse.fromJson(Map<String, dynamic> json) {
    return NewRideDetailsResponse(
      data: NewRideData.fromJson(
          json['data'] is Map<String, dynamic> ? json['data'] : {}),
      msg: json['msg'] ?? '',
      status: json['status'] ?? 0,
      statusVal: json['statusval'] ?? false,
    );
  }
}

