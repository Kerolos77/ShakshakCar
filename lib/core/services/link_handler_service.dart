import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:shakshak/core/router/app_router.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/google_maps_resolver.dart';

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

    // Resolve coordinates from any supported Google Maps link or scheme
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
