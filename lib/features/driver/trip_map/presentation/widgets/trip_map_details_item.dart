import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_divider.dart';
import 'package:shakshak/core/utils/styles.dart';

import 'package:shakshak/core/utils/shared_widgets/ride_destination_widget.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';
import 'package:url_launcher/url_launcher.dart';

class TripMapDetailsItem extends StatefulWidget {
  const TripMapDetailsItem({super.key, required this.ride});

  final NewRideData ride;

  @override
  State<TripMapDetailsItem> createState() => _TripMapDetailsItemState();
}

class _TripMapDetailsItemState extends State<TripMapDetailsItem> {
  final ExpandableController expandableController = ExpandableController();

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      controller: expandableController,
      theme: ExpandableThemeData(
        hasIcon: false,
        iconColor: Styles.getPrimaryColor(context),
        tapBodyToExpand: false,
        tapBodyToCollapse: false,
        tapHeaderToExpand: false,
        iconSize: 26.r,
      ),
      expanded: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
            boxShadow: AppConstant.shadow,
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r)),
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  expandableController.expanded =
                      !expandableController.expanded;
                });
              },
              icon: Icon(
                expandableController.expanded == false
                    ? Icons.keyboard_double_arrow_down
                    : Icons.keyboard_double_arrow_up,
                color: Styles.getPrimaryColor(context),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 50.r,
                  height: 50.r,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreyColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.ride.user.name,
                        style: Styles.textStyle16SemiBold(context),
                      ),
                      Text(
                        '${widget.ride.amount} ${S.of(context).currency}',
                        style: Styles.textStyle16SemiBold(context),
                      ),
                    ],
                  ),
                ),
                12.pw,
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 16.r,
                    ),
                    4.pw,
                    Text(
                      '${widget.ride.distance.toString()} ${widget.ride.distanceType} (بعيد عنك)',
                      style: Styles.textStyle14SemiBold(context).copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
              ],
            ),
            12.ph,
          ],
        ),
      ),
      collapsed: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
            boxShadow: AppConstant.shadow,
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r)),
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  expandableController.expanded =
                      !expandableController.expanded;
                });
              },
              icon: Icon(
                expandableController.expanded == false
                    ? Icons.keyboard_double_arrow_down
                    : Icons.keyboard_double_arrow_up,
                color: Styles.getPrimaryColor(context),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 50.r,
                  height: 50.r,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreyColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.ride.user.name,
                        style: Styles.textStyle16SemiBold(context),
                      ),
                      Text(
                        '${widget.ride.amount} ${S.of(context).currency}',
                        style: Styles.textStyle16SemiBold(context),
                      ),
                    ],
                  ),
                ),
                12.pw,
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 16.r,
                    ),
                    4.pw,
                    Text(
                      '${widget.ride.distance} ${widget.ride.distanceType} (بعيد عنك)',
                      style: Styles.textStyle14SemiBold(context).copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
              ],
            ),
            CustomDivider(),
            RideDestinationWidget(
              from: widget.ride.sourceAddress,
              to: widget.ride.destinationAddress,
            ),
            20.ph,
            20.ph,
            // --- Static Bidding Buttons ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBidButton(context, '-5'),
                _buildBidButton(context, '+5'),
                _buildBidButton(context, '+10'),
                _buildBidButton(context, '+20'),
              ],
            ),
            16.ph,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: S.of(context).accept,
                    onTap: () {
                      _handleStatusUpdate();
                    },
                    height: 55.h,
                    borderRadius: 16.r,
                  ),
                ),
                12.pw,
                Container(
                  height: 55.h,
                  width: 55.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final url =
                          'https://www.google.com/maps/dir/?api=1&origin=${widget.ride.sourceLat},${widget.ride.sourceLong}&destination=${widget.ride.destinationLat},${widget.ride.destinationLong}&travelmode=driving';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: Icon(Icons.navigation,
                        color: Styles.getPrimaryColor(context)),
                  ),
                ),
              ],
            ),
            12.ph,
          ],
        ),
      ),
    );
  }

  void _handleStatusUpdate() {
    // TODO: Connect to backend endpoints
    // This will be linked to the endpoints provided by the user
  }

  Widget _buildBidButton(BuildContext context, String label) {
    return Container(
      width: 50.w,
      height: 50.h,
      decoration: BoxDecoration(
        border: Border.all(color: Styles.getPrimaryColor(context)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            // TODO: Implement bidding logic
          },
          child: Center(
            child: Text(
              label,
              style: Styles.textStyle14Bold(context)
                  .copyWith(color: Styles.getPrimaryColor(context)),
            ),
          ),
        ),
      ),
    );
  }
}
