import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:shakshak/core/utils/shared_widgets/destination_map.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_states.dart';

class BookRideMap extends StatelessWidget {
  final LocationCubit locationCubit;
  final Function(GoogleMapController) onMapCreated;

  const BookRideMap({
    super.key,
    required this.locationCubit,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      buildWhen: (previous, current) => current is NearbyDriversSuccess,
      builder: (context, state) {
        final cubit = context.read<LocationCubit>();
        return DestinationMapWidget(
          onCameraIdle: () {},
          onCameraMove: (CameraPosition position) {},
          onCameraMoveStarted: () {},
          onMapCreated: (controller) {
            onMapCreated(controller);
            // ✅ نأخّر استدعاء API عشان الخريطة تظهر الأول
            Future.delayed(Duration.zero, () {
              cubit.getNearbyDrivers();
            });
          },
          cubit: cubit,
          start: LatLng(
            locationCubit.sourcePlace?.lat ?? 0,
            locationCubit.sourcePlace?.lng ?? 0,
          ),
          end: LatLng(
            locationCubit.destinationPlace?.lat ?? 0,
            locationCubit.destinationPlace?.lng ?? 0,
          ),
          cars: cubit.nearbyDrivers,
        );
      },
    );
  }
}
