import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsUrlResolver {
  /// Resolves a Google Maps URL, scheme, or shortened link and extracts coordinates.
  static Future<LatLng?> getCoordinatesFromUrl(String url) async {
    try {
      String finalUrl = url;

      // Handle shortened URLs (maps.app.goo.gl or goo.gl)
      if (url.contains('goo.gl')) {
        finalUrl = await _resolveRedirects(url);
      }

      return _extractFromUrl(finalUrl);
    } catch (e) {
      print('Error resolving Google Maps URL: $e');
      return null;
    }
  }

  /// Follows HTTP redirects to get the final long URL using a GET request.
  static Future<String> _resolveRedirects(String url) async {
    try {
      // Use client with disabled redirects to capture the 'location' header manually or follow 1 level
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(url))
        ..followRedirects = false;
      final response = await client.send(request);

      if (response.statusCode >= 300 && response.statusCode < 400) {
        final location = response.headers['location'];
        if (location != null) {
          return location;
        }
      }
      return url;
    } catch (e) {
      return url;
    }
  }

  /// Advanced Regex extraction for various Map URL formats and Schemes.
  static LatLng? _extractFromUrl(String url) {
    // 1. geo:lat,lng or geo:0,0?q=lat,lng
    if (url.startsWith('geo:')) {
      // Match q=lat,lng first as it's more specific
      final qMatch = RegExp(r'q=(-?\d+\.\d+),(-?\d+\.\d+)').firstMatch(url);
      if (qMatch != null) {
        return LatLng(
            double.parse(qMatch.group(1)!), double.parse(qMatch.group(2)!));
      }
      // Match direct geo:lat,lng
      final geoMatch = RegExp(r'geo:(-?\d+\.\d+),(-?\d+\.\d+)').firstMatch(url);
      if (geoMatch != null) {
        return LatLng(
            double.parse(geoMatch.group(1)!), double.parse(geoMatch.group(2)!));
      }
    }

    // 2. google.navigation:q=lat,lng
    if (url.contains('google.navigation:')) {
      final navMatch = RegExp(r'q=(-?\d+\.\d+),(-?\d+\.\d+)').firstMatch(url);
      if (navMatch != null) {
        return LatLng(
            double.parse(navMatch.group(1)!), double.parse(navMatch.group(2)!));
      }
    }

    // 3. Pattern: @lat,lng (Full URLs)
    final patternAt = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)');
    final matchAt = patternAt.firstMatch(url);
    if (matchAt != null) {
      return LatLng(
          double.parse(matchAt.group(1)!), double.parse(matchAt.group(2)!));
    }

    // 4. Pattern: !3dlat!4dlng (Place links)
    final patternEx = RegExp(r'!3d(-?\d+\.\d+)!4d(-?\d+\.\d+)');
    final matchEx = patternEx.firstMatch(url);
    if (matchEx != null) {
      return LatLng(
          double.parse(matchEx.group(1)!), double.parse(matchEx.group(2)!));
    }

    // 5. Pattern: query=lat,lng or q=lat,lng (Standard search links)
    final patternQ =
        RegExp(r'[?&](?:query|q|destination)=(-?\d+\.\d+),(-?\d+\.\d+)');
    final matchQ = patternQ.firstMatch(url);
    if (matchQ != null) {
      return LatLng(
          double.parse(matchQ.group(1)!), double.parse(matchQ.group(2)!));
    }

    return null;
  }
}
