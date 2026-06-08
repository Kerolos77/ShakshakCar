import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/features/driver/home/data/models/demand_map_model.dart';
import 'package:shakshak/features/driver/new_rides/domain/entities/negotiation_settings_entity.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';

enum RideStatus { initial, loading, loaded, error }

enum RideActionStatus { initial, loading, success, error }

class RideState {
  final RideStatus status;
  final RideActionStatus actionStatus;
  final List<NewRideData> rides;
  final Set<int> newRideIds;
  final Set<int> pendingOffers;
  final String? message;
  final int? actionOrderId;

  final Map<int, double> currentAmounts;

  final Map<int, DateTime> newRideSeenAt;

  final NegotiationSettingsEntity? negotiationSettings;
  final DemandMapModel? demandMap;

  // Driver active trip tracking parameters
  final LatLng? currentDriverLocation;
  final double currentSpeed;
  final double currentBearing;
  final Set<int> verifiedTripOtps;
  final bool isSimulationActive;

  RideState({
    required this.status,
    required this.actionStatus,
    this.rides = const [],
    this.newRideIds = const {},
    this.pendingOffers = const {},
    this.message,
    this.actionOrderId,
    this.currentAmounts = const {},
    this.newRideSeenAt = const {},
    this.negotiationSettings,
    this.demandMap,
    this.currentDriverLocation,
    this.currentSpeed = 0.0,
    this.currentBearing = 0.0,
    this.verifiedTripOtps = const {},
    this.isSimulationActive = false,
  });

  factory RideState.initial() => RideState(
        status: RideStatus.initial,
        actionStatus: RideActionStatus.initial,
        verifiedTripOtps: const {},
        isSimulationActive: false,
      );

  RideState copyWith({
    RideStatus? status,
    RideActionStatus? actionStatus,
    List<NewRideData>? rides,
    Set<int>? newRideIds,
    Set<int>? pendingOffers,
    String? message,
    int? actionOrderId,
    bool clearActionOrderId = false,
    Map<int, double>? currentAmounts,
    Map<int, DateTime>? newRideSeenAt,
    NegotiationSettingsEntity? negotiationSettings,
    DemandMapModel? demandMap,
    LatLng? currentDriverLocation,
    double? currentSpeed,
    double? currentBearing,
    Set<int>? verifiedTripOtps,
    bool? isSimulationActive,
  }) {
    return RideState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      rides: rides ?? this.rides,
      newRideIds: newRideIds ?? this.newRideIds,
      pendingOffers: pendingOffers ?? this.pendingOffers,
      message: message ?? this.message,
      actionOrderId:
          clearActionOrderId ? null : (actionOrderId ?? this.actionOrderId),
      currentAmounts: currentAmounts ?? this.currentAmounts,
      newRideSeenAt: newRideSeenAt ?? this.newRideSeenAt,
      negotiationSettings: negotiationSettings ?? this.negotiationSettings,
      demandMap: demandMap ?? this.demandMap,
      currentDriverLocation: currentDriverLocation ?? this.currentDriverLocation,
      currentSpeed: currentSpeed ?? this.currentSpeed,
      currentBearing: currentBearing ?? this.currentBearing,
      verifiedTripOtps: verifiedTripOtps ?? this.verifiedTripOtps,
      isSimulationActive: isSimulationActive ?? this.isSimulationActive,
    );
  }
}
