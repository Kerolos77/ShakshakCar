import 'package:shakshak/features/user/user_home/data/models/place_model.dart';

abstract class LocationState {}

class InitialUserHomeState extends LocationState {}

class ChangeLocationUserHomeState extends LocationState {}

class GetMyLocationUserHomeState extends LocationState {}

class GetMyLocationUpDateUserHomeState extends LocationState {}

class ChangeBuscandoFlagUserHomeState extends LocationState {}

class ChangeAddressUserHomeState extends LocationState {}

class LoadingCreateAlertUserHomeState extends LocationState {}

class SuccessCreateAlertUserHomeState extends LocationState {}

class ErrorCreateAlertUserHomeState extends LocationState {
  final String error;

  ErrorCreateAlertUserHomeState(this.error);
}

class LoadingSendNotificationUserHomeState extends LocationState {}

class SuccessSendNotificationUserHomeState extends LocationState {}

class ErrorSendNotificationUserHomeState extends LocationState {
  final String error;

  ErrorSendNotificationUserHomeState(this.error);
}

class LoadingGetAddressUserHomeState extends LocationState {}

class SuccessGetAddressUserHomeState extends LocationState {}

class SuccessGetDestinationAddressUserHomeState extends LocationState {}

class ErrorGetAddressUserHomeState extends LocationState {
  final String error;

  ErrorGetAddressUserHomeState(this.error);
}

class OpenTripContainerUserHomeState extends LocationState {}

class CloseTripContainerUserHomeState extends LocationState {}

final class GetCategoryOfVehicleLoading extends LocationState {}

final class GetCategoryOfVehicleFailure extends LocationState {
  final String message;

  GetCategoryOfVehicleFailure({required this.message});
}

/// --------------------
/// Suggestions States
/// --------------------
class SuggestionsLoadingState extends LocationState {}

class SuggestionsLoadedState extends LocationState {
  final List<PlacePrediction> suggestions;

  SuggestionsLoadedState(this.suggestions);
}

class SuggestionsErrorState extends LocationState {
  final String error;

  SuggestionsErrorState(this.error);
}

/// --------------------
/// Place Details States
/// --------------------
class PlaceDetailsLoadingState extends LocationState {}

class PlaceDetailsLoadedState extends LocationState {
  final double lat;
  final double lng;
  final String address;

  PlaceDetailsLoadedState({
    required this.lat,
    required this.lng,
    required this.address,
  });
}

class PlaceDetailsErrorState extends LocationState {
  final String error;

  PlaceDetailsErrorState(this.error);
}

class PlaceSelectedState extends LocationState {
  final PlacePrediction? sourcePlace;
  final PlacePrediction? destinationPlace;

  PlaceSelectedState(this.sourcePlace, this.destinationPlace);
}

class UserHomeErrorState extends LocationState {
  final String message;

  UserHomeErrorState(this.message);
}

class ConfirmDestinationsState extends LocationState {}

class NearbyDriversLoading extends LocationState {}

class NearbyDriversSuccess extends LocationState {
  final dynamic nearbyDrivers;

  NearbyDriversSuccess(this.nearbyDrivers);
}

class NearbyDriversFailure extends LocationState {
  final String message;

  NearbyDriversFailure(this.message);
}


