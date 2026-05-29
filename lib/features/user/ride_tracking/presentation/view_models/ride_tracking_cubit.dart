import 'dart:convert';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/core/services/google_maps_service.dart';
import 'package:shakshak/core/services/real_time/realtime_manager.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/services/trip_storage_service.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_user.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/cancel_order_usecase.dart';

import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:dio/dio.dart';

part 'ride_tracking_state.dart';

class RideTrackingCubit extends Cubit<RideTrackingState> {
  final NewRideDataEntity ride;
  final RealtimeManager _realtimeManager;
  final GoogleMapsService _mapsService;
  final CancelOrderUseCase _cancelOrderUseCase;

  RideTrackingCubit({
    required this.ride,
  })  : _realtimeManager = sl<RealtimeManager>(),
        _mapsService = GoogleMapsService(),
        _cancelOrderUseCase = sl<CancelOrderUseCase>(),
        super(RideTrackingInitial()) {
    // ⚡ Connect to realtime IMMEDIATELY - before anything else.
    // This ensures no status updates are missed even during map loading.
    _connectRealtime();
    _initTracking();
  }

  void _initTracking() async {
    testStatus = ride.status;

    if (ride.status == 'completed' || ride.status == 'canceled') {
      emit(RideTrackingEnded(ride: ride, status: ride.status));
      return;
    }

    // ⚡ If the trip is still pending (no driver assigned yet),
    // stay in loading state and wait for real-time status updates.
    // Do NOT load map/routes or emit RideTrackingAccepted.
    if (ride.status == 'pending') {
      emit(RideTrackingLoading());
      debugPrint('🕐 RideTrackingCubit: Trip is pending, waiting for status update...');
      return;
    }

    emit(RideTrackingLoading());
    
    // ⚡ _connectRealtime() was already called in the constructor - no need to call again here

    // Initial Driver Location (Fetch from API first)
    LatLng driverLoc = await _getInitialDriverLocation(ride);

    // Fetch Trip Route (Pickup to Dropoff)
    final pickup = LatLng(ride.sourceLat, ride.sourceLong);
    final dropoff = LatLng(ride.destinationLat, ride.destinationLong);

    final tripRoute =
        await _mapsService.fetchRoute(start: pickup, end: dropoff);
    RouteData? tripData;
    if (tripRoute != null) {
      tripData = RouteData(
        polylinePoints: tripRoute.polylinePoints,
        distance: tripRoute.distance,
        duration: tripRoute.duration,
      );
    }

    // ─── Evaluate using `testStatus` which might have been updated by WebSockets ───
    if (testStatus == 'on_trip') {
      final d2d = await _mapsService.fetchRoute(start: driverLoc, end: dropoff);
      emit(RideTrackingOnTrip(
        ride: ride,
        driverLocation: driverLoc,
        pickupToDropoffData: tripData,
        driverToDestinationData: d2d != null
            ? RouteData(
                polylinePoints: d2d.polylinePoints,
                distance: d2d.distance,
                duration: d2d.duration,
              )
            : null,
      ));
    } else if (testStatus == 'started') {
      final d2d = await _mapsService.fetchRoute(start: driverLoc, end: dropoff);
      emit(RideTrackingStarted(
        ride: ride,
        driverLocation: driverLoc,
        pickupToDropoffData: tripData,
        driverToDestinationData: d2d != null
            ? RouteData(
                polylinePoints: d2d.polylinePoints,
                distance: d2d.distance,
                duration: d2d.duration,
              )
            : null,
        status: testStatus,
      ));
    } else if (testStatus == 'arrived') {
      emit(RideTrackingArrived(
        ride: ride,
        driverLocation: driverLoc,
        pickupToDropoffData: tripData,
      ));
    } else if (testStatus == 'user_accept_offer' || testStatus == 'payment_pending') {
      emit(RideTrackingPaymentProcessing(ride: ride, status: testStatus));
    } else if (testStatus == 'payment_failed') {
      emit(RideTrackingPaymentFailed(ride: ride));
    } else {
      // For assigned, driver_on_a_way, explicit fallbacks
      final driverToPickup =
          await _mapsService.fetchRoute(start: driverLoc, end: pickup);
      RouteData? d2pData;
      if (driverToPickup != null) {
        d2pData = RouteData(
          polylinePoints: driverToPickup.polylinePoints,
          distance: driverToPickup.distance,
          duration: driverToPickup.duration,
        );
      }

      emit(RideTrackingAccepted(
        ride: ride,
        driverLocation: driverLoc,
        driverToPickupData: d2pData,
        pickupToDropoffData: tripData,
        status: testStatus.isNotEmpty ? testStatus : null,
      ));
    }
  }

  String testStatus = '...';

  // ⚡ Smart Throttling Fields
  DateTime _lastRouteRefresh = DateTime(2000);
  static const int _routeRefreshIntervalSec = 30;
  static const double _routeDeviationThresholdMeters = 200;

  String? _locUpdateToken;
  String? _rideStartedToken;
  String? _rideCompletedToken;
  String? _statusToken;
  String? _driverLocationChannel;


  void _connectRealtime() {
    // ⚡ Listen to Driver Location (Depends on driver assignment)
    if (ride.driver != null) {
      _subscribeToDriverLocation(ride.driver!.id);
    }

    _rideStartedToken = _realtimeManager.addListener(
      channel: "location-${ride.id}",
      event: 'ride_started',
      callback: (data) {
        if (state is RideTrackingAccepted || state is RideTrackingArrived) {
          _handleStatusUpdate('started', updatedRide: ride);
        }
      },
    );

    _rideCompletedToken = _realtimeManager.addListener(
      channel: "location-${ride.id}",
      event: 'ride_completed',
      callback: (data) async {
        await TripStorageService.removeActiveTripId();
        emit(RideTrackingEnded(ride: ride, status: 'completed'));
      },
    );

    // Add status updates listener on trip channel
    final String statusChannel = "trip-${ride.id}";
    _statusToken = _realtimeManager.addListener(
      channel: statusChannel,
      event: 'TripStatusUpdated',
      callback: (data) async {
        debugPrint("📥 RideTrackingView - Raw Data Received: $data");
        
        final status = data['status'];
        final orderData = data['order'] ?? data; // Try nested 'order' first, then fallback to root
        
        final currentRide = ride as NewRideData;
        NewRideData updatedRide = currentRide;

        // Correctly check for ID in the order object
        if (orderData is Map && orderData.containsKey('id')) {
          try {
            final parsed = NewRideData.fromJson(orderData as Map<String, dynamic>);
            updatedRide = parsed.copyWith(
              driver: (parsed.driver ?? currentRide.driver) as NewRideUser?,
              carBrand: parsed.carBrand ?? currentRide.carBrand,
              carModel: parsed.carModel ?? currentRide.carModel,
              carPlate: parsed.carPlate ?? currentRide.carPlate,
              carColor: parsed.carColor ?? currentRide.carColor,
              paymentDetails: (parsed.paymentDetails ?? currentRide.paymentDetails) as PaymentDetailsModel?,
              offers: (parsed.offers.isNotEmpty ? parsed.offers : currentRide.offers).cast<OfferModel>(),
            );
            debugPrint("✅ Ride data updated for trip: ${updatedRide.id} with status: $status");
          } catch (e) {
            debugPrint("⚠️ Error parsing updated ride data: $e");
          }
        }

        debugPrint("📥 RideTrackingView - حالة الرحلة اتغيرت: $status");
        testStatus = status;

        // ⚡ If driver was just assigned, start listening to their location
        if (updatedRide.driver != null && _driverLocationChannel == null) {
          _subscribeToDriverLocation(updatedRide.driver!.id);
        }

        switch (status) {
          case 'user_accept_offer':
          case 'payment_pending':
            emit(RideTrackingPaymentProcessing(
                ride: updatedRide, status: status));
            break;
          case 'payment_failed':
            emit(RideTrackingPaymentFailed(ride: updatedRide));
            break;
          case 'payment_paid':
          case 'assigned':
          case 'driver_on_a_way':
            _handleStatusUpdate(status, updatedRide: updatedRide);
            break;
          case 'arrived':
            _handleArrivedStatus(updatedRide: updatedRide);
            break;
          case 'on_trip':
            _handleOnTripStatus(updatedRide: updatedRide);
            break;
          case 'started':
            _handleStatusUpdate('started', updatedRide: updatedRide);
            break;
          case 'completed':
          case 'canceled':
            await TripStorageService.removeActiveTripId();
            emit(RideTrackingEnded(ride: updatedRide, status: status));
            break;
          default:
            _handleStatusUpdate(status, updatedRide: updatedRide);
        }
      },
    );
  }

  void _handleStatusUpdate(String status, {NewRideDataEntity? updatedRide}) {
    final currentRide = updatedRide ?? ride;
    if (state is RideTrackingAccepted) {
      final s = state as RideTrackingAccepted;
      if (status == 'started') {
        _handleStartedStatus(
            currentRide, s.driverLocation, s.pickupToDropoffData);
      } else if (status == 'on_trip') {
        _handleStartedStatus(
            currentRide, s.driverLocation, s.pickupToDropoffData,
            isOnTrip: true);
      } else {
        emit(RideTrackingAccepted(
          ride: currentRide,
          driverLocation: s.driverLocation,
          driverToPickupData: s.driverToPickupData,
          pickupToDropoffData: s.pickupToDropoffData,
          status: status,
        ));
      }
    } else if (state is RideTrackingStarted) {
      final s = state as RideTrackingStarted;
      if (status == 'on_trip') {
        _handleStartedStatus(
            currentRide, s.driverLocation, s.pickupToDropoffData,
            isOnTrip: true);
      } else {
        emit(RideTrackingStarted(
          ride: currentRide,
          driverLocation: s.driverLocation,
          pickupToDropoffData: s.pickupToDropoffData,
          driverToDestinationData: s.driverToDestinationData,
          status: status,
        ));
      }
    } else if (state is RideTrackingOnTrip) {
      final s = state as RideTrackingOnTrip;
      emit(RideTrackingOnTrip(
        ride: currentRide,
        driverLocation: s.driverLocation,
        pickupToDropoffData: s.pickupToDropoffData,
        driverToDestinationData: s.driverToDestinationData,
      ));
    } else if (state is RideTrackingArrived) {
      final s = state as RideTrackingArrived;
      if (status == 'started') {
        _handleStartedStatus(
            currentRide, s.driverLocation, s.pickupToDropoffData);
      } else if (status == 'on_trip') {
        _handleStartedStatus(
            currentRide, s.driverLocation, s.pickupToDropoffData,
            isOnTrip: true);
      } else {
        emit(RideTrackingArrived(
          ride: currentRide,
          driverLocation: s.driverLocation,
          pickupToDropoffData: s.pickupToDropoffData,
        ));
      }
    } else if (state is RideTrackingPaymentProcessing ||
        state is RideTrackingPaymentFailed) {
      if (status == 'assigned' || status == 'driver_on_a_way' || status == 'payment_paid') {
        // ⚡ Transition from payment to tracking: MUST load map/routes
        debugPrint('🚀 RideTrackingCubit: Payment confirmed or driver assigned, loading map data...');
        _loadMapAndEmitAccepted(currentRide, status);
      } else if (status == 'arrived') {
        emit(RideTrackingArrived(
          ride: currentRide,
          driverLocation:
              const LatLng(30.0444, 31.2357), // Map updates handles real coords
        ));
      } else if (status == 'started' || status == 'on_trip') {
        emit(RideTrackingStarted(
          ride: currentRide,
          driverLocation: const LatLng(30.0444, 31.2357),
          status: status,
        ));
      }
    } else if (state is RideTrackingLoading || state is RideTrackingInitial) {
      // ⚡ Update received while we are still in loading/pending state.
      testStatus = status;
      // For terminal states, act immediately regardless of map loading.
      if (status == 'completed' || status == 'canceled') {
        emit(RideTrackingEnded(ride: currentRide, status: status));
      } else if (status == 'user_accept_offer' || status == 'payment_pending') {
        emit(RideTrackingPaymentProcessing(ride: currentRide, status: status));
      } else if (status == 'payment_failed') {
        emit(RideTrackingPaymentFailed(ride: currentRide));
      } else if (status == 'assigned' || status == 'driver_on_a_way' || status == 'payment_paid') {
        // ⚡ Trip transitioned from pending → assigned while we were waiting.
        // We need to load map data now and emit the correct tracking state.
        debugPrint('🚀 RideTrackingCubit: Trip assigned from pending, loading map data...');
        _loadMapAndEmitAccepted(currentRide, status);
      } else if (status == 'arrived') {
        _loadMapAndEmitAccepted(currentRide, status);
      } else if (status == 'started' || status == 'on_trip') {
        _loadMapAndEmitAccepted(currentRide, status);
      }
    }
  }

  /// ⚡ Loads map data and emits the appropriate tracking state.
  /// Used when transitioning from pending/loading → active tracking.
  void _loadMapAndEmitAccepted(NewRideDataEntity currentRide, String status) async {
    LatLng driverLoc = await _getInitialDriverLocation(currentRide);

    final pickup = LatLng(currentRide.sourceLat, currentRide.sourceLong);
    final dropoff = LatLng(currentRide.destinationLat, currentRide.destinationLong);

    final tripRoute = await _mapsService.fetchRoute(start: pickup, end: dropoff);
    RouteData? tripData;
    if (tripRoute != null) {
      tripData = RouteData(
        polylinePoints: tripRoute.polylinePoints,
        distance: tripRoute.distance,
        duration: tripRoute.duration,
      );
    }

    if (status == 'started' || status == 'on_trip') {
      final d2d = await _mapsService.fetchRoute(start: driverLoc, end: dropoff);
      if (status == 'on_trip') {
        emit(RideTrackingOnTrip(
          ride: currentRide,
          driverLocation: driverLoc,
          pickupToDropoffData: tripData,
          driverToDestinationData: d2d != null
              ? RouteData(polylinePoints: d2d.polylinePoints, distance: d2d.distance, duration: d2d.duration)
              : null,
        ));
      } else {
        emit(RideTrackingStarted(
          ride: currentRide,
          driverLocation: driverLoc,
          pickupToDropoffData: tripData,
          driverToDestinationData: d2d != null
              ? RouteData(polylinePoints: d2d.polylinePoints, distance: d2d.distance, duration: d2d.duration)
              : null,
          status: status,
        ));
      }
    } else if (status == 'arrived') {
      emit(RideTrackingArrived(
        ride: currentRide,
        driverLocation: driverLoc,
        pickupToDropoffData: tripData,
      ));
    } else {
      // assigned, driver_on_a_way, payment_paid
      final driverToPickup = await _mapsService.fetchRoute(start: driverLoc, end: pickup);
      RouteData? d2pData;
      if (driverToPickup != null) {
        d2pData = RouteData(
          polylinePoints: driverToPickup.polylinePoints,
          distance: driverToPickup.distance,
          duration: driverToPickup.duration,
        );
      }

      emit(RideTrackingAccepted(
        ride: currentRide,
        driverLocation: driverLoc,
        driverToPickupData: d2pData,
        pickupToDropoffData: tripData,
        status: status,
      ));
    }
  }

  void _handleOnTripStatus({NewRideDataEntity? updatedRide}) {
    final currentRide = updatedRide ?? ride;
    final dynamic s = state;
    if (s is RideTrackingStarted ||
        s is RideTrackingArrived ||
        s is RideTrackingAccepted) {
      _handleStartedStatus(currentRide, s.driverLocation, s.pickupToDropoffData,
          isOnTrip: true);
    } else if (s is RideTrackingPaymentProcessing ||
        s is RideTrackingPaymentFailed) {
      // على طول نحمل الخريطة ونعمل emit
      _loadMapAndEmitAccepted(currentRide, 'on_trip');
    } else if (s is RideTrackingLoading || s is RideTrackingInitial) {
      testStatus = 'on_trip';
      _loadMapAndEmitAccepted(currentRide, 'on_trip');
    }
  }

  void _handleStartedStatus(
      NewRideDataEntity currentRide, LatLng driverLoc, RouteData? tripData,
      {bool isOnTrip = false}) async {
    final dropoff =
        LatLng(currentRide.destinationLat, currentRide.destinationLong);
    final d2d = await _mapsService.fetchRoute(start: driverLoc, end: dropoff);

    if (isOnTrip) {
      emit(RideTrackingOnTrip(
        ride: currentRide,
        driverLocation: driverLoc,
        pickupToDropoffData: tripData,
        driverToDestinationData: d2d != null
            ? RouteData(
                polylinePoints: d2d.polylinePoints,
                distance: d2d.distance,
                duration: d2d.duration,
              )
            : null,
      ));
    } else {
      emit(RideTrackingStarted(
        ride: currentRide,
        driverLocation: driverLoc,
        pickupToDropoffData: tripData,
        driverToDestinationData: d2d != null
            ? RouteData(
                polylinePoints: d2d.polylinePoints,
                distance: d2d.distance,
                duration: d2d.duration,
              )
            : null,
      ));
    }
  }

  void _handleArrivedStatus({NewRideDataEntity? updatedRide}) {
    final currentRide = updatedRide ?? ride;
    if (state is RideTrackingAccepted) {
      final s = state as RideTrackingAccepted;
      emit(RideTrackingArrived(
        ride: currentRide,
        driverLocation: s.driverLocation,
        pickupToDropoffData: s.pickupToDropoffData,
      ));
    } else if (state is RideTrackingPaymentProcessing ||
        state is RideTrackingPaymentFailed) {
      // السواق وصل وإحنا لسه في الدفع — نعمل emit على طول
      emit(RideTrackingArrived(
        ride: currentRide,
        driverLocation: const LatLng(30.0444, 31.2357),
      ));
    } else if (state is RideTrackingLoading || state is RideTrackingInitial) {
      // السواق وصل والخريطة لسه بتحمل — نحمل الداتا ونعمل emit
      testStatus = 'arrived';
      _loadMapAndEmitAccepted(currentRide, 'arrived');
    }
    // لو الحالة RideTrackingStarted أو OnTrip — مش منطقي يرجع arrived فنتجاهلها
  }

  Future<void> cancelRide() async {
    emit(RideTrackingLoading());
    final result = await _cancelOrderUseCase(
      CancelOrderUseCaseParams(orderId: ride.id),
    );

    result.fold(
      (error) => emit(RideTrackingError(error.message)),
      (success) async {
        await TripStorageService.removeActiveTripId();
        emit(RideTrackingEnded(ride: ride, status: 'canceled'));
      },
    );
  }

  Future<void> resolvePayment(String paymentType) async {
    try {
      // Show loading overlay
      emit(RideTrackingPaymentProcessing(ride: ride, status: 'payment_pending'));
      
      final response = await DioHelper.postData(
        url: '${ApiConstant.resolvePaymentUrl}/${ride.id}/resolve-payment',
        token: CacheHelper.getData(key: AppConstant.kToken),
        data: {
          'payment_type': paymentType,
        },
      );
      
      final responseData = response.data;
      if (response.statusCode == 200 && responseData['statusval'] == true) {
        // The real-time socket will update the state shortly to payment_paid, assigned, etc.
        debugPrint('✅ Payment resolved successfully');
      } else {
        emit(RideTrackingPaymentFailed(ride: ride));
      }
    } catch (e) {
      debugPrint('⚠️ Error resolving payment: $e');
      emit(RideTrackingPaymentFailed(ride: ride));
    }
  }

  /// Calculate distance between two LatLng points in meters (Haversine formula)
  double _distanceInMeters(LatLng a, LatLng b) {
    const double earthRadius = 6371000; // meters
    final dLat = _toRadians(b.latitude - a.latitude);
    final dLng = _toRadians(b.longitude - a.longitude);
    final sinDLat = math.sin(dLat / 2);
    final sinDLng = math.sin(dLng / 2);
    final c = sinDLat * sinDLat +
        math.cos(_toRadians(a.latitude)) *
            math.cos(_toRadians(b.latitude)) *
            sinDLng * sinDLng;
    return earthRadius * 2 * math.atan2(math.sqrt(c), math.sqrt(1 - c));
  }

  double _toRadians(double deg) => deg * math.pi / 180;

  /// Check if we should refresh the route (time-based or distance-based)
  bool _shouldRefreshRoute(LatLng newLoc, List<LatLng>? currentRoutePoints) {
    // Time-based: refresh if it's been more than 30 seconds
    final elapsed = DateTime.now().difference(_lastRouteRefresh).inSeconds;
    if (elapsed >= _routeRefreshIntervalSec) return true;

    // Distance-based: refresh if driver deviated > 200m from route
    if (currentRoutePoints != null && currentRoutePoints.isNotEmpty) {
      double minDist = double.infinity;
      // Check distance to nearest point on route (sample every 3rd point for performance)
      for (int i = 0; i < currentRoutePoints.length; i += 3) {
        final dist = _distanceInMeters(newLoc, currentRoutePoints[i]);
        if (dist < minDist) minDist = dist;
      }
      if (minDist > _routeDeviationThresholdMeters) return true;
    }

    return false;
  }

  void _subscribeToDriverLocation(int driverId) {
    if (_locUpdateToken != null) {
      _realtimeManager.removeListener(_locUpdateToken!);
    }
    if (_driverLocationChannel != null) {
      _realtimeManager.unsubscribe(_driverLocationChannel!);
    }

    _driverLocationChannel = "location-$driverId";
    debugPrint('📡 RideTrackingCubit: Subscribing to driver location channel: $_driverLocationChannel');
    
    _locUpdateToken = _realtimeManager.addListener(
      channel: _driverLocationChannel!,
      event: 'location_update',
      callback: (data) {
        try {
          double lat = double.parse(
              data['latitude']?.toString() ?? data['lat'].toString());
          double lng = double.parse(
              data['longitude']?.toString() ?? data['lng'].toString());
          _handleLocationUpdate(LatLng(lat, lng));
        } catch (e) {
          debugPrint("Error parsing location update: $e");
        }
      },
    );
  }

  Future<LatLng> _getInitialDriverLocation(NewRideDataEntity currentRide) async {
    // ⚡ Try to fetch real location from REST API first
    if (currentRide.driver != null) {
      final fetched = await _mapsService.fetchDriverLastLocation(currentRide.driver!.id);
      if (fetched != null) {
        return fetched;
      }
    }

    // ⚡ Fallback: If no driver location, use Pickup location (source) 
    // This is better than Cairo because it keeps the driver in the relevant map area.
    return LatLng(currentRide.sourceLat, currentRide.sourceLong);
  }

  void _handleLocationUpdate(LatLng newLoc) async {
    if (state is RideTrackingAccepted) {
      final s = state as RideTrackingAccepted;

      // ⚡ Step 1: Move marker immediately (no API call)
      emit(RideTrackingAccepted(
        ride: ride,
        driverLocation: newLoc,
        driverToPickupData: s.driverToPickupData,
        pickupToDropoffData: s.pickupToDropoffData,
        status: s.status,
      ));

      // ⚡ Step 2: Only refresh route if needed (throttled)
      if (_shouldRefreshRoute(newLoc, s.driverToPickupData?.polylinePoints)) {
        final pickup = LatLng(ride.sourceLat, ride.sourceLong);
        final d2p = await _mapsService.fetchRoute(start: newLoc, end: pickup);
        _lastRouteRefresh = DateTime.now();

        if (d2p != null && state is RideTrackingAccepted) {
          emit(RideTrackingAccepted(
            ride: ride,
            driverLocation: newLoc,
            driverToPickupData: RouteData(
              polylinePoints: d2p.polylinePoints,
              distance: d2p.distance,
              duration: d2p.duration,
            ),
            pickupToDropoffData: s.pickupToDropoffData,
            status: s.status,
          ));
        }
      }
    } else if (state is RideTrackingStarted) {
      final s = state as RideTrackingStarted;

      // ⚡ Step 1: Move marker immediately
      emit(RideTrackingStarted(
        ride: ride,
        driverLocation: newLoc,
        pickupToDropoffData: s.pickupToDropoffData,
        driverToDestinationData: s.driverToDestinationData,
        status: s.status,
      ));

      // ⚡ Step 2: Only refresh route if needed
      if (_shouldRefreshRoute(newLoc, s.driverToDestinationData?.polylinePoints)) {
        final dropoff = LatLng(ride.destinationLat, ride.destinationLong);
        final d2d = await _mapsService.fetchRoute(start: newLoc, end: dropoff);
        _lastRouteRefresh = DateTime.now();

        if (d2d != null && state is RideTrackingStarted) {
          emit(RideTrackingStarted(
            ride: ride,
            driverLocation: newLoc,
            pickupToDropoffData: s.pickupToDropoffData,
            driverToDestinationData: RouteData(
              polylinePoints: d2d.polylinePoints,
              distance: d2d.distance,
              duration: d2d.duration,
            ),
            status: s.status,
          ));
        }
      }
    } else if (state is RideTrackingOnTrip) {
      final s = state as RideTrackingOnTrip;

      // ⚡ Step 1: Move marker immediately
      emit(RideTrackingOnTrip(
        ride: ride,
        driverLocation: newLoc,
        pickupToDropoffData: s.pickupToDropoffData,
        driverToDestinationData: s.driverToDestinationData,
      ));

      // ⚡ Step 2: Only refresh route if needed
      if (_shouldRefreshRoute(newLoc, s.driverToDestinationData?.polylinePoints)) {
        final dropoff = LatLng(ride.destinationLat, ride.destinationLong);
        final d2d = await _mapsService.fetchRoute(start: newLoc, end: dropoff);
        _lastRouteRefresh = DateTime.now();

        if (d2d != null && state is RideTrackingOnTrip) {
          emit(RideTrackingOnTrip(
            ride: ride,
            driverLocation: newLoc,
            pickupToDropoffData: s.pickupToDropoffData,
            driverToDestinationData: RouteData(
              polylinePoints: d2d.polylinePoints,
              distance: d2d.distance,
              duration: d2d.duration,
            ),
          ));
        }
      }
    }
  }

  @override
  Future<void> close() {
    if (_locUpdateToken != null) {
      _realtimeManager.removeListener(_locUpdateToken!);
    }
    if (_rideStartedToken != null) {
      _realtimeManager.removeListener(_rideStartedToken!);
    }
    if (_rideCompletedToken != null) {
      _realtimeManager.removeListener(_rideCompletedToken!);
    }
    if (_statusToken != null) {
      _realtimeManager.removeListener(_statusToken!);
    }

    if (_driverLocationChannel != null) {
      _realtimeManager.unsubscribe(_driverLocationChannel!);
    }
    _realtimeManager.unsubscribe("location-${ride.id}"); // Started/completed channel
    _realtimeManager.unsubscribe("trip-${ride.id}");
    return super.close();
  }
}
