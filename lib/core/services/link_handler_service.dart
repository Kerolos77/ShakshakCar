import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/router/app_router.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/services/trip_storage_service.dart';
import 'package:shakshak/core/utils/google_maps_resolver.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';

class LinkHandlerService {
  static final LinkHandlerService _instance = LinkHandlerService._internal();
  factory LinkHandlerService() => _instance;
  LinkHandlerService._internal();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  /// Initializes deep link listening.
  Future<void> init() async {
    // 1. Handle the initial link (Cold Start)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }
    } catch (e) {
      debugPrint('Error getting initial link: $e');
    }

    // 2. Handle subsequent links (Warm Start)
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) => _handleUri(uri),
      onError: (err) => debugPrint('Link stream error: $err'),
    );
  }

  /// Central logic for processing URIs.
  Future<void> _handleUri(Uri uri) async {
    final String url = uri.toString();
    debugPrint('Received Deep Link: $url');

    // 1. Check if it's an order tracking link
    final orderId = _extractOrderId(uri);
    if (orderId != null) {
      await _handleTrackingLink(orderId);
      return;
    }

    // 2. Resolve coordinates from any supported Google Maps link or scheme
    final coords = await GoogleMapsUrlResolver.getCoordinatesFromUrl(url);

    if (coords != null) {
      _navigateToBooking(coords.latitude, coords.longitude);
    } else {
      // If parsing fails but it's clearly a map link, fallback to manual selection
      if (url.contains('google.com/maps') ||
          url.contains('goo.gl') ||
          url.startsWith('geo:')) {
        _navigateToBookingWithFallback();
      }
    }
  }

  int? _extractOrderId(Uri uri) {
    if (uri.queryParameters.containsKey('order_id')) {
      return int.tryParse(uri.queryParameters['order_id']!);
    }
    if (uri.queryParameters.containsKey('id')) {
      return int.tryParse(uri.queryParameters['id']!);
    }
    if (uri.host == 'track' && uri.pathSegments.isNotEmpty) {
      return int.tryParse(uri.pathSegments.first);
    }
    final index = uri.pathSegments.indexOf('track');
    if (index != -1 && index + 1 < uri.pathSegments.length) {
      return int.tryParse(uri.pathSegments[index + 1]);
    }
    return null;
  }

  Future<void> _handleTrackingLink(int orderId) async {
    debugPrint('📱 Handling order tracking deep link for orderId: $orderId');
    TripStorageService.saveActiveTripId(orderId);

    for (int i = 0; i < 10; i++) {
      final currentContext = AppRouter.navigatorKey.currentContext;
      if (currentContext != null && currentContext.mounted) {
        try {
          final userHomeCubit = UserHomeCubit.get(currentContext);
          await userHomeCubit.getRideDetails(orderId);
          return;
        } catch (e) {
          debugPrint('Waiting for UserHomeCubit... ($i)');
        }
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }

    final token = CacheHelper.getData(key: AppConstant.kToken);
    if (token != null) {
      AppRouter.routers.go(Routes.userHomeView);
    }
  }

  /// Navigates to BookRide screen with extracted coordinates.
  void _navigateToBooking(double lat, double lng) {
    AppRouter.routers.push(
      Uri(
        path: Routes.bookRide,
        queryParameters: {
          'lat': lat.toString(),
          'lng': lng.toString(),
        },
      ).toString(),
    );
  }

  /// Navigates to BookRide screen for manual selection if extraction fails.
  void _navigateToBookingWithFallback() {
    AppRouter.routers.push(Routes.bookRide);
  }

  /// Clean up resources.
  void dispose() {
    _linkSubscription?.cancel();
  }
}

