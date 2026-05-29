import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_user.dart';

import 'drive_details_card.dart';

class OrderDetailsViewBody extends StatelessWidget {
  const OrderDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.map,
                size: 100.r,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.2),
              ),
              12.ph,
              Text(
                'Map Placeholder',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 30.h,
          left: 16.w,
          right: 16.w,
          child: DriveDetailsCard(
            ride: NewRideData(
              id: 0,
              amount: 70.00,
              finalRate: 70.00,
              distance: 0,
              distanceType: 'km',
              sourceLat: 0,
              sourceLong: 0,
              destinationLat: 0,
              destinationLong: 0,
              sourceAddress: '',
              destinationAddress: '',
              status: 'accepted',
              user: NewRideUser(
                id: 0,
                name: 'Kero',
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
              isOffer: false,
              createdAt: DateTime.now(),
              whenDate: null,
              interCity: false,
              userServiceId: 0,
              paid: false,
              paymentType: 'cash',
              numberOfPassenger: 1,
              serviceType: '',
              reviewsCount: 0,
              hasReview: false,
            ),
          ),
        ),
      ],
    );
  }
}
