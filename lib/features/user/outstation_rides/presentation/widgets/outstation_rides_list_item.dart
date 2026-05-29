import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';

class OutstationRidesListItem extends StatelessWidget {
  const OutstationRidesListItem({
    super.key,
    required this.ride,
  });

  final NewRideData ride;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppConstant.shadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ride.status,
                style: Styles.textStyle16SemiBold(context),
              ),
              Text(
                '${ride.amount} EGP',
                style: Styles.textStyle18Bold(context),
              ),
            ],
          ),
          8.ph,
          Row(
            children: [
              Column(
                children: [
                  Container(
                    height: 24.r,
                    width: 24.r,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 2),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(
                      height: 30.h,
                      child: VerticalDivider(
                        color: Theme.of(context).dividerColor,
                      )),
                  Container(
                    height: 24.r,
                    width: 24.r,
                    padding: EdgeInsets.all(1.r),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.place,
                      color: Theme.of(context).colorScheme.surface,
                      size: 16.r,
                    ),
                  ),
                ],
              ),
              12.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride.sourceAddress,
                      style: Styles.textStyle16Medium(context),
                    ),
                    30.ph,
                    Text(
                      ride.destinationAddress,
                      style: Styles.textStyle16SemiBold(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          10.ph,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12.r)),
            child: Text(
              ride.status,
              style: Styles.textStyle16SemiBold(context),
            ),
          ),
          10.ph,
        ],
      ),
    );
  }
}
