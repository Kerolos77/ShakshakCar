import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/common_use.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';

class DriveDetailsCard extends StatelessWidget {
  const DriveDetailsCard({
    super.key,
    this.onTap,
    required this.ride,
  });

  final void Function()? onTap;
  final NewRideDataEntity ride;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  backgroundImage: ride.driver?.image != null &&
                          ride.driver!.image.isNotEmpty
                      ? CachedNetworkImageProvider(ride.driver!.image)
                      : null,
                  child:
                      ride.driver?.image == null || ride.driver!.image.isEmpty
                          ? Icon(Icons.person,
                              color: AppColors.primaryColor, size: 35.r)
                          : null,
                ),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.driver?.name ?? 'Driver',
                        style: Styles.textStyle18Bold(context),
                      ),
                      Text(
                        '${ride.carBrand ?? ''} ${ride.carModel ?? ''} • ${ride.carColor ?? ''}',
                        style: Styles.textStyle14SemiBold(context).copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6)),
                      ),
                      if (ride.carPlate != null && ride.carPlate!.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(top: 4.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                          ),
                          child: Text(
                            ride.carPlate!,
                            style: Styles.textStyle14Bold(context)
                                .copyWith(letterSpacing: 2),
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${ride.amount} ${S.of(context).currency}',
                      style: Styles.textStyle20Bold(context)
                          .copyWith(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ],
            ),
            16.ph,
            // Trip Details (Source & Destination)
            Row(
              children: [
                Column(
                  children: [
                    Icon(Icons.my_location,
                        color: AppColors.primaryColor, size: 20.r),
                    Container(
                        height: 20.h,
                        width: 2.w,
                        color: Theme.of(context).dividerColor),
                    Icon(Icons.location_on, color: Colors.red, size: 20.r),
                  ],
                ),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.sourceAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Styles.textStyle14SemiBold(context),
                      ),
                      12.ph,
                      Text(
                        ride.destinationAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Styles.textStyle14SemiBold(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            16.ph,
            const Divider(),
            8.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      ride.paymentType == 'cash'
                          ? Icons.money
                          : Icons.account_balance_wallet,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                      size: 18.r,
                    ),
                    6.pw,
                    Text(
                      ride.paymentType == 'cash'
                          ? S.of(context).cash
                          : S.of(context).wallet,
                      style: Styles.textStyle14SemiBold(context).copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18.r),
                    6.pw,
                    Text(
                      "4.8", // Placeholder rating
                      style: Styles.textStyle14Bold(context),
                    ),
                  ],
                ),
              ],
            ),
            16.ph,
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => navigateTo(context, Routes.chatView,
                        extra: ChatViewArgs(
                            rideId: ride.id, driverName: ride.driver?.name)),
                    icon: Icon(Icons.message,
                        color: Theme.of(context).colorScheme.onPrimary),
                    label: Text(S.of(context).message,
                        style: Styles.textStyle16Bold(context).copyWith(
                            color: Theme.of(context).colorScheme.onPrimary)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),
                ),
                12.pw,
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        makePhoneCall(phoneNumber: ride.driver?.phone ?? ''),
                    icon: Icon(Icons.phone,
                        color: Theme.of(context).colorScheme.onPrimary),
                    label: Text(S.of(context).call,
                        style: Styles.textStyle16Bold(context).copyWith(
                            color: Theme.of(context).colorScheme.onPrimary)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
