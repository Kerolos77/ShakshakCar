import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart' hide RouteData;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/services/google_maps_service.dart';
import 'package:shakshak/core/utils/shared_widgets/sos_button.dart';
import 'package:shakshak/core/utils/shared_widgets/map_utils.dart';
import 'package:shakshak/core/utils/shared_widgets/tracking_map.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/user/ride_tracking/presentation/view_models/ride_tracking_cubit.dart';
import 'package:shakshak/features/user/ride_tracking/presentation/widgets/trip_progress_tracker.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/drive_details_card.dart';
import 'package:shakshak/generated/l10n.dart';

import '../../../../../core/router/router_helper.dart';
import '../../../../../core/utils/shared_widgets/custom_cancel_dialog.dart';
import '../../../user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/book_ride/payment_method_widget.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/payment_cubit.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';

class RideTrackingView extends StatelessWidget {
  final NewRideDataEntity ride;

  const RideTrackingView({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    // ⚡ Check if RideTrackingCubit was already created upstream (e.g., from OffersView route).
    // If so, reuse it — this preserves real-time connections established before this screen opened.
    // If not (e.g., coming from a cold resume), create a new one.
    final existingCubit = context.read<RideTrackingCubit?>();
    if (existingCubit != null) {
      return BlocProvider.value(
        value: existingCubit,
        child: RideTrackingViewBody(ride: ride),
      );
    }
    return BlocProvider(
      create: (context) => RideTrackingCubit(ride: ride),
      child: RideTrackingViewBody(ride: ride),
    );
  }
}

class RideTrackingViewBody extends StatefulWidget {
  final NewRideDataEntity ride;

  const RideTrackingViewBody({super.key, required this.ride});

  @override
  State<RideTrackingViewBody> createState() => _RideTrackingViewBodyState();
}

class _RideTrackingViewBodyState extends State<RideTrackingViewBody> {
  bool _isMinimized = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RideTrackingCubit, RideTrackingState>(
      listener: (context, state) {
        if (state is RideTrackingEnded) {
          final message = state.status == 'completed'
              ? S.of(context).statusCompleted
              : S.of(context).statusCanceled;
          final color =
              state.status == 'completed' ? Colors.green : Colors.red;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: color,
            ),
          );

          context.read<UserHomeCubit>().clearActiveTrip();

          if (state.status == 'completed') {
            navigateAndFinish(context, Routes.tripSummaryView,
                extra: state.ride);
          } else {
            context.go(Routes.userHomeView);
          }
        }
      },
      child: BlocBuilder<RideTrackingCubit, RideTrackingState>(
        builder: (context, state) {
          if (state is RideTrackingInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is RideTrackingError) {
            return Scaffold(
              body: Center(child: Text(state.message)),
            );
          }
          
          NewRideDataEntity currentRide = widget.ride;
          if (state is RideTrackingPaymentProcessing) currentRide = state.ride;
          if (state is RideTrackingPaymentFailed) currentRide = state.ride;
          if (state is RideTrackingAccepted) currentRide = state.ride;
          if (state is RideTrackingArrived) currentRide = state.ride;
          if (state is RideTrackingStarted) currentRide = state.ride;
          if (state is RideTrackingOnTrip) currentRide = state.ride;
          if (state is RideTrackingEnded) currentRide = state.ride;

          bool isLoading = state is RideTrackingLoading;

          LatLng driverLoc = const LatLng(30.0444, 31.2357);
          RouteData? d2p;
          RouteData? p2d;
          RouteData? d2dest;

          if (state is RideTrackingAccepted) {
            driverLoc = state.driverLocation;
            d2p = state.driverToPickupData;
            p2d = state.pickupToDropoffData;
          } else if (state is RideTrackingArrived) {
            driverLoc = state.driverLocation;
            p2d = state.pickupToDropoffData;
          } else if (state is RideTrackingStarted ||
              state is RideTrackingOnTrip) {
            final s = state as dynamic;
            driverLoc = s.driverLocation;
            p2d = s.pickupToDropoffData;
            d2dest = s.driverToDestinationData;
          }

          final pickup = LatLng(currentRide.sourceLat, currentRide.sourceLong);
          final dropoff = LatLng(currentRide.destinationLat, currentRide.destinationLong);

          bool showOverlay = state is RideTrackingPaymentProcessing ||
              state is RideTrackingPaymentFailed;

          String? currentEta;
          if (d2p?.duration != null) {
            currentEta = d2p!.duration;
          } else if (d2dest?.duration != null) {
            currentEta = d2dest!.duration;
          }

          return BaseLayoutView(
            showAppBar: false,
            topPadding: 0,
            horizontalPadding: 0,
            body: Stack(
              children: [
                // 🗺️ Live Tracking Map
                if (!showOverlay)
                  Stack(
                    children: [
                      TrackingMapWidget(
                        driverLocation: driverLoc,
                        pickupLocation: pickup,
                        dropoffLocation: dropoff,
                        driverToPickupData: d2p,
                        pickupToDropoffData: p2d,
                        driverToDestinationData: d2dest,
                        onMapCreated: (controller) {},
                        onUserInteraction: () {
                          if (!_isMinimized) {
                            setState(() => _isMinimized = true);
                          }
                        },
                        carColor: MapUtils.parseHexColor(currentRide.carColor),
                        isMotorcycle: _isMotorcycle(currentRide),
                      ),
                      if (isLoading)
                        Container(
                          color: Colors.black.withOpacity(0.1),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),

                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).padding.top + 60.h,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: MediaQuery.of(context).padding.top + 5.h,
                  left: 0,
                  right: 0,
                  child: FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: TripProgressTracker(
                      status: _getStatusFromState(state),
                      eta: currentEta,
                    ),
                  ),
                ),

                // 📦 Minimizeable Bottom UI
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  bottom: _isMinimized ? -400.h : 25.h,
                  left: 15.w,
                  right: 15.w,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: !showOverlay
                        ? Column(
                            key: ValueKey(_getStatusFromState(state)),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FadeInUp(
                                duration: const Duration(milliseconds: 600),
                                child: Stack(
                                  children: [
                                    DriveDetailsCard(ride: currentRide),
                                    if (isLoading)
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(20.r),
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (_canCancelStatus(
                                  _getStatusFromState(state))) ...[
                                10.ph,
                                FadeInUp(
                                  duration: const Duration(milliseconds: 700),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          _showCancelDialog(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                        ),
                                        elevation: 5,
                                      ),
                                      child: Text(
                                        S.of(context).cancelTrip,
                                        style: Styles.textStyle16Bold(context)
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ),

                // ⬆️ Restore Arrow Button
                if (_isMinimized)
                  Positioned(
                    bottom: 30.h,
                    right: 20.w,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 300),
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: AppColors.primaryColor,
                        onPressed: () => setState(() => _isMinimized = false),
                        child: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 30),
                      ),
                    ),
                  ),

                if (!showOverlay &&
                    (state is RideTrackingArrived ||
                        state is RideTrackingStarted ||
                        state is RideTrackingOnTrip ||
                        currentRide.status == 'started' ||
                        currentRide.status == 'arrived'))
                  Positioned(
                    top: 130.h,
                    right: 20.w,
                    child: FadeInRight(
                      duration: const Duration(milliseconds: 500),
                      child: const SOSButton(),
                    ),
                  ),

                if (state is RideTrackingPaymentProcessing)
                  _StatusOverlay(
                    title: S.of(context).processingPayment,
                    icon: SpinKitRipple(
                      color: AppColors.primaryColor,
                      size: 100.r,
                    ),
                    onCancel: () => _showCancelDialog(context),
                  ),

                if (state is RideTrackingPaymentFailed)
                  _StatusOverlay(
                    title: S.of(context).paymentFailed,
                    subtitle: S.of(context).paymentFailedMsg,
                    icon: Icon(
                      Icons.error_outline_rounded,
                      color: Colors.redAccent,
                      size: 80.r,
                    ),
                    action: ElevatedButton(
                      onPressed: () {
                        PaymentMethodWidget.showPaymentBottomSheet(
                          context: context,
                          selectedPaymentMethod: currentRide.paymentType,
                          onPaymentChanged: (newPaymentMethod) {
                            context.read<RideTrackingCubit>().resolvePayment(newPaymentMethod);
                          },
                          useWallet: currentRide.paymentType == 'wallet',
                          onWalletToggled: (useWallet) {
                            // Optionally handle wallet toggle if your logic allows mixed payment here
                            if (useWallet) {
                              context.read<RideTrackingCubit>().resolvePayment('wallet');
                            }
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.w, vertical: 15.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r)),
                      ),
                      child: Text(
                        S.of(context).changePaymentMethod,
                        style: Styles.textStyle16Bold(context)
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    onCancel: () => _showCancelDialog(context),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _isMotorcycle(NewRideDataEntity ride) {
    // بناءً على طلبك بجعل الموتوسيكل هو الأساسي بدلاً من السيارة
    return true; 
  }

  bool _canCancelStatus(String status) {
    return status != 'arrived' &&
        status != 'on_trip' &&
        status != 'started' &&
        status.isNotEmpty;
  }

  void _showCancelDialog(BuildContext context) {
    showCustomCancelDialog(
      context: context,
      onConfirm: () {
        context.read<RideTrackingCubit>().cancelRide();
      },
    );
  }

  String _getStatusFromState(RideTrackingState state) {
    if (state is RideTrackingPaymentProcessing) return state.status;
    if (state is RideTrackingPaymentFailed) return 'payment_failed';
    if (state is RideTrackingAccepted) return state.status ?? 'assigned';
    if (state is RideTrackingArrived) return 'arrived';
    if (state is RideTrackingStarted) return state.status ?? 'started';
    if (state is RideTrackingOnTrip) return 'on_trip';
    if (widget.ride.status.isNotEmpty) return widget.ride.status;
    return '';
  }
}

class _StatusOverlay extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget icon;
  final Widget? action;
  final VoidCallback? onCancel;

  const _StatusOverlay({
    required this.title,
    this.subtitle,
    required this.icon,
    this.action,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: FadeIn(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            color: Colors.black.withOpacity(0.4),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon,
                    30.ph,
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Styles.textStyle22Bold(context)
                          .copyWith(color: Colors.white),
                    ),
                    if (subtitle != null) ...[
                      15.ph,
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: Styles.textStyle16SemiBold(context)
                            .copyWith(color: Colors.white.withOpacity(0.8)),
                      ),
                    ],
                    if (action != null) ...[
                      40.ph,
                      action!,
                    ],
                    if (onCancel != null) ...[
                      20.ph,
                      TextButton(
                        onPressed: onCancel,
                        child: Text(
                          S.of(context).cancel,
                          style: Styles.textStyle16SemiBold(context)
                              .copyWith(color: Colors.white70),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
