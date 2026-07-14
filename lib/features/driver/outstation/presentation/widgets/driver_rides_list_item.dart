import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_cubit.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_state.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/route_args.dart';

import 'main_card.dart';

class DriverRidesListItem extends StatefulWidget {
  const DriverRidesListItem({
    super.key,
    required this.ride,
    this.isOutstation = false,
    this.isNew = false,
    this.showDetailsButton = true,
    this.showDismissButton = true,
  });

  final NewRideDataEntity ride;
  final bool isOutstation;
  final bool isNew;
  final bool showDetailsButton;
  final bool showDismissButton;

  @override
  State<DriverRidesListItem> createState() => _DriverRidesListItemState();
}

class _DriverRidesListItemState extends State<DriverRidesListItem> {
  bool _isWaiting = false;

  @override
  Widget build(BuildContext context) {
    final rideCubit = context.read<RideCubit>();
    final rideState = context.watch<RideCubit>().state;

    final bool isAnyActionLoading =
        rideState.actionStatus == RideActionStatus.loading;

    // نقرأ السعر الحالي من الـ state المشترك – مش local state
    final double currentAmount = rideState.currentAmounts[widget.ride.id] ??
        widget.ride.amount.toDouble();

    return BlocListener<RideCubit, RideState>(
      listenWhen: (previous, current) {
        return previous.actionStatus != current.actionStatus ||
            previous.actionOrderId != current.actionOrderId;
      },
      listener: (context, state) {
        if (state.actionStatus == RideActionStatus.loading &&
            state.actionOrderId == widget.ride.id) {
          if (!_isWaiting) setState(() => _isWaiting = true);
        }

        if ((state.actionStatus == RideActionStatus.error ||
                state.actionStatus == RideActionStatus.success) &&
            state.actionOrderId == widget.ride.id) {
          if (_isWaiting) setState(() => _isWaiting = false);
        }

        if (state.actionStatus == RideActionStatus.success &&
            state.actionOrderId == widget.ride.id) {
          final bool exists = state.rides.any((r) => r.id == widget.ride.id);
          if (exists) {
            final currentRideInState = state.rides.firstWhere((r) => r.id == widget.ride.id);
            final bool isTripActive = currentRideInState.status == 'accepted' ||
                currentRideInState.status == 'assigned' ||
                currentRideInState.status == 'driver_on_a_way' ||
                currentRideInState.status == 'arrived' ||
                currentRideInState.status == 'started' ||
                currentRideInState.status == 'on_trip';
                
            if (isTripActive) {
              debugPrint("🚀 RideCubit: Trip is active for ride ${widget.ride.id}, navigating to trip map view.");
              navigateTo(
                context,
                Routes.tripMapView,
                extra: TripMapArgs(ride: currentRideInState),
              );
            }
          }
        }
      },
      child: MainCard(
        ride: widget.ride,
        isNew: widget.isNew,
        isOutstation: widget.isOutstation,
        currentAmount: currentAmount,
        negotiationSettings: rideState.negotiationSettings,
        isAnyActionLoading: isAnyActionLoading,
        isOfferPending: rideState.pendingOffers.contains(widget.ride.id),
        showDetailsButton: widget.showDetailsButton,
        showDismissButton: widget.showDismissButton,
        onBid: (delta) {
          final base = widget.ride.amount.toDouble();
          // ✅ الزيادة دايماً تتحسب من السعر الأصلي مش من السعر الحالي
          // مثال: base=120, delta=+40 → 160 (مش 140+40=180)
          double newAmount = base + delta;
          // لا تنزل عن السعر الأصلي
          if (newAmount < base) newAmount = base;
          rideCubit.updateAmount(widget.ride.id, newAmount);
        },
        onPrimaryAction: () {
          if (isAnyActionLoading) return;

          final status = widget.ride.status;
          if (status == 'accepted' ||
              status == 'assigned' ||
              status == 'driver_on_a_way') {
            rideCubit.arriveRide(widget.ride.id);
          } else if (status == 'arrived') {
            rideCubit.startRide(widget.ride.id);
          } else if (status == 'started' || status == 'on_trip') {
            rideCubit.completeRide(widget.ride.id);
          } else {
            final base = widget.ride.amount.toDouble();
            if (currentAmount == base) {
              rideCubit.acceptRide(widget.ride.id);
            } else {
              rideCubit.counterOffer(widget.ride.id, currentAmount);
            }
          }
        },
        onDismiss: () => rideCubit.dismissRide(widget.ride.id),
        onCancelOffer: () {
          // عند الإلغاء نرجع السعر لأصله في الـ state
          rideCubit.updateAmount(widget.ride.id, widget.ride.amount.toDouble());
          rideCubit.cancelOffer(widget.ride.id);
        },
        onCancelTrip: () {
          rideCubit.cancelRide(widget.ride.id);
        },
        isOtpVerified: rideState.verifiedTripOtps.contains(widget.ride.id),
        onVerifyOtp: (otp) {
          rideCubit.verifyPickupOtp(widget.ride.id, otp);
        },
        isDeliveryOtpVerified: rideState.verifiedDeliveryOtps.contains(widget.ride.id),
        onVerifyDeliveryOtp: (otp) {
          rideCubit.verifyDeliveryOtp(widget.ride.id, otp);
        },
      ),
    );
  }
}
