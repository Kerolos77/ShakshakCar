import 'package:shakshak/features/user/user_home_page/data/models/calc_price_time_distance_response.dart';
import 'package:shakshak/features/user/user_home_page/data/models/cancel_ride_response_body.dart';
import 'package:shakshak/features/user/user_home_page/data/models/ride_request_response_body.dart';

abstract class HomeState {}

class InitialHomeState extends HomeState {}

class ChangeLocationHomeState extends HomeState {}

class GetMyLocationHomeState extends HomeState {}

class GetMyLocationUpDateHomeState extends HomeState {}

class CarSpeedHomeState extends HomeState {}

class ChangeBuscandoFlagHomeState extends HomeState {}

class LoadingCreateAlertHomeState extends HomeState {}

class SuccessCreateAlertHomeState extends HomeState {}

class ErrorCreateAlertHomeState extends HomeState {
  final String error;

  ErrorCreateAlertHomeState(this.error);
}

class LoadingSendNotificationHomeState extends HomeState {}

class SuccessSendNotificationHomeState extends HomeState {}

class ErrorSendNotificationHomeState extends HomeState {
  final String error;

  ErrorSendNotificationHomeState(this.error);
}

class LoadingGetAddressHomeState extends HomeState {}

class SuccessGetAddressHomeState extends HomeState {}
class SuccessGetDestinationAddressHomeState extends HomeState {}

class ErrorGetAddressHomeState extends HomeState {
  final String error;

  ErrorGetAddressHomeState(this.error);
}

class OpenTripContainerHomeState extends HomeState {}

class CloseTripContainerHomeState extends HomeState {}



class CalcPriceAndTimeDistanceLoadingState extends HomeState {}

class CalcPriceAndTimeDistanceSuccessState extends HomeState {

  final CalcPriceTimeDistanceResponse? calcPriceTimeDistanceResponse;

  CalcPriceAndTimeDistanceSuccessState({ this.calcPriceTimeDistanceResponse});

}

class CalcPriceAndTimeDistanceErrorState extends HomeState {
  final String error;

  CalcPriceAndTimeDistanceErrorState({required this.error});
}



class RideRequestLoadingState extends HomeState {}

class RideRequestSuccessState extends HomeState {

  final RideRequestResponseBody? rideRequestResponseBody;

  RideRequestSuccessState({ this.rideRequestResponseBody});

}

class RideRequestErrorState extends HomeState {
  final String error;

  RideRequestErrorState({required this.error});
}



class CancelRideRequestPassengerLoadingState extends HomeState {}

class CancelRideRequestPassengerSuccessState extends HomeState {

  final CancelRideResponseBody? cancelRideResponseBody;

  CancelRideRequestPassengerSuccessState({ this.cancelRideResponseBody});

}

class CancelRideRequestPassengerErrorState extends HomeState {
  final String error;

  CancelRideRequestPassengerErrorState({required this.error});
}



final class GetCategoryOfVehicleLoading extends HomeState {}

// final class GetCategoryOfVehicleSuccess extends HomeState {
//   final CategoryOfVehicleResponse categoryOfVehicleResponse;
//   GetCategoryOfVehicleSuccess({required this.categoryOfVehicleResponse});
// }

final class GetCategoryOfVehicleFailure extends HomeState {
  final String message;
  GetCategoryOfVehicleFailure({required this.message});
}
