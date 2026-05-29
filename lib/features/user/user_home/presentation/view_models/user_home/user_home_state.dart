import 'package:flutter/cupertino.dart';

import 'package:shakshak/features/shared/rides/data/models/rides_model.dart';
import 'package:shakshak/features/user/user_home/domain/entities/accept_offer_entity.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';
import 'package:shakshak/features/user/user_home/data/models/services_deteles_model.dart';
import 'package:shakshak/features/user/user_home/domain/entities/services_entity.dart';
import 'package:shakshak/features/user/user_home/data/models/trip_offer_model.dart';
import 'package:shakshak/features/user/user_home/domain/entities/user_home_caption_entity.dart';

@immutable
sealed class UserHomeState {}

final class UserHomeInitial extends UserHomeState {}

extension UserHomeStateX on UserHomeState {
  bool get isActionLoading =>
      this is AcceptOfferLoading ||
      this is DenyOfferLoading ||
      this is CancelOrderLoading;
}

final class UserHomeCaptionLoading extends UserHomeState {}

final class UserHomeCaptionSuccess extends UserHomeState {
  final UserHomeCaptionEntity userHomeCaptionModel;

  UserHomeCaptionSuccess({required this.userHomeCaptionModel});
}

final class UserHomeCaptionFailure extends UserHomeState {
  final String errorMessage;

  UserHomeCaptionFailure({required this.errorMessage});
}

final class ServicesLoading extends UserHomeState {}

final class ServicesSuccess extends UserHomeState {
  final ServicesEntity servicesModel;

  ServicesSuccess({required this.servicesModel});
}

final class ServicesFailure extends UserHomeState {
  final String errorMessage;

  ServicesFailure({required this.errorMessage});
}

// Rides states
final class UserHomeRidesLoading extends UserHomeState {}

final class UserHomeRidesSuccess extends UserHomeState {
  final RideModel ridesModel;

  UserHomeRidesSuccess({required this.ridesModel});
}

final class UserHomeRidesFailure extends UserHomeState {
  final String errorMessage;

  UserHomeRidesFailure({required this.errorMessage});
}

// offers & order
class AcceptOfferLoading extends UserHomeState {
  final int offerId;

  AcceptOfferLoading({required this.offerId});
}

class AcceptOfferSuccess extends UserHomeState {
  final AcceptOfferEntity acceptOfferModel;
  final int offerId;

  AcceptOfferSuccess({required this.acceptOfferModel, required this.offerId});
}

class AcceptOfferFailure extends UserHomeState {
  final String errorMessage;
  final int offerId;

  AcceptOfferFailure({required this.errorMessage, required this.offerId});
}

class AcceptOfferPaymentRequired extends UserHomeState {
  final int offerId;
  final String checkoutUrl;

  AcceptOfferPaymentRequired(
      {required this.offerId, required this.checkoutUrl});
}

class DenyOfferLoading extends UserHomeState {
  final int offerId;
  DenyOfferLoading({required this.offerId});
}

class DenyOfferSuccess extends UserHomeState {
  final int offerId;
  DenyOfferSuccess({required this.offerId});
}

class DenyOfferFailure extends UserHomeState {
  final String errorMessage;
  final int offerId;
  DenyOfferFailure({required this.errorMessage, required this.offerId});
}

class OffersUpdated extends UserHomeState {
  final List<TripOfferModel> offers;

  OffersUpdated(this.offers);
}

final class CancelOrderLoading extends UserHomeState {}

final class CancelOrderSuccess extends UserHomeState {
  final AcceptOfferEntity cancelOrderModel;

  CancelOrderSuccess({required this.cancelOrderModel});
}

final class CancelOrderFailure extends UserHomeState {
  final String errorMessage;

  CancelOrderFailure({required this.errorMessage});
}

final class GetPriceLoading extends UserHomeState {}

final class GetPriceSuccess extends UserHomeState {
  final List<ServicesDetailsModel> servicesDetails;

  GetPriceSuccess({required this.servicesDetails});
}

final class GetPriceFailure extends UserHomeState {
  final String errorMessage;

  GetPriceFailure({required this.errorMessage});
}

final class NewRideRequestLoading extends UserHomeState {}

final class NewRideRequestSuccess extends UserHomeState {
  final NewRideDataEntity newRideModel;

  NewRideRequestSuccess({required this.newRideModel});
}

final class NewRideRequestFailure extends UserHomeState {
  final String errorMessage;

  NewRideRequestFailure({required this.errorMessage});
}

final class NewRideRequestActiveTripFound extends UserHomeState {
  final int activeOrderId;
  final String message;
  final NewRideDataEntity? activeTrip;

  NewRideRequestActiveTripFound({
    required this.activeOrderId,
    required this.message,
    this.activeTrip,
  });
}

final class TripRealtimeConnected extends UserHomeState {}

final class TripRealtimeError extends UserHomeState {
  final String error;

  TripRealtimeError(this.error);
}

final class TripStatusChanged extends UserHomeState {
  final String status;
  final NewRideDataEntity tripModel;

  TripStatusChanged({required this.status, required this.tripModel});
}
