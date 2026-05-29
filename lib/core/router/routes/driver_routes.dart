import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/features/driver/earnings/presentation/views/earnings_view.dart';
import 'package:shakshak/features/driver/home/domain/usecases/driver_toggle_online_usecase.dart';
import 'package:shakshak/features/driver/home/domain/usecases/set_driver_destination_usecase.dart';
import 'package:shakshak/features/driver/home/presentation/view_models/driver_home_cubit.dart';
import 'package:shakshak/features/driver/home/presentation/views/driver_home_view.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_cubit.dart';
import 'package:shakshak/features/driver/store/presentation/views/driver_store_view.dart';
import 'package:shakshak/features/driver/online_registration/domain/usecases/get_car_brands_usecase.dart';
import 'package:shakshak/features/driver/online_registration/domain/usecases/get_car_models_usecase.dart';
import 'package:shakshak/features/driver/online_registration/domain/usecases/submit_driver_registration_usecase.dart';
import 'package:shakshak/features/driver/online_registration/presentation/view_models/driver_registration_cubit.dart';
import 'package:shakshak/features/driver/online_registration/views/car_licence_view.dart';
import 'package:shakshak/features/driver/online_registration/views/car_view.dart';
import 'package:shakshak/features/driver/online_registration/views/criminal_record_view.dart';
import 'package:shakshak/features/driver/online_registration/views/driver_online_registration_view.dart';
import 'package:shakshak/features/driver/online_registration/views/licence_view.dart';
import 'package:shakshak/features/driver/online_registration/views/national_id_view.dart';
import 'package:shakshak/features/driver/online_registration/views/registration_pending_view.dart';
import 'package:shakshak/features/driver/outstation/presentation/views/driver_outstation_view.dart';
import 'package:shakshak/features/driver/trip_map/presentation/views/trip_map_view.dart';
import 'package:shakshak/features/driver/vehicle_information/presentation/views/vehicle_information_view.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';

class DriverRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: Routes.driverHomeView,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DriverHomeCubit(
              sl<DriverToggleOnlineUseCase>(),
              sl<SetDriverDestinationUseCase>(),
            ),
          ),
          BlocProvider.value(
            value: sl<RideCubit>()..connectToWebSocket(),
          ),
        ],
        child: const DriverHomeView(),
      ),
    ),
    GoRoute(
      path: Routes.driverOnlineRegistrationView,
      builder: (context, state) => BlocProvider(
        create: (context) => DriverRegistrationCubit(
          sl<SubmitDriverRegistrationUseCase>(),
          sl<GetCarBrandsUseCase>(),
          sl<GetCarModelsUseCase>(),
        ),
        child: const DriverOnlineRegistrationView(),
      ),
    ),
    GoRoute(
      path: Routes.criminalRecordView,
      builder: (context, state) => const CriminalRecordView(),
    ),
    GoRoute(
      path: Routes.nationalIdView,
      builder: (context, state) => const NationalIdView(),
    ),
    GoRoute(
      path: Routes.licenceView,
      builder: (context, state) => const LicenceView(),
    ),
    GoRoute(
      path: Routes.carLicenceView,
      builder: (context, state) => const CarLicenceView(),
    ),
    GoRoute(
      path: Routes.carView,
      builder: (context, state) => BlocProvider.value(
        value: context.read<UserHomeCubit>(),
        child: const CarView(),
      ),
    ),
    GoRoute(
      path: Routes.driverOutstationView,
      builder: (context, state) => const DriverOutstationView(),
    ),
    GoRoute(
      path: Routes.registrationPendingView,
      builder: (context, state) => const RegistrationPendingView(),
    ),
    GoRoute(
      path: Routes.vehicleInformationView,
      builder: (context, state) => BlocProvider.value(
        value: context.read<UserHomeCubit>(),
        child: const VehicleInformationView(),
      ),
    ),
    GoRoute(
      path: Routes.tripMapView,
      builder: (context, state) {
        final args = state.extra as TripMapArgs;
        return TripMapView(ride: args.ride);
      },
    ),
    GoRoute(
      path: Routes.driverEarningsView,
      builder: (context, state) => const EarningsView(),
    ),
    GoRoute(
      path: Routes.driverStoreView,
      builder: (context, state) => const DriverStoreView(),
    ),
  ];
}
