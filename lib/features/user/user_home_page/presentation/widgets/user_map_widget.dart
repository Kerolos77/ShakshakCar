import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/core/utils/shared_widgets/map_utils.dart';

class UserMapWidget extends StatefulWidget {
  const UserMapWidget({
    super.key,
    required this.onMapCreated,
    required this.padding,
    this.onCameraMove,
    this.onCameraIdle,
  });

  final Function(GoogleMapController controller) onMapCreated;
  final bool padding;
  final void Function(CameraPosition position)? onCameraMove;
  final void Function()? onCameraIdle;

  @override
  State<UserMapWidget> createState() => _UserMapWidgetState();
}

class _UserMapWidgetState extends State<UserMapWidget> {
  bool _shouldRenderMap = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _shouldRenderMap = true;
        });
      }
    });
  }

  final CameraPosition _initialLocation = const CameraPosition(
    target: LatLng(26.8206, 30.8025), // إحداثيات جمهورية مصر العربية
    zoom: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    if (!_shouldRenderMap) {
      return const SizedBox.shrink();
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: double.infinity,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialLocation.target,
            zoom: 17.0,
          ),
          trafficEnabled: false,
          indoorViewEnabled: false,
          onMapCreated: (controller) {
            MapUtils.applyMapStyle(
                controller, Theme.of(context).brightness == Brightness.dark);
            widget.onMapCreated(controller);
          },
          compassEnabled: true,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          mapToolbarEnabled: false,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onCameraMove: widget.onCameraMove,
          onCameraIdle: widget.onCameraIdle,
          mapType: MapType.normal,
        ),
      ),
    );
  }
}
