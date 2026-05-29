import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/utils/shared_widgets/select_location/select_destination_map_screen.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/select_destination_widget.dart';
import 'package:shakshak/features/user/saved_places/presentation/cubit/saved_places_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';

class SelectDestinationPage extends StatefulWidget {
  const SelectDestinationPage({
    super.key,
  });

  @override
  State<SelectDestinationPage> createState() => _SelectDestinationPageState();
}

class _SelectDestinationPageState extends State<SelectDestinationPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<LocationCubit>()),
        BlocProvider(
          create: (context) => SavedPlacesCubit(
            getSavedPlacesUseCase: sl(),
            addSavedPlaceUseCase: sl(),
            removeSavedPlaceUseCase: sl(),
            updateSavedPlaceUseCase: sl(),
            getSuggestedPlaceUseCase: sl(),
          )..fetchSavedPlaces(),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SelectDestinationWidget(
          changeMapTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<LocationCubit>(),
                  child: SelectDestinationMapScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
