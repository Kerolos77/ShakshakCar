import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/services/google_maps_service.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_cached_network_image.dart';
import 'package:shakshak/core/utils/shared_widgets/ride_destination_widget.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';
import 'package:shakshak/generated/l10n.dart';

class TripSummaryView extends StatefulWidget {
  final NewRideData ride;

  const TripSummaryView({super.key, required this.ride});

  @override
  State<TripSummaryView> createState() => _TripSummaryViewState();
}

class _TripSummaryViewState extends State<TripSummaryView> {
  final GoogleMapsService _mapsService = GoogleMapsService();
  GoogleMapController? _mapController;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  bool _isLoadingMap = true;
  bool _isExpanded = false;
  bool _isRatedLocally = false;
  double _currentSelectedRating = 0;
  String? _localComment;

  void _attemptFitMapBounds() {
    if (_mapController != null && !_isLoadingMap) {
      final pickup = LatLng(widget.ride.sourceLat, widget.ride.sourceLong);
      final dropoff =
          LatLng(widget.ride.destinationLat, widget.ride.destinationLong);
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          _boundsFromLatLngList([pickup, dropoff]),
          30.0,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initMapData();
  }

  Future<void> _initMapData() async {
    final pickup = LatLng(widget.ride.sourceLat, widget.ride.sourceLong);
    final dropoff =
        LatLng(widget.ride.destinationLat, widget.ride.destinationLong);

    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: pickup,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('dropoff'),
        position: dropoff,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    final route = await _mapsService.fetchRoute(start: pickup, end: dropoff);
    if (route != null && mounted) {
      setState(() {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('trip_route'),
            points: route.polylinePoints,
            color: AppColors.primaryColor,
            width: 5,
          ),
        );
        _isLoadingMap = false;
      });
      _attemptFitMapBounds();
    } else if (mounted) {
      setState(() {
        _isLoadingMap = false;
      });
    }
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null || x0 > latLng.latitude) x0 = latLng.latitude;
      if (x1 == null || x1 < latLng.latitude) x1 = latLng.latitude;
      if (y0 == null || y0 > latLng.longitude) y0 = latLng.longitude;
      if (y1 == null || y1 < latLng.longitude) y1 = latLng.longitude;
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  String _getPlaceName(String address) {
    if (address.isEmpty) return "...";
    final parts = address.split(',');
    if (parts.isNotEmpty && parts[0].trim().isNotEmpty) {
      return parts[0].trim();
    }
    return address;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bool isCash = widget.ride.paymentType.toLowerCase() == 'cash';
    final double cashToPay = widget.ride.paymentDetails?.cashPaid ??
        (isCash ? widget.ride.amount : 0.0);
    final double walletPaid = widget.ride.paymentDetails?.walletPaid ?? 0.0;

    return BaseLayoutView(
      title: S.of(context).tripSummary,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.ride.status.toLowerCase() == 'canceled') ...[
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                  margin: EdgeInsets.only(bottom: 24.h),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cancel_rounded, color: Colors.red, size: 24.r),
                      12.pw,
                      Expanded(
                        child: Text(
                          S.of(context).statusCanceled,
                          style: Styles.textStyle14Bold(context)
                              .copyWith(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // 1. Payment Details (Top Priority)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryColor.withOpacity(0.1)
                      : AppColors.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      cashToPay > 0
                          ? (AppConstant.currentLanguage == 'ar'
                              ? "المطلوب سداده للسائق (نقداً)"
                              : "Amount to pay to the driver (Cash)")
                          : (AppConstant.currentLanguage == 'ar'
                              ? "المبلغ المدفوع بالكامل"
                              : "Total amount paid"),
                      style: Styles.textStyle14SemiBold(context).copyWith(
                          color: isDark
                              ? Colors.white70
                              : AppColors.darkGreyColor),
                    ),
                    8.ph,
                    Text(
                      "$cashToPay ${S.of(context).currency}",
                      style: TextStyle(
                        fontSize: 34.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    if (walletPaid > 0) ...[
                      16.ph,
                      Divider(
                        color: isDark ? Colors.white24 : Colors.grey[300],
                      ),
                      12.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppConstant.currentLanguage == 'ar'
                                ? "إجمالي الرحلة:"
                                : "Total Trip Fare:",
                            style: Styles.textStyle12Medium(context),
                          ),
                          Text("${widget.ride.amount} ${S.of(context).currency}",
                              style: Styles.textStyle12Bold(context)),
                        ],
                      ),
                      8.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppConstant.currentLanguage == 'ar'
                                ? "تم خصمه من المحفظة:"
                                : "Paid from Wallet:",
                            style: Styles.textStyle12Medium(context),
                          ),
                          Text("$walletPaid ${S.of(context).currency}",
                              style: Styles.textStyle12Bold(context)
                                  .copyWith(color: Colors.green)),
                        ],
                      ),
                    ]
                  ],
                ),
              ),

              24.ph,

              // 2. Map & Expandable Trip Details
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: AppConstant.shadow,
                ),
                child: Column(
                  children: [
                    // Static Map
                    Container(
                      height: 150.h,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16.r)),
                      ),
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(widget.ride.sourceLat,
                                  widget.ride.sourceLong),
                              zoom: 14,
                            ),
                            onMapCreated: (controller) {
                              _mapController = controller;
                              _attemptFitMapBounds();
                            },
                            polylines: _polylines,
                            markers: _markers,
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            scrollGesturesEnabled: false,
                            tiltGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                          ),
                          if (_isLoadingMap)
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                    // Expandable Details (from TripCard)
                    Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () =>
                                setState(() => _isExpanded = !_isExpanded),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _isExpanded
                                          ? S.of(context).hideDetails
                                          : S.of(context).showDetails,
                                      style: Styles.textStyle12SemiBold(context)
                                          .copyWith(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    Icon(
                                      _isExpanded
                                          ? Icons.keyboard_arrow_up_rounded
                                          : Icons.keyboard_arrow_down_rounded,
                                      color: AppColors.primaryColor,
                                      size: 16.r,
                                    ),
                                  ],
                                ),
                                8.pw,
                                Expanded(
                                  child: !_isExpanded
                                      ? Text(
                                          "${_getPlaceName(widget.ride.sourceAddress)} ➔ ${_getPlaceName(widget.ride.destinationAddress)}",
                                          textAlign: TextAlign.end,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Styles.textStyle10SemiBold(
                                                  context)
                                              .copyWith(
                                            color: Theme.of(context).hintColor,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                          AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Padding(
                              padding: EdgeInsets.only(top: 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 16.r,
                                        width: 16.r,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              width: 2),
                                        ),
                                      ),
                                      8.pw,
                                      Expanded(
                                        child: Text(
                                          widget.ride.sourceAddress,
                                          style:
                                              Styles.textStyle12Medium(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      height: 15.h,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4.w),
                                      child: const VerticalDivider()),
                                  Row(
                                    children: [
                                      Container(
                                        height: 16.r,
                                        width: 16.r,
                                        padding: EdgeInsets.all(1.r),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .dividerColor,
                                              width: 2),
                                        ),
                                        child: Icon(Icons.place,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            size: 10.r),
                                      ),
                                      8.pw,
                                      Expanded(
                                        child: Text(
                                          widget.ride.destinationAddress,
                                          style:
                                              Styles.textStyle12Medium(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            crossFadeState: _isExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 300),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Driver Information (Smaller and sleeker)
              if (widget.ride.driver != null) ...[
                24.ph,
                Text(
                  S.of(context).driverDetails,
                  style: Styles.textStyle14Bold(context),
                ),
                8.ph,
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: AppConstant.shadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: CustomCachedNetworkImage(
                          imgUrl: widget.ride.driver!.image,
                          width: 45.r,
                          height: 45.r,
                          errorIconSize: 20.r,
                        ),
                      ),
                      12.pw,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.ride.driver!.name,
                              style: Styles.textStyle14SemiBold(context),
                            ),
                            if (widget.ride.carBrand?.isNotEmpty == true)
                              Text(
                                '${widget.ride.carBrand} ${widget.ride.carModel ?? ''}',
                                style:
                                    Styles.textStyle12Medium(context).copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (widget.ride.carPlate?.isNotEmpty == true)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            widget.ride.carPlate!,
                            style: Styles.textStyle12Bold(context)
                                .copyWith(color: Colors.black87),
                          ),
                        ),
                    ],
                  ),
                ),
              ],

              // 4. Rating Section
              if (widget.ride.status.toLowerCase() != 'canceled') ...[
                32.ph,
                Center(
                  child: Column(
                    children: [
                      Text(
                        (widget.ride.hasReview || _isRatedLocally)
                            ? S.of(context).doneSuccessfully
                            : S.of(context).rateYourExperience,
                        style: Styles.textStyle14SemiBold(context).copyWith(
                          color: (widget.ride.hasReview || _isRatedLocally)
                              ? AppColors.primaryColor
                              : null,
                        ),
                      ),
                      8.ph,
                      RatingBar.builder(
                        initialRating:
                            (widget.ride.hasReview && !_isRatedLocally)
                                ? 5.0
                                : _currentSelectedRating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        ignoreGestures:
                            widget.ride.hasReview || _isRatedLocally,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0.w),
                        itemSize: 35.r,
                        unratedColor: isDark ? Colors.grey[700] : Colors.grey[300],
                        itemBuilder: (context, _) => const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) async {
                          _currentSelectedRating = rating;
                          final result =
                              await context.push<Map<String, dynamic>>(
                            Routes.reviewView,
                            extra: ReviewViewArgs(
                              orderId: widget.ride.id,
                              isDriver: false,
                              initialRating: _currentSelectedRating,
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              _isRatedLocally = true;
                              _currentSelectedRating =
                                  result['rating'] as double? ??
                                      _currentSelectedRating;
                              _localComment = result['comment'] as String?;
                            });

                            if (context.mounted) {
                              showSnackBar(
                                context,
                                result['msg'] as String? ??
                                    S.of(context).doneSuccessfully,
                                S.of(context).doneSuccessfully,
                                Theme.of(context).primaryColor,
                                ContentType.success,
                              );
                            }
                          }
                        },
                      ),
                      if (_isRatedLocally &&
                          _localComment != null &&
                          _localComment!.isNotEmpty) ...[
                        16.ph,
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                                color: isDark
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!),
                          ),
                          child: Text(
                            _localComment!,
                            style: Styles.textStyle12Medium(context).copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              
              // Need Help Support Button
              32.ph,
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    // Navigate to support or contact us
                  },
                  icon:
                      Icon(Icons.help_outline_rounded, color: Colors.grey[600]),
                  label: Text(
                    S.of(context).support,
                    style: Styles.textStyle14SemiBold(context)
                        .copyWith(color: Colors.grey[700]),
                  ),
                ),
              ),
              24.ph,
            ],
          ),
        ),
      ),
    );
  }
}
