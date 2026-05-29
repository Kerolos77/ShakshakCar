import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';

import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';

import 'package:shakshak/core/utils/shared_widgets/destination_map.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_cubit.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_state.dart';
import 'package:shakshak/features/driver/outstation/presentation/widgets/driver_rides_list_item.dart';
import 'package:shakshak/core/utils/shared_widgets/sos_button.dart';

class TripMapView extends StatelessWidget {
  TripMapView({super.key, required this.ride});

  final NewRideDataEntity ride;
  final Completer<GoogleMapController> mapCompleter =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<RideCubit, RideState>(
      builder: (context, state) {
        // نجيب أحدث نسخة من الرحلة من الـ state (لو الـ Cubit الخارجي شغال)
        final updatedRide = state.rides.cast<NewRideDataEntity>().firstWhere(
              (r) => r.id == ride.id,
              orElse: () => ride,
            );
        final bool isNew = state.newRideIds.contains(updatedRide.id);

        return BaseLayoutView(
          horizontalPadding: 0,
          title: S.of(context).tripMap,
          body: Stack(
            alignment: Alignment.center,
            children: [
              // الخريطة
              DestinationMapWidget(
                onCameraIdle: () {},
                onCameraMove: (p0) {},
                onCameraMoveStarted: () {},
                onMapCreated: (p0) {},
                cubit: context.read<RideCubit>(),
                start: LatLng(
                  updatedRide.sourceLat,
                  updatedRide.sourceLong,
                ),
                end: LatLng(
                  updatedRide.destinationLat,
                  updatedRide.destinationLong,
                ),
                cars: const [],
                driverLocation: context.read<RideCubit>().currentDriverLocation,
              ),

              // نفس الكارد الخارجي بالكامل - إعادة استخدام 100%
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: DriverRidesListItem(
                    key: ValueKey(updatedRide.id),
                    ride: updatedRide,
                    isOutstation: updatedRide.parcelWeight != null,
                    isNew: isNew,
                    showDetailsButton: false,
                    showDismissButton: false,
                  ),
                ),
              ),

              if (updatedRide.status == 'started')
                Positioned(
                  top: 50,
                  right: 20,
                  child: const SOSButton(),
                ),
            ],
          ),
        );
      },
    );
  }
}
