import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_user.dart';

import 'package:shakshak/features/driver/outstation/presentation/widgets/driver_rides_list_item.dart';

class RidesList extends StatelessWidget {
  const RidesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemBuilder: (context, index) => DriverRidesListItem(
        isOutstation: false,
        ride: NewRideData(
          id: 0,
          destinationLat: 0,
          destinationLong: 0,
          destinationAddress: '',
          sourceLat: 0,
          sourceLong: 0,
          sourceAddress: '',
          amount: 0,
          finalRate: 0,
          distance: 0,
          distanceType: 'km',
          status: 'searching',
          isOffer: false,
          createdAt: DateTime.now(),
          user: NewRideUser(
            id: 0,
            name: 'User',
            phone: '',
            image: '',
            countryId: '',
            email: '',
            walletAmount: 0,
            pendingWallet: 0,
            isDriver: false,
            isOnline: false,
            serviceId: 0,
          ),
          whenDate: null,
          interCity: false,
          userServiceId: 0,
          paid: false,
          paymentType: 'cash',
          numberOfPassenger: 1,
          serviceType: 'ride',
          reviewsCount: 0,
          hasReview: false,
        ),
      ),
      separatorBuilder: (context, index) => 12.ph,
      itemCount: 5,
    );
  }
}
