import 'package:shakshak/features/shared/rides/domain/entities/rides_data_entity.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';

class RidesData extends RidesDataEntity {
  RidesData({
    super.searching,
    super.placed,
    super.started,
    super.completed,
    super.canceled,
    required super.allRides,
  });

  factory RidesData.fromJson(dynamic json) {
    List<NewRideData>? searching;
    List<NewRideData>? placed;
    List<NewRideData>? started;
    List<NewRideData>? completed;
    List<NewRideData>? canceled;
    List<NewRideData> allRides = [];

    print('DEBUG: RidesData.fromJson input json type: ${json.runtimeType}');
    if (json is Map) {
      print('DEBUG: RidesData.fromJson keys: ${json.keys.toList()}');
    }

    if (json is List) {
      for (var v in json) {
        allRides.add(NewRideData.fromJson(v));
      }
      return RidesData(
        allRides: allRides,
      );
    } else if (json is Map) {
      // Handle nested wrappers if present
      if (json.containsKey('data') &&
          (json['data'] is Map || json['data'] is List)) {
        return RidesData.fromJson(json['data']);
      }
      if (json.containsKey('orders') &&
          (json['orders'] is Map || json['orders'] is List)) {
        return RidesData.fromJson(json['orders']);
      }

      json.forEach((key, value) {
        if (value is List) {
          for (var v in value) {
            allRides.add(NewRideData.fromJson(v));
          }
        }
      });

      // Populate specific lists if they exist in the map
      if (json['searching'] != null) {
        searching = [];
        json['searching'].forEach((v) => searching?.add(NewRideData.fromJson(v)));
      }
      if (json['placed'] != null) {
        placed = [];
        json['placed'].forEach((v) => placed?.add(NewRideData.fromJson(v)));
      }
      if (json['started'] != null) {
        started = [];
        json['started'].forEach((v) => started?.add(NewRideData.fromJson(v)));
      }
      if (json['completed'] != null) {
        completed = [];
        json['completed'].forEach((v) => completed?.add(NewRideData.fromJson(v)));
      }
      if (json['canceled'] != null) {
        canceled = [];
        json['canceled'].forEach((v) => canceled?.add(NewRideData.fromJson(v)));
      }

      return RidesData(
        searching: searching,
        placed: placed,
        started: started,
        completed: completed,
        canceled: canceled,
        allRides: allRides,
      );
    }

    return RidesData(allRides: []);
  }
}
