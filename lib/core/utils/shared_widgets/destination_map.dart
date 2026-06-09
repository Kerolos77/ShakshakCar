import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/services/google_maps_service.dart';
import 'package:shakshak/generated/l10n.dart';

import 'map_marker_helper.dart';
import 'map_utils.dart';
import 'map_loading_skeleton.dart';

class DestinationMapWidget extends StatefulWidget {
  final Function() onCameraIdle;
  final Function(CameraPosition) onCameraMove;
  final Function() onCameraMoveStarted;
  final Function(GoogleMapController) onMapCreated;
  final dynamic cubit;
  final List<LatLng> cars;
  final LatLng? start;
  final LatLng? end;
  final LatLng? driverLocation;
  final bool testMode;
  final bool userMap;

  const DestinationMapWidget({
    super.key,
    required this.onCameraIdle,
    required this.onCameraMove,
    required this.onCameraMoveStarted,
    required this.onMapCreated,
    required this.cubit,
    required this.cars,
    this.start,
    this.end,
    this.driverLocation,
    this.userMap = false,
    this.testMode = false,
  });

  @override
  State<DestinationMapWidget> createState() => _UserMapWidgetState();
}

class _UserMapWidgetState extends State<DestinationMapWidget> {
  final Set<Polyline> _polylines = {};
  final Set<Marker> _extraMarkers = {};
  GoogleMapController? _mapController;
  final GoogleMapsService _mapsService = GoogleMapsService();

  // ✅ نتابع حالة التحميل لإظهار مؤشر للمستخدم
  bool _isLoadingRoute = false;
  // ✅ نمنع استدعاء _loadRoute مرتين في نفس الوقت
  bool _hasLoadedOnce = false;
  // ✅ الخريطة نفسها لسا مش جاهزة
  bool _isMapReady = false;
  BitmapDescriptor? _driverIcon3D;
  bool _shouldRenderMap = false;

  @override
  void initState() {
    super.initState();
    _loadDriverIcon();
    // Delay rendering the actual GoogleMap widget to prevent transition crashes on Android platform views
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _shouldRenderMap = true;
        });
      }
    });
    // ✅ نحمّل الـ route مرة واحدة هنا فقط (لا نكررها في onMapCreated)
    if (widget.start != null && widget.end != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadRoute();
      });
    }
  }

  Future<void> _loadDriverIcon() async {
    try {
      final icon = await MapMarkerHelper.create3DCarMarkerBitmap();
      if (mounted) {
        setState(() {
          _driverIcon3D = icon;
        });
      }
    } catch (e) {
      debugPrint("Error loading 3D car marker: $e");
    }
  }

  @override
  void didUpdateWidget(covariant DestinationMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.start != oldWidget.start || widget.end != oldWidget.end) {
      _hasLoadedOnce = false;
      _loadRoute();
    }
    if (widget.driverLocation != oldWidget.driverLocation && widget.driverLocation != null) {
      _animateToDriverLocation();
    }
  }

  Set<Marker> _createCarMarkers() {
    return widget.cars
        .asMap()
        .entries
        .map(
          (entry) => Marker(
            markerId: MarkerId('car_${entry.key}'),
            position: entry.value,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet,
            ),
          ),
        )
        .toSet();
  }

  Future<void> _loadRoute() async {
    if (widget.start == null || widget.end == null) {
      if (mounted) {
        setState(() {
          _polylines.clear();
          _extraMarkers.clear();
          _isLoadingRoute = false;
        });
      }
      return;
    }

    // ✅ نمنع الاستدعاء المزدوج
    if (_isLoadingRoute) return;

    if (mounted) setState(() => _isLoadingRoute = true);

    List<LatLng> tripPolylinePoints = [];
    List<LatLng> driverToPickupPoints = [];
    String? routeDistance;
    String? routeDuration;

    // ✅ Markers: مُخزَّنة في Cache من أول مرة – لا تُعاد
    final BitmapDescriptor startIcon =
        await MapMarkerHelper.createCircleMarkerBitmap(Colors.green,
            isSquare: false);
    final BitmapDescriptor endIcon =
        await MapMarkerHelper.createCircleMarkerBitmap(Colors.red,
            isSquare: true);

    if (widget.testMode) {
      tripPolylinePoints = [widget.start!, widget.end!];
      if (widget.driverLocation != null) {
        driverToPickupPoints = [widget.driverLocation!, widget.start!];
      }
    } else {
      // ✅ Route API: مُخزَّنة في Cache – لا تُعاد لنفس المسار
      final tripRoute = await _mapsService.fetchRoute(
        start: widget.start!,
        end: widget.end!,
      );
      if (tripRoute != null) {
        tripPolylinePoints = tripRoute.polylinePoints;
        if (mounted) {
          routeDistance = _formatDistance(tripRoute.distance);
          routeDuration = _formatDuration(tripRoute.duration);
        }
      } else {
        tripPolylinePoints = [widget.start!, widget.end!];
      }

      if (widget.driverLocation != null) {
        final driverRoute = await _mapsService.fetchRoute(
          start: widget.driverLocation!,
          end: widget.start!,
        );
        if (driverRoute != null) {
          driverToPickupPoints = driverRoute.polylinePoints;
        } else {
          driverToPickupPoints = [widget.driverLocation!, widget.start!];
        }
      }
    }

    BitmapDescriptor? infoIcon;
    if (mounted && (routeDistance != null || routeDuration != null)) {
      infoIcon = await MapMarkerHelper.createCustomMarkerBitmap(
          context, routeDuration ?? '', routeDistance ?? '');
    }

    if (!mounted) return;

    setState(() {
      _isLoadingRoute = false;
      _hasLoadedOnce = true;
      _polylines.clear();
      _extraMarkers.clear();

      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route_trip'),
          points: tripPolylinePoints,
          color: AppColors.primaryColor,
          width: 5,
        ),
      );

      if (driverToPickupPoints.isNotEmpty) {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route_driver'),
            points: driverToPickupPoints,
            color: Colors.blue,
            width: 4,
            patterns: [PatternItem.dash(20), PatternItem.gap(10)],
          ),
        );
      }

      _extraMarkers.add(Marker(
        markerId: const MarkerId('start'),
        position: widget.start!,
        icon: startIcon,
        anchor: const Offset(0.5, 0.5),
      ));
      _extraMarkers.add(Marker(
        markerId: const MarkerId('end'),
        position: widget.end!,
        icon: endIcon,
        anchor: const Offset(0.5, 0.5),
      ));

      if (tripPolylinePoints.isNotEmpty && infoIcon != null) {
        final LatLng midPoint =
            tripPolylinePoints[tripPolylinePoints.length ~/ 2];
        _extraMarkers.add(
          Marker(
            markerId: const MarkerId('route_info'),
            position: midPoint,
            icon: infoIcon,
            anchor: const Offset(0.5, 1.0),
          ),
        );
      }
    });

    // ✅ نحرك الكاميرا بعد ما تتأكد الخريطة جاهزة
    if (_mapController != null) {
      final List<LatLng> allPoints = [
        ...tripPolylinePoints,
        ...driverToPickupPoints
      ];
      if (allPoints.isNotEmpty) {
        final bounds = MapUtils.getLatLngBounds(allPoints);
        _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 80.r),
        );
      }
    }
  }

  void _animateToDriverLocation() {
    if (_mapController == null || widget.driverLocation == null) return;

    double bearing = 0.0;
    if (widget.cubit != null) {
      try {
        bearing = widget.cubit.state.currentBearing;
      } catch (_) {}
    }

    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: widget.driverLocation!,
          zoom: 17.0, // High zoom for active driving navigation
          bearing: bearing,
          tilt: 45.0, // 3D perspective
        ),
      ),
    );
  }

  String _formatDistance(String? dist) {
    if (dist == null) return '';
    int meters = int.tryParse(dist) ?? 0;
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} ${S.of(context).km}';
    } else {
      return '$meters m';
    }
  }

  String _formatDuration(String? dur) {
    if (dur == null) return '';
    if (dur.endsWith('s')) {
      int seconds = int.tryParse(dur.replaceAll('s', '')) ?? 0;
      int minutes = (seconds / 60).ceil();
      return '$minutes ${S.of(context).min}';
    } else {
      return dur;
    }
  }

  Set<Marker> _buildAllMarkers() {
    final Set<Marker> allMarkers = {..._createCarMarkers(), ..._extraMarkers};
    
    // Ensure we don't have a static driver marker
    allMarkers.removeWhere((m) => m.markerId.value == 'driver');

    if (widget.driverLocation != null) {
      double bearing = 0.0;
      if (widget.cubit != null) {
        try {
          bearing = widget.cubit.state.currentBearing;
        } catch (_) {}
      }
      allMarkers.add(Marker(
        markerId: const MarkerId('driver'),
        position: widget.driverLocation!,
        icon: _driverIcon3D ?? BitmapDescriptor.defaultMarker,
        anchor: const Offset(0.5, 0.5),
        rotation: bearing,
        flat: true,
        infoWindow: const InfoWindow(title: "My Location"),
      ));
    }
    return allMarkers;
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldRenderMap) {
      return const MapLoadingSkeleton();
    }
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.driverLocation ??
                widget.start ??
                const LatLng(30.1377568, 31.3285276),
            zoom: 14.0,
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.45,
          ),
          onMapCreated: (controller) {
            MapUtils.applyMapStyle(
                controller, Theme.of(context).brightness == Brightness.dark);
            _mapController = controller;
            widget.onMapCreated(controller);
            if (mounted) setState(() => _isMapReady = true);
            // ✅ نحرك الكاميرا فقط لو الـ route كانت محملة مسبقاً
            if (_hasLoadedOnce) {
              final allPts = _polylines.expand((p) => p.points).toList();
              if (allPts.isNotEmpty) {
                final bounds = MapUtils.getLatLngBounds(allPts);
                controller
                    .animateCamera(CameraUpdate.newLatLngBounds(bounds, 80.r));
              }
            }
          },
          trafficEnabled: false,
          indoorViewEnabled: false,
          compassEnabled: false,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          mapToolbarEnabled: false,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
          myLocationEnabled: widget.userMap,
          myLocationButtonEnabled: false,
          onCameraMoveStarted: widget.onCameraMoveStarted,
          onCameraMove: widget.onCameraMove,
          onCameraIdle: widget.onCameraIdle,
          markers: _buildAllMarkers(),
          polylines: _polylines,
          liteModeEnabled: false, // ✅ Full mode للـ interactivity
        ),

        // ✅ Loading skeleton يظهر لحد ما الخريطة نفسها تتحمل
        if (!_isMapReady) const MapLoadingSkeleton(),

        // ✅ Loading indicator شفّاف فوق الخريطة عند تحميل المسار
        if (_isLoadingRoute)
          Positioned(
            top: 16.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16.r,
                      height: 16.r,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    8.pw,
                    Text(
                      'جارٍ تحميل المسار...',
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
