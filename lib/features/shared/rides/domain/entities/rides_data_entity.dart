import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';

class RidesDataEntity {
  final List<NewRideData>? searching;
  final List<NewRideData>? placed;
  final List<NewRideData>? started;
  final List<NewRideData>? completed;
  final List<NewRideData>? canceled;
  final List<NewRideData>? allRides;

  RidesDataEntity({
    this.searching,
    this.placed,
    this.started,
    this.completed,
    this.canceled,
    this.allRides,
  });
}
