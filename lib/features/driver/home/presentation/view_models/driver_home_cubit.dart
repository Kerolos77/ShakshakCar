import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/core/services/background_location_service.dart';
import 'package:shakshak/core/services/location_service.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/features/driver/home/domain/entities/driver_toggle_online_entity.dart';
import 'package:shakshak/features/driver/home/domain/usecases/driver_toggle_online_usecase.dart';
import 'package:shakshak/features/driver/home/domain/usecases/set_driver_destination_usecase.dart';

part 'driver_home_state.dart';

class DriverHomeCubit extends Cubit<DriverHomeState> {
  DriverHomeCubit(
      this.driverToggleOnlineUseCase, this.setDriverDestinationUseCase)
      : super(DriverHomeInitial());
  final DriverToggleOnlineUseCase driverToggleOnlineUseCase;
  final SetDriverDestinationUseCase setDriverDestinationUseCase;
  bool isOnline = false;

  void updateOnlineStatus(bool online) {
    isOnline = online;
    emit(DriverToggleOnlineSuccess(
        driverToggleOnlineEntity: DriverToggleOnlineEntity(status: online ? 1 : 0)));
  }

  Future<void> driverToggleOnline({required int value}) async {
    isOnline = value == 1;
    emit(DriverToggleOnlineLoading());
    var result =
        await driverToggleOnlineUseCase(DriverToggleOnlineParams(value: value));
    result.fold((error) {
      debugPrint("error while driver toggle online   ${error.message}");
      return emit(DriverToggleOnlineFailure(errorMessage: error.message));
    }, (success) {
      // Start or stop tracking based on online status
      if (value == 1) {
        sl<LocationService>().startTracking(highAccuracy: true);
        // Start the headless tracking when going online
        BackgroundLocationService().startService();
      } else {
        sl<LocationService>().stopTracking();
        // Stop tracking and kill the background service when going offline
        BackgroundLocationService().stopService();
      }
      return emit(DriverToggleOnlineSuccess(driverToggleOnlineEntity: success));
    });
  }

  bool acceptsFemaleOnly = false;

  void toggleAcceptsFemaleOnly(bool value) {
    acceptsFemaleOnly = value;
    emit(DriverToggleOnlineSuccess(
        driverToggleOnlineEntity: DriverToggleOnlineEntity(
            status: 1))); // dummy emit or real state emit to trigger UI refresh
  }

  Future<void> setDestination({
    required bool isHeadingDestination,
    double? lat,
    double? lng,
    String? address,
  }) async {
    emit(DriverToggleOnlineLoading());
    var result = await setDriverDestinationUseCase(
      isHeadingDestination: isHeadingDestination,
      lat: lat,
      lng: lng,
      address: address,
    );
    result.fold(
      (error) {
        debugPrint("Error setting destination: ${error.message}");
        emit(DriverToggleOnlineFailure(errorMessage: error.message));
      },
      (success) {
        emit(DriverToggleOnlineSuccess(
            driverToggleOnlineEntity: DriverToggleOnlineEntity(status: 1)));
      },
    );
  }
}
