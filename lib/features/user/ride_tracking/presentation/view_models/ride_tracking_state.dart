part of 'ride_tracking_cubit.dart';

@immutable
sealed class RideTrackingState {}

final class RideTrackingInitial extends RideTrackingState {}

final class RideTrackingLoading extends RideTrackingState {}

final class RideTrackingError extends RideTrackingState {
  final String message;

  RideTrackingError(this.message);
}

final class RideTrackingPaymentProcessing extends RideTrackingState {
  final NewRideDataEntity ride;
  final String status; // 'user_accept_offer' or 'payment_pending'
  RideTrackingPaymentProcessing({required this.ride, required this.status});
}

final class TestRideTracking extends RideTrackingState {
  final String status;

  TestRideTracking({required this.status});
}

final class RideTrackingPaymentFailed extends RideTrackingState {
  final NewRideDataEntity ride;
  final String? errorMessage;

  RideTrackingPaymentFailed({required this.ride, this.errorMessage});
}

final class RideTrackingAccepted extends RideTrackingState {
  final NewRideDataEntity ride;
  final LatLng driverLocation;
  final RouteData? driverToPickupData;
  final RouteData? pickupToDropoffData;

  final String? status;

  RideTrackingAccepted({
    required this.ride,
    required this.driverLocation,
    this.driverToPickupData,
    this.pickupToDropoffData,
    this.status,
  });
}

final class RideTrackingArrived extends RideTrackingState {
  final NewRideDataEntity ride;
  final LatLng driverLocation;
  final RouteData? pickupToDropoffData;

  RideTrackingArrived({
    required this.ride,
    required this.driverLocation,
    this.pickupToDropoffData,
  });
}

final class RideTrackingStarted extends RideTrackingState {
  final NewRideDataEntity ride;
  final LatLng driverLocation;
  final RouteData? pickupToDropoffData;
  final RouteData? driverToDestinationData;

  final String? status;

  RideTrackingStarted({
    required this.ride,
    required this.driverLocation,
    this.pickupToDropoffData,
    this.driverToDestinationData,
    this.status,
  });
}

final class RideTrackingOnTrip extends RideTrackingState {
  final NewRideDataEntity ride;
  final LatLng driverLocation;
  final RouteData? pickupToDropoffData;
  final RouteData? driverToDestinationData;

  RideTrackingOnTrip({
    required this.ride,
    required this.driverLocation,
    this.pickupToDropoffData,
    this.driverToDestinationData,
  });
}

final class RideTrackingEnded extends RideTrackingState {
  final NewRideDataEntity ride;
  final String status;

  RideTrackingEnded({required this.ride, required this.status});
}
