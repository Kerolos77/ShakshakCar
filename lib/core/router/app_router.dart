import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/router/routes.dart';

import 'routes/auth_routes.dart';
import 'routes/driver_routes.dart';
import 'routes/shared_routes.dart';
import 'routes/user_routes.dart';

abstract class AppRouter {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerState =
      GlobalKey<ScaffoldMessengerState>();
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext get globalContext => navigatorKey.currentContext!;

  static final routers = GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    initialLocation: _getInitialLocation(),
    redirect: (context, state) {
      final uri = state.uri;
      // Detect Google Maps URLs
      if (uri.host.contains('google.com') ||
          uri.host.contains('goo.gl') ||
          uri.path.startsWith('/maps')) {
        if (state.fullPath != Routes.bookRide) {
          return Uri(
            path: Routes.bookRide,
            queryParameters: {'url': uri.toString()},
          ).toString();
        }
      }
      return null;
    },
    routes: <RouteBase>[
      ...AuthRoutes.routes,
      ...SharedRoutes.routes,
      ...DriverRoutes.routes,
      ...UserRoutes.routes,
    ],
  );
}

String _getInitialLocation() {
  bool isOnBoarding =
      CacheHelper.getData(key: AppConstant.kOnBoarding) ?? false;
  String? token = CacheHelper.getData(key: AppConstant.kToken);
  int? isIsDriver = CacheHelper.getData(key: AppConstant.kIsDriver);

  if (!isOnBoarding) {
    return Routes.onBoardingView;
  }

  if (token != null) {
    if (isIsDriver == 1) {
      return Routes.driverHomeView;
    } else {
      return Routes.userHomeView;
    }
  } else {
    return Routes.loginView;
  }
}
