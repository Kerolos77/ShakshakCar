import 'package:shakshak/features/user/ride_tracking/presentation/view_models/ride_tracking_cubit.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';

class OtpRouteArgs {
  final String phoneNumber;

  OtpRouteArgs({required this.phoneNumber});
}

class RegisterRouteArgs {
  final String phoneNumber;

  RegisterRouteArgs({required this.phoneNumber});
}

class PaymentViewArgs {
  final String paymentUrl;

  PaymentViewArgs({required this.paymentUrl});
}

class RidePaymentWebViewArgs {
  final String checkoutUrl;
  final int orderId;
  final bool isAddingCard;

  RidePaymentWebViewArgs({
    required this.checkoutUrl,
    required this.orderId,
    this.isAddingCard = false,
  });
}

class TripMapArgs {
  final NewRideDataEntity ride;

  TripMapArgs({required this.ride});
}

class DriveDetailsViewArgs {
  final NewRideDataEntity ride;
  final RideTrackingCubit? trackingCubit;

  DriveDetailsViewArgs({required this.ride, this.trackingCubit});
}

class OffersViewArgs {
  final NewRideDataEntity newRideData;

  OffersViewArgs({required this.newRideData});
}

// SelectDestinationArgs removed since we will just read UserHomeCubit from context.

// AddCardArgs removed; we'll provide PaymentCubit at the global level or within the widget where needed.

class BookRideArgs {
  final String? latParam;
  final String? lngParam;
  final String? googleMapsUrl;

  BookRideArgs({this.latParam, this.lngParam, this.googleMapsUrl});
}

class RidesViewArgs {
  final bool isSelectionMode;

  RidesViewArgs({this.isSelectionMode = false});
}

class ReviewViewArgs {
  final int orderId;
  final bool isDriver;
  final double initialRating;

  ReviewViewArgs({
    required this.orderId,
    this.isDriver = false,
    this.initialRating = 0.0,
  });
}

class ChatViewArgs {
  final int rideId;
  final String? driverName;

  ChatViewArgs({required this.rideId, this.driverName});
}
