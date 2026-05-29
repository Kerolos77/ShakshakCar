import 'package:flutter/material.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';
import 'package:shakshak/features/user/ride_tracking/presentation/views/ride_tracking_view.dart';

class DriveDetailsView extends StatelessWidget {
  const DriveDetailsView({super.key, required this.ride});

  final NewRideDataEntity ride;

  @override
  Widget build(BuildContext context) {
    return RideTrackingView(ride: ride);
  }
}
