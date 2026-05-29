import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/country_city_cubit/countries_cities_cubit.dart';
import 'package:shakshak/features/shared/authentication/presentation/views/login_view.dart';
import 'package:shakshak/features/shared/authentication/presentation/views/otp_view.dart';
import 'package:shakshak/features/shared/authentication/presentation/views/edit_profile_view.dart';
import 'package:shakshak/features/shared/authentication/presentation/views/profile_view.dart';
import 'package:shakshak/features/shared/authentication/presentation/views/register_view.dart';
import 'package:shakshak/features/shared/authentication/presentation/views/role_selection_view.dart';

class AuthRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: Routes.roleSelectionView,
      builder: (context, state) => BlocProvider(
        create: (context) => AuthCubit(
          loginUseCase: sl(),
          signupUseCase: sl(),
          verifyPhoneOtpUseCase: sl(),
          getProfileUseCase: sl(),
          updateProfileUseCase: sl(),
        ),
        child: RoleSelectionView(),
      ),
    ),
    GoRoute(
      path: Routes.loginView,
      builder: (context, state) => BlocProvider(
        create: (context) => AuthCubit(
          loginUseCase: sl(),
          signupUseCase: sl(),
          verifyPhoneOtpUseCase: sl(),
          getProfileUseCase: sl(),
          updateProfileUseCase: sl(),
        ),
        child: LoginView(),
      ),
    ),
    GoRoute(
      path: Routes.otpView,
      builder: (context, state) {
        final args = state.extra as OtpRouteArgs;
        return BlocProvider(
          create: (context) => AuthCubit(
            loginUseCase: sl(),
            signupUseCase: sl(),
            verifyPhoneOtpUseCase: sl(),
            getProfileUseCase: sl(),
            updateProfileUseCase: sl(),
          ),
          child: OtpView(
            phoneNumber: args.phoneNumber,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.registerView,
      builder: (context, state) {
        final args = state.extra as RegisterRouteArgs;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthCubit(
                loginUseCase: sl(),
                signupUseCase: sl(),
                verifyPhoneOtpUseCase: sl(),
                getProfileUseCase: sl(),
                updateProfileUseCase: sl(),
              ),
            ),
            BlocProvider(
              create: (context) => CountriesCitiesCubit(
                  getCountriesUseCase: sl(), getCitiesUseCase: sl()),
            ),
          ],
          child: RegisterView(
            phoneNumber: args.phoneNumber,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.profileView,
      builder: (context, state) => BlocProvider(
        create: (context) => AuthCubit(
          loginUseCase: sl(),
          signupUseCase: sl(),
          verifyPhoneOtpUseCase: sl(),
          getProfileUseCase: sl(),
          updateProfileUseCase: sl(),
        ),
        child: const ProfileView(),
      ),
    ),
    GoRoute(
      path: Routes.editProfileView,
      builder: (context, state) => BlocProvider(
        create: (context) => AuthCubit(
          loginUseCase: sl(),
          signupUseCase: sl(),
          verifyPhoneOtpUseCase: sl(),
          getProfileUseCase: sl(),
          updateProfileUseCase: sl(),
        ),
        child: const EditProfileView(),
      ),
    ),
  ];
}
