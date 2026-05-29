import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/services/google_maps_service.dart';
import 'package:shakshak/generated/l10n.dart';

import 'map_loading_skeleton.dart';
import 'map_marker_helper.dart';
import 'map_utils.dart';

class TrackingMapWidget extends StatefulWidget {
  final LatLng driverLocation;
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final RouteData? driverToPickupData;
  final RouteData? pickupToDropoffData;
  final RouteData? driverToDestinationData;
  final Function(GoogleMapController) onMapCreated;
  final VoidCallback? onUserInteraction;
  final Color carColor;
  final bool isMotorcycle;

  const TrackingMapWidget({
    super.key,
    required this.driverLocation,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.driverToPickupData,
    this.pickupToDropoffData,
    this.driverToDestinationData,
    required this.onMapCreated,
    this.onUserInteraction,
    this.carColor = AppColors.primaryColor,
    this.isMotorcycle = false,
  });

  @override
  State<TrackingMapWidget> createState() => _TrackingMapWidgetState();
}

class _TrackingMapWidgetState extends State<TrackingMapWidget>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  bool _isMapReady = false;

  // ⚡ Smooth Marker Animation
  AnimationController? _markerAnimController;
  LatLng? _animFromLocation;
  LatLng? _animToLocation;
  LatLng _currentAnimatedLocation = const LatLng(30.0444, 31.2357);
  double _currentBearing = 0.0;

  // ⚡ Camera Controls (Driver Mode)
  Timer? _autoCameraTimer;
  bool _isUserMovingCamera = false;

  @override
  void initState() {
    super.initState();
    final initialLoc = _getSnappedLocation(widget.driverLocation);
    _currentAnimatedLocation = initialLoc;
    _animToLocation = initialLoc; // منع الحسابات الخاطئة في البداية
    _markerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(_onAnimationTick);
    _updateMap();
  }

  @override
  void dispose() {
    _markerAnimController?.removeListener(_onAnimationTick);
    _markerAnimController?.dispose();
    _autoCameraTimer?.cancel();
    super.dispose();
  }

  void _onAnimationTick() {
    if (_animFromLocation == null || _animToLocation == null) return;
    final t = CurvedAnimation(
      parent: _markerAnimController!,
      curve: Curves.easeInOut,
    ).value;

    final lat = _animFromLocation!.latitude +
        (_animToLocation!.latitude - _animFromLocation!.latitude) * t;
    final lng = _animFromLocation!.longitude +
        (_animToLocation!.longitude - _animFromLocation!.longitude) * t;

    _currentAnimatedLocation = LatLng(lat, lng);
    _updateDriverMarkerOnly();

    // ⚡ If in following mode, update camera target
    if (!_isUserMovingCamera && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentAnimatedLocation,
            zoom: 17.5,
            bearing: 0.0, // جعل الشمال دائماً في الأعلى (الخريطة ثابتة)
            tilt: 0.0, 
          ),
        ),
      );
    }
  }

  void _updateDriverMarkerOnly() {
    if (!mounted) return;
    // Update only the driver marker position without rebuilding everything
    final driverMarker = _markers.firstWhere(
      (m) => m.markerId == const MarkerId('driver'),
      orElse: () => Marker(
          markerId: const MarkerId('driver'),
          position: _currentAnimatedLocation),
    );
    setState(() {
      _markers.removeWhere((m) => m.markerId == const MarkerId('driver'));
      _markers.add(driverMarker.copyWith(
        positionParam: _currentAnimatedLocation,
        rotationParam: _currentBearing, 
        flatParam: true, // تأكيد الثبات مع الخريطة
      ));
    });
  }

  @override
  void didUpdateWidget(covariant TrackingMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final locationChanged = widget.driverLocation != oldWidget.driverLocation;
    final routeChanged = widget.driverToPickupData !=
            oldWidget.driverToPickupData ||
        widget.driverToDestinationData != oldWidget.driverToDestinationData ||
        widget.pickupToDropoffData != oldWidget.pickupToDropoffData;

    if (locationChanged) {
      // ⚡ Snap to Path & Calculate Bearing
      final snappedLocation = _getSnappedLocation(widget.driverLocation);

      final activePolyline = _getActivePolyline();
      if (activePolyline.isNotEmpty) {
        // نحدد القطعة من الطريق (Segment) اللي السائق ماشي عليها بالظبط
        final segment = MapUtils.findNearestSegmentOnPolyline(snappedLocation, activePolyline);
        final LatLng p1 = segment[0];
        final LatLng p2 = segment[1];

        // نحسب الدوران بناءً على اتجاه القطعة دي فقط
        final double dist = MapUtils.distanceBetween(p1, p2);
        if (dist > 0.000001) {
          _currentBearing = MapUtils.calculateBearing(p1, p2);
        }
      }

      // ⚡ Animate the marker smoothly
      _animFromLocation = _currentAnimatedLocation;
      _animToLocation = snappedLocation;
      _markerAnimController?.forward(from: 0.0);
    }

    if (routeChanged) {
      // Full map update (polylines, info markers, etc.)
      _updateMap();
    }
  }

  LatLng _getSnappedLocation(LatLng rawLocation) {
    List<LatLng> activePolyline = [];

    if (widget.driverToDestinationData != null) {
      activePolyline = widget.driverToDestinationData!.polylinePoints;
    } else if (widget.driverToPickupData != null) {
      activePolyline = widget.driverToPickupData!.polylinePoints;
    }

    if (activePolyline.isEmpty) return rawLocation;

    return MapUtils.findNearestPointOnPolyline(rawLocation, activePolyline);
  }

  List<LatLng> _getActivePolyline() {
    if (widget.driverToDestinationData != null) {
      return widget.driverToDestinationData!.polylinePoints;
    } else if (widget.driverToPickupData != null) {
      return widget.driverToPickupData!.polylinePoints;
    }
    return [];
  }

  Future<void> _updateMap() async {
    final newPolylines = <Polyline>{};
    final newMarkers = <Marker>{};

    // 1. Polylines
    bool isOnTrip = widget.driverToDestinationData != null;

    if (isOnTrip) {
      newPolylines.add(Polyline(
        polylineId: const PolylineId('active_trip_path'),
        points: widget.driverToDestinationData!.polylinePoints,
        color: AppColors.primaryColor,
        width: 5,
      ));
    } else {
      if (widget.pickupToDropoffData != null) {
        newPolylines.add(Polyline(
          polylineId: const PolylineId('trip_path'),
          points: widget.pickupToDropoffData!.polylinePoints,
          color: AppColors.primaryColor.withOpacity(0.3),
          // Faded background path
          width: 4,
        ));
      }

      if (widget.driverToPickupData != null) {
        newPolylines.add(Polyline(
          polylineId: const PolylineId('driver_path'),
          points: widget.driverToPickupData!.polylinePoints,
          color: Colors.blue,
          width: 5,
        ));
      }
    }

    // 2. Markers (مع cache من MapMarkerHelper)
    final BitmapDescriptor pickupIcon =
        await MapMarkerHelper.createCircleMarkerBitmap(Colors.green,
            isSquare: false);
    final BitmapDescriptor dropoffIcon =
        await MapMarkerHelper.createCircleMarkerBitmap(Colors.red,
            isSquare: true);

    final BitmapDescriptor driverIcon =
        await MapMarkerHelper.createVehicleMarkerBitmap(
            color: widget.carColor, isMotorcycle: widget.isMotorcycle);

    newMarkers.add(Marker(
      markerId: const MarkerId('driver'),
      position: _currentAnimatedLocation,
      icon: driverIcon,
      anchor: const Offset(0.5, 0.5),
      rotation: _currentBearing, 
      flat: true, // يضمن بقاء العربية بمحاذاة الطريق في كل الأوضاع
    ));

    LatLng snappedPickupLocation = widget.pickupLocation;
    LatLng snappedDropoffLocation = widget.dropoffLocation;

    if (widget.pickupToDropoffData != null &&
        widget.pickupToDropoffData!.polylinePoints.isNotEmpty) {
      snappedPickupLocation = widget.pickupToDropoffData!.polylinePoints.first;
      snappedDropoffLocation = widget.pickupToDropoffData!.polylinePoints.last;
    } else if (widget.driverToPickupData != null &&
        widget.driverToPickupData!.polylinePoints.isNotEmpty) {
      snappedPickupLocation = widget.driverToPickupData!.polylinePoints.last;
    }

    if (widget.driverToDestinationData != null &&
        widget.driverToDestinationData!.polylinePoints.isNotEmpty) {
      snappedDropoffLocation =
          widget.driverToDestinationData!.polylinePoints.last;
    }

    // Only show pickup if not on trip
    if (!isOnTrip) {
      newMarkers.add(Marker(
        markerId: const MarkerId('pickup'),
        position: snappedPickupLocation,
        icon: pickupIcon,
        anchor: const Offset(0.5, 0.5),
      ));
    }

    newMarkers.add(Marker(
      markerId: const MarkerId('dropoff'),
      position: snappedDropoffLocation,
      icon: dropoffIcon,
      anchor: const Offset(0.5, 0.5),
    ));

    // 3. Info Markers (ETA/Distance)
    if (isOnTrip && widget.driverToDestinationData != null) {
      // Show ETA to Destination
      final midPoint = widget.driverToDestinationData!.polylinePoints[
          widget.driverToDestinationData!.polylinePoints.length ~/ 2];
      final infoIcon = await MapMarkerHelper.createCustomMarkerBitmap(
        context,
        _formatDuration(widget.driverToDestinationData!.duration),
        _formatDistance(widget.driverToDestinationData!.distance),
      );
      newMarkers.add(Marker(
        markerId: const MarkerId('destination_info'),
        position: midPoint,
        icon: infoIcon,
        anchor: const Offset(0.5, 1.0),
      ));
    } else {
      if (mounted &&
          widget.pickupToDropoffData != null &&
          widget.pickupToDropoffData!.polylinePoints.isNotEmpty) {
        final midPoint = widget.pickupToDropoffData!.polylinePoints[
            widget.pickupToDropoffData!.polylinePoints.length ~/ 2];
        final infoIcon = await MapMarkerHelper.createCustomMarkerBitmap(
          context,
          _formatDuration(widget.pickupToDropoffData!.duration),
          _formatDistance(widget.pickupToDropoffData!.distance),
        );
        newMarkers.add(Marker(
          markerId: const MarkerId('trip_info'),
          position: midPoint,
          icon: infoIcon,
          anchor: const Offset(0.5, 1.0),
        ));
      }

      if (mounted &&
          widget.driverToPickupData != null &&
          widget.driverToPickupData!.polylinePoints.isNotEmpty) {
        final midPoint = widget.driverToPickupData!.polylinePoints[
            widget.driverToPickupData!.polylinePoints.length ~/ 2];
        final infoIcon = await MapMarkerHelper.createCustomMarkerBitmap(
          context,
          _formatDuration(widget.driverToPickupData!.duration),
          _formatDistance(widget.driverToPickupData!.distance),
        );
        newMarkers.add(Marker(
          markerId: const MarkerId('driver_info'),
          position: midPoint,
          icon: infoIcon,
          anchor: const Offset(0.5, 1.0),
        ));
      }
    }

    if (!mounted) return;

    // ✅ نحدّث الـ state مرة واحدة في الآخر بعد كل الحسابات
    setState(() {
      _polylines
        ..clear()
        ..addAll(newPolylines);
      _markers
        ..clear()
        ..addAll(newMarkers);
    });

    _fitBounds();
  }

  String _formatDistance(String? metersStr) {
    if (metersStr == null || metersStr.isEmpty) return '';
    try {
      final meters = double.parse(metersStr);
      final km = meters / 1000;
      return S.of(context).kmSuffix(km.toStringAsFixed(1));
    } catch (e) {
      return metersStr;
    }
  }

  String _formatDuration(String? durationStr) {
    if (durationStr == null || durationStr.isEmpty) return '';
    try {
      final seconds = double.parse(durationStr.replaceAll('s', ''));
      final minutes = (seconds / 60).ceil();
      return S.of(context).minSuffix(minutes);
    } catch (e) {
      return durationStr;
    }
  }

  void _fitBounds() {
    if (_mapController == null) return;

    List<LatLng> allPoints = [];
    if (widget.driverToDestinationData != null) {
      allPoints.addAll(widget.driverToDestinationData!.polylinePoints);
    }
    if (widget.pickupToDropoffData != null &&
        widget.driverToDestinationData == null) {
      allPoints.addAll(widget.pickupToDropoffData!.polylinePoints);
    }
    if (widget.driverToPickupData != null &&
        widget.driverToDestinationData == null) {
      allPoints.addAll(widget.driverToPickupData!.polylinePoints);
    }

    if (allPoints.isEmpty) {
      allPoints = [
        widget.driverLocation,
        widget.pickupLocation,
        widget.dropoffLocation
      ];
    }

    final bounds = MapUtils.getLatLngBounds(allPoints);
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100.r));
  }

  void _goToDriverMode() {
    if (_mapController == null) return;
    setState(() => _isUserMovingCamera = false);
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentAnimatedLocation,
          zoom: 17.5,
          bearing: 0.0, // الخريطة ثابتة والشمال في الأعلى
          tilt: 0.0,
        ),
      ),
    );
  }

  void _startAutoCameraTimer() {
    _autoCameraTimer?.cancel();
    _autoCameraTimer = Timer(const Duration(seconds: 20), () {
      if (mounted) {
        _goToDriverMode();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Listener(
          onPointerDown: (_) {
            // ⚡ Detect actual user touch
            if (widget.onUserInteraction != null) {
              widget.onUserInteraction!();
            }
            if (!_isUserMovingCamera) {
              setState(() => _isUserMovingCamera = true);
            }
            _startAutoCameraTimer();
          },
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.driverLocation,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              MapUtils.applyMapStyle(
                  controller, Theme.of(context).brightness == Brightness.dark);
              _mapController = controller;
              widget.onMapCreated(controller);

              // ⚡ Start in Driver Mode as requested
              _goToDriverMode();

              if (mounted) setState(() => _isMapReady = true);
            },
            onCameraMoveStarted: () {
              // We use Listener's onPointerDown for minimization
              // but we still want to reset timer on any movement
              // that might be gesture-based (like pinch zoom)
              _startAutoCameraTimer();
            },
            markers: _markers,
            polylines: _polylines,
            padding: EdgeInsets.only(bottom: 250.h),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            trafficEnabled: false,
            indoorViewEnabled: false,
            compassEnabled: false,
          ),
        ),
        // ✅ Loading skeleton لحد ما الخريطة تكون جاهزة
        if (!_isMapReady)
          const MapLoadingSkeleton(icon: Icons.location_on_outlined),
      ],
    );
  }
}
