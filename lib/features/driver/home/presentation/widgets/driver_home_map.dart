import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:shakshak/core/utils/shared_widgets/map_loading_skeleton.dart';
import 'package:shakshak/core/utils/shared_widgets/map_utils.dart';
import 'package:shakshak/features/driver/home/data/models/demand_map_model.dart';
import 'package:shakshak/features/driver/home/presentation/view_models/driver_home_cubit.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_cubit.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// خريطة شاشة هوم الدرايفر — تعرض موقعه الحالي ومناطق الطلب (بيانات حقيقية من الـ API)
class DriverHomeMap extends StatefulWidget {
  final VoidCallback? onTap;
  const DriverHomeMap({super.key, this.onTap});

  @override
  State<DriverHomeMap> createState() => _DriverHomeMapState();
}

class _DriverHomeMapState extends State<DriverHomeMap> {
  final Completer<GoogleMapController> _controllerCompleter =
      Completer<GoogleMapController>();

  bool _isMapReady = false;
  LatLng _initialPosition = const LatLng(30.0444, 31.2357); // Cairo default fallback
  Timer? _refreshTimer;
  bool _shouldRenderMap = false;

  @override
  void initState() {
    super.initState();
    _initLocation();

    // Delay rendering the actual GoogleMap widget to prevent transition crashes on Android platform views
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _shouldRenderMap = true;
        });
      }
    });
    
    // تحديث خريطة الطلب كل دقيقتين
    _refreshTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      if (mounted) {
        context.read<RideCubit>().fetchDemandMap();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  /// نجيب موقع الدرايفر
  Future<void> _initLocation() async {
    try {
      final location = loc.Location();
      
      // التأكد من تفعيل الخدمة أولاً
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      var hasPermission = await location.hasPermission();
      if (hasPermission == loc.PermissionStatus.denied) {
        hasPermission = await location.requestPermission();
      }
      
      if (hasPermission != loc.PermissionStatus.granted) {
        return;
      }

      // محاولة جلب الموقع مع timeout لتجنب التعليق
      final data = await location.getLocation().timeout(const Duration(seconds: 8));
      
      if (mounted) {
        if (data.latitude != null && data.longitude != null) {
          setState(() {
            _initialPosition = LatLng(data.latitude!, data.longitude!);
          });
        }

        if (_controllerCompleter.isCompleted) {
          final ctrl = await _controllerCompleter.future;
          ctrl.animateCamera(CameraUpdate.newLatLng(_initialPosition));
        }
      }
    } catch (_) {
      // Ignore location errors, map is already rendered at Cairo default fallback
    }
  }

  /// تحويل بيانات الـ API إلى Polygons لعرضها على الخريطة
  Set<Polygon> _buildPolygonsFromData(DemandMapModel? demandMap) {
    if (demandMap == null) return {};

    final polygons = <Polygon>{};
    const double radius = 620.0; // نفس الحجم المستخدم في الباك إند (S)

    for (var hex in demandMap.hexagons) {
      Color color = _getColorForIntensity(hex.intensity);
      
      polygons.add(Polygon(
        polygonId: PolygonId('hex_${hex.id}'),
        points: _generateHexagonPoints(LatLng(hex.lat, hex.lng), radius),
        fillColor: color.withOpacity(0.35),
        strokeColor: color.withOpacity(0.6),
        strokeWidth: 1,
      ));
    }
    return polygons;
  }

  /// حساب نقاط المسدس (Hexagon) حول المركز
  List<LatLng> _generateHexagonPoints(LatLng center, double radiusMeters) {
    const double earthRadius = 6378137.0;
    final List<LatLng> points = [];

    for (int i = 0; i < 6; i++) {
      // 30 degree offset to make it pointy-topped (matching backend logic)
      double angle = (i * 60 + 30) * math.pi / 180;
      double dLat = (radiusMeters * math.sin(angle)) / earthRadius;
      double dLng = (radiusMeters * math.cos(angle)) /
          (earthRadius * math.cos(math.pi * center.latitude / 180));

      points.add(LatLng(
        center.latitude + (dLat * 180 / math.pi),
        center.longitude + (dLng * 180 / math.pi),
      ));
    }
    return points;
  }

  Color _getColorForIntensity(String intensity) {
    switch (intensity) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldRenderMap) {
      return const MapLoadingSkeleton();
    }
    return BlocBuilder<RideCubit, RideState>(
      buildWhen: (prev, curr) => prev.demandMap != curr.demandMap,
      builder: (context, state) {
        final polygons = _buildPolygonsFromData(state.demandMap);
        
        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 15.0, // زوم أوضح لموقع السائق
              ),
              onMapCreated: (controller) {
                MapUtils.applyMapStyle(
                    controller, Theme.of(context).brightness == Brightness.dark);
                if (!_controllerCompleter.isCompleted) {
                  _controllerCompleter.complete(controller);
                }
                if (mounted) setState(() => _isMapReady = true);
              },
              onTap: (latLng) {
                if (widget.onTap != null) widget.onTap!();
              },
              onCameraMoveStarted: () {
                if (widget.onTap != null) widget.onTap!();
              },
              polygons: polygons,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              trafficEnabled: false,
              indoorViewEnabled: false,
              compassEnabled: false,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: false,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
            ),
            
            // Loading Overlay with smooth transition
            if (!_isMapReady)
              const MapLoadingSkeleton(),

            // Offline Overlay
            BlocBuilder<DriverHomeCubit, DriverHomeState>(
              builder: (context, state) {
                final isOnline = context.read<DriverHomeCubit>().isOnline;
                if (isOnline) return const SizedBox.shrink();

                return Positioned.fill(
                  child: IgnorePointer(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? Colors.black.withOpacity(0.7)
                              : Colors.white.withOpacity(0.3),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.wifi_off_rounded, 
                                   color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black45, size: 56.r),
                              SizedBox(height: 16.h),
                              Text(
                                "أنت غير متصل بالإنترنت",
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "لتلقي الطلبات، قم بتفعيل وضع الأونلاين",
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
