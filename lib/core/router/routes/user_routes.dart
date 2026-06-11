import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/payment_cubit.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/utils/shared_widgets/select_location/select_destination_map_screen.dart';
import 'package:shakshak/features/shared/rides/domain/usecases/get_rides_usecase.dart';
import 'package:shakshak/features/shared/rides/presentation/view_models/rides_cubit.dart';
import 'package:shakshak/features/user/outstation/presentation/views/out_station_view.dart';
import 'package:shakshak/features/user/ride_tracking/presentation/view_models/ride_tracking_cubit.dart';
import 'package:shakshak/features/user/saved_places/presentation/cubit/saved_places_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/views/book_ride.dart';
import 'package:shakshak/features/user/user_home/presentation/views/drive_details_view.dart';
import 'package:shakshak/features/user/user_home/presentation/views/offers_view.dart';
import 'package:shakshak/features/user/user_home/presentation/views/user_home_view.dart';
import 'package:shakshak/features/user/user_home/presentation/views/ride_payment_webview_screen.dart';
import 'package:shakshak/features/user/user_home_page/presentation/screen/select_destination_page.dart';
import 'package:shakshak/features/user/user_home_page/presentation/screen/user_home_page.dart';
import 'package:shakshak/features/user/store/presentation/views/user_store_view.dart';
import 'package:shakshak/features/user/presentation/views/user_identity_verification_view.dart';

class UserRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: Routes.userIdentityVerificationView,
      builder: (context, state) => const UserIdentityVerificationView(),
    ),
    GoRoute(
      path: Routes.userStoreView,
      builder: (context, state) => const UserStoreView(),
    ),
    GoRoute(
      path: Routes.userHomeView,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<UserHomeCubit>(),
          ),
          BlocProvider(
            create: (context) => RidesCubit(sl<GetSharedRidesUseCase>()),
          ),
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
        child: const UserHomeView(),
      ),
    ),
    GoRoute(
      path: Routes.userHomePage,
      builder: (context, state) => const UserHomePage(),
    ),
    GoRoute(
      path: Routes.selectDestinationPage,
      builder: (context, state) => const SelectDestinationPage(),
    ),
    GoRoute(
      path: Routes.selectDestinationMapScreen,
      builder: (context, state) {
        return BlocProvider.value(
          value: context.read<LocationCubit>(),
          child: const SelectDestinationMapScreen(),
        );
      },
    ),
    GoRoute(
      path: Routes.outStationView,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<UserHomeCubit>(),
          ),
          BlocProvider(
            create: (context) => LocationCubit(sl())..getMyLocation(),
          ),
        ],
        child: const OutStationView(),
      ),
    ),
    GoRoute(
      path: Routes.bookRide,
      builder: (context, state) {
        final args = state.extra as BookRideArgs?;
        final latParam = state.uri.queryParameters['lat'];
        final lngParam = state.uri.queryParameters['lng'];
        final googleMapsUrl = state.uri.queryParameters['url'];

        final processedArgs = args ??
            BookRideArgs(
              latParam: latParam,
              lngParam: lngParam,
              googleMapsUrl: googleMapsUrl,
            );

        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<UserHomeCubit>()),
            BlocProvider(
              create: (context) => PaymentCubit(sl(), sl(), sl(), sl(), sl())..getSavedCards(),
            ),
          ],
          child: BookRide(args: processedArgs),
        );
      },
    ),
    GoRoute(
      path: Routes.offersView,
      builder: (context, state) {
        final args = state.extra as OffersViewArgs;

        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: context.read<UserHomeCubit>()
                ..connect(args.newRideData.id, args.newRideData.user.id,
                    tripPrice: args.newRideData.amount),
            ),
            BlocProvider.value(
              value: context.read<LocationCubit>(),
            ),
            // ⚡ Create RideTrackingCubit HERE at the Offers stage so it connects
            // to realtime immediately and is ready before the user enters RideTrackingView
            BlocProvider(
              create: (context) => RideTrackingCubit(ride: args.newRideData),
            ),
          ],
          child: OffersView(
            newRideData: args.newRideData,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.driveDetailsView,
      builder: (context, state) {
        final args = state.extra as DriveDetailsViewArgs;
        // ⚡ If a RideTrackingCubit was passed from the Offers page,
        // wrap the view with it so the Track page reuses the same cubit
        // instead of creating a new one from scratch.
        if (args.trackingCubit != null) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: args.trackingCubit!),
              BlocProvider(
                create: (context) => PaymentCubit(sl(), sl(), sl(), sl(), sl())..getSavedCards(),
              ),
            ],
            child: DriveDetailsView(ride: args.ride),
          );
        }
        return BlocProvider(
          create: (context) => PaymentCubit(sl(), sl(), sl(), sl(), sl())..getSavedCards(),
          child: DriveDetailsView(ride: args.ride),
        );
      },
    ),
    GoRoute(
      path: Routes.ridePaymentWebView,
      builder: (context, state) {
        final args = state.extra as RidePaymentWebViewArgs;
        return RidePaymentWebViewScreen(
          checkoutUrl: args.checkoutUrl,
          orderId: args.orderId,
          isAddingCard: args.isAddingCard,
        );
      },
    ),
  ];
}
