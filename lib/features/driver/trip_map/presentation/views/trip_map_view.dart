import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';

import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';

import 'package:shakshak/core/utils/shared_widgets/destination_map.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_cubit.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_state.dart';
import 'package:shakshak/features/driver/outstation/presentation/widgets/driver_rides_list_item.dart';
import 'package:shakshak/core/utils/shared_widgets/sos_button.dart';
import 'package:shakshak/core/utils/styles.dart';

class TripMapView extends StatefulWidget {
  const TripMapView({super.key, required this.ride});

  final NewRideDataEntity ride;

  @override
  State<TripMapView> createState() => _TripMapViewState();
}

class _TripMapViewState extends State<TripMapView> {
  final Completer<GoogleMapController> mapCompleter =
      Completer<GoogleMapController>();
  late final RideCubit _rideCubit;

  @override
  void initState() {
    super.initState();
    _rideCubit = context.read<RideCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rideCubit.startTripLocationTracking();
    });
  }

  @override
  void dispose() {
    try {
      _rideCubit.stopTripLocationTracking();
    } catch (e) {
      debugPrint("Could not stop tracking in dispose: $e");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RideCubit, RideState>(
      listenWhen: (prev, curr) {
        return curr.actionOrderId == widget.ride.id &&
            prev.actionStatus != curr.actionStatus;
      },
      listener: (context, state) {
        if (state.actionStatus == RideActionStatus.success) {
          final hasRide = state.rides.any((r) => r.id == widget.ride.id);
          if (!hasRide) {
            debugPrint("TripMapView: Ride ${widget.ride.id} is no longer in active rides (completed or cancelled), popping back to home.");
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        }
      },
      child: BlocBuilder<RideCubit, RideState>(
        builder: (context, state) {
          // نجيب أحدث نسخة من الرحلة من الـ state (لو الـ Cubit الخارجي شغال)
          final updatedRide = state.rides.cast<NewRideDataEntity>().firstWhere(
                (r) => r.id == widget.ride.id,
                orElse: () => widget.ride,
              );
          final bool isNew = state.newRideIds.contains(updatedRide.id);

          // Determine instructions text based on trip status
          String instructionsHeader = "الذهاب لموقع العميل";
          String instructionsBody = updatedRide.sourceAddress;
          IconData navigationIcon = Icons.directions_car_rounded;

          if (updatedRide.status == 'arrived') {
            instructionsHeader = "وصلت للعميل";
            instructionsBody = "العميل في انتظارك الآن. قم ببدء الرحلة عند ركوبه.";
            navigationIcon = Icons.person_pin_circle_rounded;
          } else if (updatedRide.status == 'started' || updatedRide.status == 'on_trip') {
            instructionsHeader = "متجه للوجهة";
            instructionsBody = updatedRide.destinationAddress;
            navigationIcon = Icons.navigation_rounded;
          }

          return BaseLayoutView(
            horizontalPadding: 0,
            title: S.of(context).tripMap,
            body: Stack(
              alignment: Alignment.center,
              children: [
                // الخريطة
                DestinationMapWidget(
                  onCameraIdle: () {},
                  onCameraMove: (p0) {},
                  onCameraMoveStarted: () {},
                  onMapCreated: (p0) {
                    if (!mapCompleter.isCompleted) {
                      mapCompleter.complete(p0);
                    }
                  },
                  cubit: context.read<RideCubit>(),
                  start: LatLng(
                    updatedRide.sourceLat,
                    updatedRide.sourceLong,
                  ),
                  end: LatLng(
                    updatedRide.destinationLat,
                    updatedRide.destinationLong,
                  ),
                  cars: const [],
                  driverLocation: state.currentDriverLocation,
                ),

                // floating Navigation Directions HUD (at the top)
                Positioned(
                  top: 16.h,
                  left: 16.w,
                  right: 16.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
                          border: Border.all(
                            color: Theme.of(context).dividerColor.withOpacity(0.15),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: Styles.getPrimaryColor(context).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                navigationIcon,
                                color: Styles.getPrimaryColor(context),
                                size: 24.r,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    instructionsHeader,
                                    style: Styles.textStyle14Bold(context).copyWith(
                                      color: Styles.getPrimaryColor(context),
                                    ),
                                  ),
                                  Text(
                                    instructionsBody.isNotEmpty ? instructionsBody : "جاري تحديد المسار...",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Styles.textStyle12SemiBold(context),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Speedometer Floating circular HUD
                Positioned(
                  bottom: 230.h,
                  right: 16.w,
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: 70.r,
                        height: 70.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.75),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.currentSpeed.toInt().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              "كم/س",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Simulation Toggle Button
                Positioned(
                  bottom: 310.h,
                  right: 16.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: InkWell(
                        onTap: () {
                          final cubit = context.read<RideCubit>();
                          if (state.isSimulationActive) {
                            cubit.stopSimulation();
                            cubit.startTripLocationTracking();
                          } else {
                            final startLoc = state.currentDriverLocation ??
                                LatLng(updatedRide.sourceLat, updatedRide.sourceLong);
                            final bool isHeadingToCustomer =
                                updatedRide.status == 'pending' ||
                                updatedRide.status == 'accepted' ||
                                updatedRide.status == 'arrived';
                            final endLoc = isHeadingToCustomer
                                ? LatLng(updatedRide.sourceLat, updatedRide.sourceLong)
                                : LatLng(updatedRide.destinationLat, updatedRide.destinationLong);

                            cubit.startSimulation(startLoc, endLoc);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: state.isSimulationActive
                                ? Colors.red.withOpacity(0.85)
                                : Styles.getPrimaryColor(context).withOpacity(0.85),
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                state.isSimulationActive
                                  ? Icons.stop_rounded
                                  : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 18.r,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                state.isSimulationActive ? "إيقاف المحاكاة" : "محاكاة الحركة",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // نفس الكارد الخارجي بالكامل - إعادة استخدام 100%
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: DriverRidesListItem(
                      key: ValueKey(updatedRide.id),
                      ride: updatedRide,
                      isOutstation: updatedRide.parcelWeight != null,
                      isNew: isNew,
                      showDetailsButton: false,
                      showDismissButton: false,
                    ),
                  ),
                ),

                if (updatedRide.status == 'started' || updatedRide.status == 'on_trip')
                  Positioned(
                    bottom: 230.h,
                    left: 16.w,
                    child: const SOSButton(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
