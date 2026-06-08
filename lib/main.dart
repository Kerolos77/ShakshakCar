import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:shakshak/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/router/app_router.dart';
import 'package:shakshak/core/services/link_handler_service.dart';
import 'package:shakshak/core/services/notification_service.dart';
import 'package:shakshak/core/utils/shared_widgets/map_marker_helper.dart';

import 'core/constants/api_const.dart';
import 'core/constants/app_const.dart';
import 'core/network/dio_helper/dio_helper.dart';
import 'core/network/local/cache_helper.dart';
import 'core/resources/app_colors.dart';
import 'core/services/real_time/realtime_manager.dart';
import 'core/services/service_locator.dart';
import 'core/services/background_location_service.dart';
import 'core/utils/bloc_observer.dart';
import 'package:shakshak/features/shared/base_layout/presentation/view_models/drawer_cubit/drawer_cubit.dart';
import 'package:shakshak/features/driver/online_registration/presentation/view_models/driver_registration_cubit.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'package:shakshak/features/shared/settings/presentation/view_models/language_cubit/language_cubit.dart';
import 'package:shakshak/features/shared/settings/presentation/view_models/theme_cubit/theme_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/country_city_cubit/countries_cities_cubit.dart';
import 'package:shakshak/features/shared/notifications/presentation/manager/notification_cubit.dart';
import 'package:shakshak/features/shared/loyalty/presentation/view_models/loyalty_cubit.dart';
import 'package:shakshak/core/services/user_storage_service.dart';
import 'package:shakshak/features/shared/authentication/data/models/profile_model.dart';
import 'package:shakshak/core/network/network_info/network_cubit.dart';
import 'package:shakshak/core/utils/shared_widgets/global_network_banner.dart';
import 'generated/l10n.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.onBackgroundMessage(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (Required before Crashlytics initialization)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configure Crashlytics to catch all Flutter errors
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Catch uncaught asynchronous errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));

  await initialization();
  runApp(const MyApp());
  NotificationService.checkInitialMessage();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => DrawerCubit(),
            ),
            BlocProvider(
              create: (context) => LanguageCubit(),
            ),
            BlocProvider(
              create: (context) => ThemeCubit(),
            ),
            BlocProvider(
              create: (context) => sl<DriverRegistrationCubit>(),
            ),
            BlocProvider(
              create: (_) => UserHomeCubit(
                getCaptionsUseCase: sl(),
                getInCityServicesUseCase: sl(),
                getOutCityServicesUseCase: sl(),
                acceptOfferUseCase: sl(),
                denyOfferUseCase: sl(),
                cancelOrderUseCase: sl(),
                getPriceUseCase: sl(),
                newRideRequestUseCase: sl(),
                getRideDetailsUseCase: sl(),
                getActiveRideUseCase: sl(),
              ),
            ),
            BlocProvider(
              create: (context) => LocationCubit(sl()),
            ),
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
              create: (context) => sl<NotificationCubit>(),
            ),
            BlocProvider(
              create: (context) => sl<NetworkCubit>(),
            ),
            BlocProvider(
              create: (context) => sl<LoyaltyCubit>(),
            ),
          ],
          child: BlocBuilder<LanguageCubit, LanguageState>(
            buildWhen: (previous, current) =>
                current is LanguageChangeLangState,
            builder: (context, state) {
              return BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, themeState) {
                  final themeCubit = context.read<ThemeCubit>();
                  return MaterialApp.router(
                    theme: themeCubit.themeData,
                    darkTheme: AppColors.darkTheme,
                    themeMode: themeCubit.state.themeMode == AppThemeMode.dark
                        ? ThemeMode.dark
                        : ThemeMode.light,
                    localizationsDelegates: const [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: S.delegate.supportedLocales,
                    locale: Locale(AppConstant.currentLanguage),
                    debugShowCheckedModeBanner: false,
                    routerConfig: AppRouter.routers,
                    builder: (context, child) {
                      return GlobalNetworkBanner(child: child!);
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

Future<void> initialization() async {
  // Firebase already initialized in main() to catch errors early

  // Configure Firebase services
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  FirebasePerformance.instance.setPerformanceCollectionEnabled(true);

  await ServiceLocator().init();
  await CacheHelper.init();
  await DioHelper.init();
  await sl<NotificationService>().init();
  await LinkHandlerService().init();
  await sl<CountriesCitiesCubit>().getCountries();

  // Initialize the headless background service
  await BackgroundLocationService().initializeService();

  AppConstant.currentLanguage =
      CacheHelper.getData(key: AppConstant.kCurrentLanguage) ?? 'en';

  // Set test token for Driver location updates
  // sl<LocationService>()
  //     .setTestToken("258|cP17juzglDsOTmr2WzD2lGomHx4pCGbRlr6ATdvW3a4eb6da");
  // Start background location tracking (Moved to Driver Online toggle as per new architecture)
  // sl<LocationService>().startTracking();

  if (CacheHelper.getData(key: AppConstant.kToken) != null) {
    debugPrint("🚀 User logged in, connecting to WebSocket...");
    sl<RealtimeManager>().connect(url: ApiConstant.realTimeBaseUrl);

    // Initialize NotificationCubit if user data exists
    final user = UserStorageService.getUser();
    if (user != null) {
      sl<NotificationCubit>().init(user);
    }
  }

  // ✅ تحميل مسبق للأيقونات عشان الخرائط تبقى سريعة جداً
  await MapMarkerHelper.preloadCommonMarkers();
}
