import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';

class UserMapWidget extends StatefulWidget {
  final Function() onCameraIdle;
  final Function(CameraPosition) onCameraMove;
  final Function() onCameraMoveStarted;
  final Function(GoogleMapController) onMapCreated;
  final LocationCubit cubit;

  const UserMapWidget({
    super.key,
    required this.onCameraIdle,
    required this.onCameraMove,
    required this.onCameraMoveStarted,
    required this.onMapCreated,
    required this.cubit,
  });

  @override
  State<UserMapWidget> createState() => _UserMapWidgetState();
}

class _UserMapWidgetState extends State<UserMapWidget> {
  final Set<Marker> _markers = {};
  bool _isMapReady = false;
  bool _shouldRenderMap = false;

  @override
  void initState() {
    super.initState();
    _loadInitialMarker();

    // Delay rendering the actual GoogleMap widget to prevent transition crashes on Android platform views
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _shouldRenderMap = true;
        });
      }
    });
  }

  void _loadInitialMarker() {
    if (widget.cubit.isSourceSelected &&
        widget.cubit.sourcePlace != null &&
        widget.cubit.sourcePlace!.lat != null) {
      _addMarker(
        LatLng(widget.cubit.sourcePlace!.lat!, widget.cubit.sourcePlace!.lng!),
      );
    } else if (!widget.cubit.isSourceSelected &&
        widget.cubit.destinationPlace != null &&
        widget.cubit.destinationPlace!.lat != null) {
      _addMarker(
        LatLng(widget.cubit.destinationPlace!.lat!,
            widget.cubit.destinationPlace!.lng!),
      );
    }
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            widget.cubit.isSourceSelected
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueRed,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldRenderMap) {
      return _MapLoadingSkeleton();
    }
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.cubit.mapLocation,
            zoom: 17.0,
          ),
          // ✅ تعطيل الـ features الثقيلة لتسريع التحميل
          trafficEnabled: false,
          indoorViewEnabled: false,
          compassEnabled: false,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          mapToolbarEnabled: false,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (controller) {
            widget.onMapCreated(controller);
            if (mounted) setState(() => _isMapReady = true);
          },
          onCameraMoveStarted: widget.onCameraMoveStarted,
          onCameraMove: widget.onCameraMove,
          onCameraIdle: widget.onCameraIdle,
          onLongPress: (LatLng position) async {
            widget.cubit.selectPlace(
                isSource: widget.cubit.isSourceSelected,
                lat: position.latitude,
                lng: position.longitude);
            _addMarker(position);
          },
          markers: _markers,
        ),
        // ✅ Loading skeleton يظهر لحد ما الخريطة تكون جاهزة
        if (!_isMapReady) _MapLoadingSkeleton(),
      ],
    );
  }
}

/// Skeleton بسيط يظهر فوق الخريطة لحد ما تتحمل
class _MapLoadingSkeleton extends StatefulWidget {
  @override
  State<_MapLoadingSkeleton> createState() => _MapLoadingSkeletonState();
}

class _MapLoadingSkeletonState extends State<_MapLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Container(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(_animation.value),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.map_outlined,
                  size: 48,
                  color: Theme.of(context).hintColor.withOpacity(0.5)),
              const SizedBox(height: 12),
              Text(
                S.of(context).loadingMap,
                style:
                    TextStyle(color: Theme.of(context).hintColor, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
