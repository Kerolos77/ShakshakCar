import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';

import 'outstation_rides_list_item.dart';

class OutstationRidesListView extends StatelessWidget {
  const OutstationRidesListView({super.key, required this.rides});

  final List<NewRideData> rides;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      itemCount: rides.length,
      itemBuilder: (context, index) => OutstationRidesListItem(
        ride: rides[index],
      ),
      separatorBuilder: (context, index) => 16.ph,
    );
  }
}

