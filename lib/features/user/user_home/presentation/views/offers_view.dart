import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/features/user/ride_tracking/presentation/view_models/ride_tracking_cubit.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_state.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/offers_list.dart';

import '../../data/models/trip_offer_model.dart';
import '../widgets/map_loading_widget.dart';
import '../widgets/trip_card.dart';

class OffersView extends StatefulWidget {
  final NewRideDataEntity newRideData;

  const OffersView({
    super.key,
    required this.newRideData,
  });

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> {
  final Completer<GoogleMapController> mapCompleter =
      Completer<GoogleMapController>();
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // 📡 UserHomeCubit: handles offer accepted → navigate to DriveDetails
        BlocListener<UserHomeCubit, UserHomeState>(
          listener: (context, state) {
            if (state is TripStatusChanged) {
              if (state.status == 'assigned') {
                context.push(
                  Routes.driveDetailsView,
                  extra: DriveDetailsViewArgs(
                    ride: state.tripModel,
                    trackingCubit: context.read<RideTrackingCubit>(),
                  ),
                );
              }
            }
          },
        ),
        // ⚡ RideTrackingCubit: handles direct status changes (payment, driver ready, etc.)
        BlocListener<RideTrackingCubit, RideTrackingState>(
          listener: (context, state) {
            if (state is RideTrackingAccepted) {
              // Only navigate when driver is ACTUALLY assigned - not for pending trips
              final status = state.status ?? '';
              if (status == 'assigned' || status == 'driver_on_a_way' || status == 'payment_paid') {
                context.push(
                  Routes.driveDetailsView,
                  extra: DriveDetailsViewArgs(
                    ride: state.ride,
                    trackingCubit: context.read<RideTrackingCubit>(),
                  ),
                );
              }
            } else if (state is RideTrackingEnded) {
              // Ride ended (canceled) while waiting for offers
              context.go(Routes.userHomeView);
            }
          },
        ),
      ],
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.userHomeView);
            }
          },
          child: Scaffold(
            body: Stack(
              children: [
                // 1. Background Map Layer
                MapWithLoadingOverlay(
                  locationCubit: context.read<LocationCubit>(),
                  onMapCreated: onMapCreated,
                ),

                // 2. Top Shadow for Status Bar clarity
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 100.h,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Back Button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10.h,
                  left: 16.w,
                  child: CircleAvatar(
                    radius: 20.r,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, size: 20.r),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(Routes.userHomeView);
                        }
                      },
                    ),
                  ),
                ),

                // 3. Draggable Sheet for Offers and Trip Info
                DraggableScrollableSheet(
                  initialChildSize: 0.75,
                  minChildSize: 0.2,
                  maxChildSize: 0.9,
                  builder: (context, scrollController) {
                    return Container(
                      padding: EdgeInsets.only(top: 12.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32.r),
                          topRight: Radius.circular(32.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Handle bar for Draggable sheet
                          Center(
                            child: Container(
                              width: 40.w,
                              height: 5.h,
                              decoration: BoxDecoration(
                                color: Theme.of(context).dividerColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          ),
                          8.ph,
                          // Scrollable Content
                          Expanded(
                            child: BlocBuilder<UserHomeCubit, UserHomeState>(
                              buildWhen: (previous, current) =>
                                  current is OffersUpdated ||
                                  current is AcceptOfferLoading ||
                                  current is AcceptOfferSuccess ||
                                  current is AcceptOfferFailure ||
                                  current is TripRealtimeConnected,
                              builder: (context, state) {
                                final List<TripOfferModel> offers =
                                    (state is OffersUpdated)
                                        ? state.offers
                                        : context.read<UserHomeCubit>().offers;

                                return CustomScrollView(
                                  controller: scrollController,
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w),
                                        child: TripCard(
                                            newRideData: widget.newRideData),
                                      ),
                                    ),
                                    OffersList(
                                      offers: offers,
                                      originalRideData: widget.newRideData,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    mapCompleter.complete(controller);
    mapController = controller;
  }
}
