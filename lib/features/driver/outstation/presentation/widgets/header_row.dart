import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/converts.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_cubit.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_state.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';
import 'package:shakshak/generated/l10n.dart';

/// Header فيه: distance-from-you + paymentType + old price strike-through (لو عامل raise)
class HeaderRow extends StatelessWidget {
  const HeaderRow({
    super.key,
    required this.ride,
    required this.currentAmount,
    required this.onDismiss,
    this.showDismissButton = true,
  });

  final NewRideDataEntity ride;
  final double currentAmount;
  final VoidCallback onDismiss;
  final bool showDismissButton;

  @override
  Widget build(BuildContext context) {
    final baseAmount = ride.amount.toDouble();
    final showOld = currentAmount != baseAmount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Distance to pickup
        Expanded(
          child: Row(
            children: [
              Icon(Icons.directions_car,
                  size: 16.r, color: Styles.getPrimaryColor(context)),
              4.pw,
              BlocSelector<RideCubit, RideState, LatLng?>(
                selector: (_) =>
                    context.read<RideCubit>().currentDriverLocation,
                builder: (context, driverLocation) {
                  if (driverLocation == null) {
                    return Text("...", style: Styles.textStyle14Bold(context));
                  }
                  final dist = Converts.calculateDistanceKm(
                    driverLocation.latitude,
                    driverLocation.longitude,
                    ride.sourceLat,
                    ride.sourceLong,
                  );
                  return Text(
                    "${dist.toStringAsFixed(1)} KM",
                    style: Styles.textStyle14Bold(context).copyWith(
                      color: Styles.getPrimaryColor(context),
                    ),
                  );
                },
              ),
              8.pw,
              // Time of ride
              Row(
                children: [
                  Icon(Icons.access_time_filled,
                      size: 14.r,
                      color:
                          Theme.of(context).hintColor.withOpacity(0.6)),
                  4.pw,
                  Text(
                    DateFormat('hh:mm a').format(ride.createdAt),
                    style: Styles.textStyle12SemiBold(context).copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Payment + old price + Dismiss Button
        Row(
          children: [
            if (showOld)
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Text(
                  '${ride.amount}',
                  style: Styles.textStyle14Bold(context).copyWith(
                    color: Theme.of(context).hintColor,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                ride.paymentType.isNotEmpty
                    ? ride.paymentType.toUpperCase()
                    : S.of(context).cash.toUpperCase(),
                style: Styles.textStyle12Bold(context).copyWith(
                  color: Styles.getPrimaryColor(context),
                ),
              ),
            ),
            if (showDismissButton) ...[
              8.pw,
              // زر الحذف
              GestureDetector(
                onTap: onDismiss,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 18.r,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
