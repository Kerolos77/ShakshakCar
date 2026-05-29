import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/features/user/user_home_page/logic/home_cubit.dart';
import 'package:shakshak/features/user/user_home_page/logic/home_states.dart';

class UserMapWidget extends StatelessWidget {
  final Function() onCameraIdle;
  final Function(CameraPosition) onCameraMove;
  final Function() onCameraMoveStarted;
  final Function(GoogleMapController) onMapCreated;
  final dynamic cubit;

  const UserMapWidget({
    required this.onCameraIdle,
    required this.onCameraMove,
    required this.onCameraMoveStarted,
    required this.onMapCreated,
    required this.cubit,
    required this.cars,
  });

  final List<LatLng> cars;

  Set<Marker> _createCarMarkers() {
    return cars
        .asMap()
        .entries
        .map(
          (entry) => Marker(
            markerId: MarkerId('car_${entry.key}'), // Unique ID for each car
            position: entry.value, // Car's LatLng position
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor
                .hueViolet), // Custom marker color (primary for car)
          ),
        )
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: cubit.mapLocation,
            zoom: 17.0,
          ),
          trafficEnabled: true,
          indoorViewEnabled: true,
          compassEnabled: false,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          mapToolbarEnabled: true,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: onMapCreated,
          onCameraMoveStarted: onCameraMoveStarted,
          onCameraMove: onCameraMove,
          onCameraIdle: onCameraIdle,
          markers: _createCarMarkers(),
        ),
        // ✅ إضافة الهيكل الموحد للتنزيل
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            // نستخدم العلم بتاع الخريطة في الـ cubit أو ببساطة لحد ما الـ controller يجهز
            // في النسخة دي هي stateless، فممكن نعتمد على الـ cubit أفضل أو لو هي جاهزة
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
