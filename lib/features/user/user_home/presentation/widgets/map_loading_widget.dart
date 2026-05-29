import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/core/utils/shared_widgets/destination_map.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';

class MapWithLoadingOverlay extends StatefulWidget {
  final LocationCubit locationCubit;
  final Function(GoogleMapController) onMapCreated;

  const MapWithLoadingOverlay({
    super.key,
    required this.locationCubit,
    required this.onMapCreated,
  });

  @override
  State<MapWithLoadingOverlay> createState() => _MapWithLoadingOverlayState();
}

class _MapWithLoadingOverlayState extends State<MapWithLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rippleController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200), // Ù‡Ø§Ø¯ÙŠ ÙˆÙ…Ø±ÙŠØ­
  )..repeat(); // âœ… Ripple Ù„Ø§Ø²Ù… ØªÙ…Ø´ÙŠ Ù„Ù„Ø£Ù…Ø§Ù… (Ø¨Ø¯ÙˆÙ† reverse)

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showLoading = widget.locationCubit.nearbyDrivers.isEmpty;

    final start = LatLng(
      widget.locationCubit.sourcePlace?.lat ?? 0,
      widget.locationCubit.sourcePlace?.lng ?? 0,
    );

    final end = LatLng(
      widget.locationCubit.destinationPlace?.lat ?? 0,
      widget.locationCubit.destinationPlace?.lng ?? 0,
    );

    return Stack(
      children: [
        DestinationMapWidget(
          onCameraIdle: () {},
          onCameraMove: (CameraPosition position) {},
          onCameraMoveStarted: () {},
          onMapCreated: (controller) {
            widget.onMapCreated(controller);
          },
          cubit: widget.locationCubit,
          start: start,
          end: end,
          cars: widget.locationCubit.nearbyDrivers,
        ),
        // if (showLoading)
        // IgnorePointer(
        //   ignoring: false,
        //   child: MapLoadingOverlay(controller: _rippleController),
        // ),
      ],
    );
  }
}
