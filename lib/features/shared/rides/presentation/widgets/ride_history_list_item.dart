import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';

import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/core/utils/shared_widgets/ride_destination_widget.dart';
import 'package:shakshak/core/utils/shared_widgets/sos_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_cancel_dialog.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RideHistoryListItem extends StatelessWidget {
  const RideHistoryListItem({
    super.key,
    required this.ride,
    this.isOutstation = false,
    this.isSelectionMode = false,
  });

  final NewRideData ride;
  final bool isOutstation;
  final bool isSelectionMode;

  @override
  Widget build(BuildContext context) {
    final bool isDriver = CacheHelper.getData(key: AppConstant.kIsDriver) == 1;

    return GestureDetector(
      onTap: () => _handleItemTap(context, isDriver),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          boxShadow: AppConstant.shadow,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAvatar(context, isDriver),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isDriver
                            ? ride.user.name
                            : (ride.driver?.name ?? S.of(context).searching),
                        style: Styles.textStyle16SemiBold(context),
                      ),
                      Text(
                        '${ride.amount} ${S.of(context).currency}',
                        style: Styles.textStyle16SemiBold(context).copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (ride.status == 'started') ...[
                  const SOSButton(),
                  8.pw,
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // City Tag
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        ride.interCity ? S.of(context).rides : S.of(context).outstationRides,
                        style: Styles.textStyle10(context).copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    4.ph,
                    // Status Tag
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(context, ride.status)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        _getLocalizedStatus(context, ride.status),
                        style: Styles.textStyle12(context).copyWith(
                          color: _getStatusColor(context, ride.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            12.ph,
            RideDestinationWidget(
              from: ride.sourceAddress,
              to: ride.destinationAddress,
            ),
            if (isOutstation) ...[
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${S.of(context).weight}: ${S.of(context).kgSuffix(ride.parcelWeight ?? '-')}',
                    style: Styles.textStyle14(context),
                  ),
                  Text(
                    '${S.of(context).dimension}: ${ride.parcelDimension ?? '-'}',
                    style: Styles.textStyle14(context),
                  ),
                ],
              ),
            ],
            // Action Buttons for Active Rides (User Only)
            if (!isDriver && _isRideActive(ride.status)) ...[
              16.ph,
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: S.of(context).cancelTrip,
                      buttonColor: Colors.red.withOpacity(0.1),
                      textColor: Colors.red,
                      height: 40.h,
                      onTap: () {
                        showCustomCancelDialog(
                          context: context,
                          onConfirm: () {
                            context.read<UserHomeCubit>().cancelOrder(orderId: ride.id);
                          },
                        );
                      },
                    ),
                  ),
                  12.pw,
                  Expanded(
                    child: CustomButton(
                      text: S.of(context).continueTrip,
                      height: 40.h,
                      onTap: () => _handleItemTap(context, isDriver),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleItemTap(BuildContext context, bool isDriver) {
    if (isSelectionMode) {
      navigateTo(context, Routes.tripIssueView, extra: ride);
      return;
    }
    if (isDriver) {
      navigateTo(context, Routes.tripMapView, extra: TripMapArgs(ride: ride));
    } else {
      // User Logic
      switch (ride.status.toLowerCase()) {
        case 'searching':
        case 'pending':
          navigateTo(context, Routes.offersView,
              extra: OffersViewArgs(newRideData: ride));
          break;
        case 'completed':
        case 'canceled':
          navigateTo(context, Routes.tripSummaryView, extra: ride);
          break;
        case 'started':
        case 'placed':
        case 'accepted':
        case 'driver_on_a_way':
        case 'arrived':
        case 'on_trip':
          navigateTo(context, Routes.driveDetailsView,
              extra: DriveDetailsViewArgs(ride: ride));
          break;
        default:
          break;
      }
    }
  }

  bool _isRideActive(String status) {
    final s = status.toLowerCase();
    return s != 'completed' && s != 'canceled';
  }

  Widget _buildAvatar(BuildContext context, bool isDriver) {
    String? imageUrl = isDriver ? ride.user.image : ride.driver?.image;
    return CircleAvatar(
      radius: 25.r,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      backgroundImage: imageUrl != null && imageUrl.isNotEmpty
          ? CachedNetworkImageProvider(imageUrl)
          : null,
      child: imageUrl == null || imageUrl.isEmpty
          ? Icon(Icons.person,
              color: Theme.of(context).hintColor.withOpacity(0.5),
              size: 30.r)
          : null,
    );
  }

  String _getLocalizedStatus(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'searching':
        return S.of(context).statusSearching;
      case 'completed':
        return S.of(context).statusCompleted;
      case 'canceled':
        return S.of(context).statusCanceled;
      case 'started':
        return S.of(context).statusStarted;
      case 'accepted':
        return S.of(context).statusAccepted;
      case 'placed':
        return S.of(context).statusPlaced;
      default:
        return status;
    }
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'searching':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'started':
      case 'accepted':
      case 'placed':
        return Colors.blue;
      default:
        return Theme.of(context).disabledColor;
    }
  }
}
