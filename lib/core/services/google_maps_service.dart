import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/constants/key_const.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';

class RouteData {
  final List<LatLng> polylinePoints;
  final String? distance;
  final String? duration;

  RouteData({
    required this.polylinePoints,
    this.distance,
    this.duration,
  });
}

class GoogleMapsService {
  static const String _routesUrl =
      'https://routes.googleapis.com/directions/v2:computeRoutes';

  // ✅ Route Cache: المفتاح هو "lat1,lng1→lat2,lng2"
  // يمنع إعادة طلب نفس المسار من الـ API في كل مرة تُفتح الخريطة
  static final Map<String, RouteData> _routeCache = {};

  // ✅ مسح قديم الـ Cache لو كبر أوي (max 50 route)
  static const int _maxCacheSize = 50;

  Future<RouteData?> fetchRoute({
    required LatLng start,
    required LatLng end,
    List<LatLng>? decodedPolyline,
  }) async {
    // نبني مفتاح فريد (مدوّر لـ 5 أرقام عشرية للدقة)
    final cacheKey =
        '${start.latitude.toStringAsFixed(5)},${start.longitude.toStringAsFixed(5)}'
        '→${end.latitude.toStringAsFixed(5)},${end.longitude.toStringAsFixed(5)}';

    // ✅ Hit: نرجع النتيجة من الـ Cache فوراً
    if (_routeCache.containsKey(cacheKey)) {
      debugPrint('🗺️ Route Cache HIT: $cacheKey');
      return _routeCache[cacheKey];
    }

    debugPrint('🌐 Route Cache MISS – fetching from API: $cacheKey');

    final body = {
      "origin": {
        "location": {
          "latLng": {
            "latitude": start.latitude,
            "longitude": start.longitude,
          }
        }
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": end.latitude,
            "longitude": end.longitude,
          }
        }
      },
      "travelMode": "DRIVE",
      "routingPreference": "TRAFFIC_AWARE",
      "computeAlternativeRoutes":
          false, // ✅ لا نطلب routes بديلة - توفير في الـ response
    };

    try {
      final response = await http.post(
        Uri.parse('$_routesUrl?key=${KeyConst.mapKey}'),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-FieldMask':
              'routes.distanceMeters,routes.duration,routes.polyline.encodedPolyline',
        },
        body: jsonEncode(body),
      );

      final data = json.decode(response.body);

      if (data['routes'] == null || data['routes'].isEmpty) return null;

      final route = data['routes'][0];
      final encodedPolyline = route['polyline']['encodedPolyline'];

      final routeData = RouteData(
        polylinePoints: _decodePolyline(encodedPolyline),
        distance: route['distanceMeters']?.toString(),
        duration: route['duration'],
      );

      // ✅ حفظ في الـ Cache
      if (_routeCache.length >= _maxCacheSize) {
        // نشيل أقدم عنصر لو الـ Cache ممتلي
        _routeCache.remove(_routeCache.keys.first);
      }
      _routeCache[cacheKey] = routeData;

      return routeData;
    } catch (e) {
      debugPrint("❌ Error fetching route: $e");
      return null;
    }
  }

  /// مسح الـ Cache (مثلاً عند الـ logout)
  static void clearCache() {
    _routeCache.clear();
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dLng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  /// 📡 Fetches the driver's last known location from the backend.
  Future<LatLng?> fetchDriverLastLocation(int driverId) async {
    final String? token = CacheHelper.getData(key: AppConstant.kToken);
    if (token == null) return null;

    try {
      final response = await DioHelper.getData(
        url: ApiConstant.getDriverLocationUrl(driverId),
        token: token,
      );

      final data = response.data;
      if (data != null && data['success'] == true && data['data'] != null) {
        final loc = data['data'];
        double lat = double.parse(loc['latitude'].toString());
        double lng = double.parse(loc['longitude'].toString());
        debugPrint("📡 GoogleMapsService: Driver $driverId location fetched: $lat, $lng");
        return LatLng(lat, lng);
      }
    } catch (e) {
      debugPrint("⚠️ GoogleMapsService: Error fetching driver location: $e");
    }
    return null;
  }
}
