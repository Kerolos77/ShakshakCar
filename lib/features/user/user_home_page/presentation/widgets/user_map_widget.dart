import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/core/utils/shared_widgets/map_utils.dart';

class UserMapWidget extends StatelessWidget {
  const UserMapWidget({
    super.key,
    required this.onMapCreated,
    required this.padding,
    this.onCameraMove,
    this.onCameraIdle,
  });

  final CameraPosition _initialLocation = const CameraPosition(
    target: LatLng(26.8206, 30.8025), // إحداثيات جمهورية مصر العربية
    zoom: 20.0,
  );
  final Function(GoogleMapController controller) onMapCreated;
  final bool padding;
  final void Function(CameraPosition position)? onCameraMove;
  final void Function()? onCameraIdle;

  @override
  Widget build(BuildContext context) {
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
            onMapCreated(controller);
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
          onCameraMove: onCameraMove,
          onCameraIdle: onCameraIdle,
          mapType: MapType.normal,
        ),
      ),
    );
  }
}
