import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  static double calculateBearing(LatLng start, LatLng end) {
    print("====================================================");
    print("=================================== start IS $start");
    print("=================================== end IS $end");

    double lat1 = start.latitude * pi / 180;
    double lng1 = start.longitude * pi / 180;
    double lat2 = end.latitude * pi / 180;
    double lng2 = end.longitude * pi / 180;

    double dLon = (lng2 - lng1);

    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    double bearing = atan2(y, x);
    print(
        "=================================== bearing IS ${(bearing * 180 / pi + 360) % 360}");
    return (bearing * 180 / pi + 360) % 360;
  }

  static Color parseHexColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) return Colors.purple; // Default
    try {
      final hex = colorStr.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return Colors.purple;
  }

  static LatLng findNearestPointOnPolyline(
      LatLng point, List<LatLng> polyline) {
    print("====================================================");
    print("=================================== point IS $point");
    print("=================================== Polyline IS $polyline");
    if (polyline.isEmpty) return point;

    double minDistance = double.infinity;
    LatLng nearestPoint = polyline.first;

    for (int i = 0; i < polyline.length - 1; i++) {
      LatLng p1 = polyline[i];
      LatLng p2 = polyline[i + 1];

      LatLng candidate = _findNearestPointOnSegment(point, p1, p2);
      double dist = distanceBetween(point, candidate);

      if (dist < minDistance) {
        minDistance = dist;
        nearestPoint = candidate;
      }
    }

    return nearestPoint;
  }

  static List<LatLng> findNearestSegmentOnPolyline(
      LatLng point, List<LatLng> polyline) {
    if (polyline.isEmpty) return [point, point];
    if (polyline.length == 1) return [polyline.first, polyline.first];

    double minDistance = double.infinity;
    List<LatLng> bestSegment = [polyline[0], polyline[1]];

    for (int i = 0; i < polyline.length - 1; i++) {
      LatLng p1 = polyline[i];
      LatLng p2 = polyline[i + 1];

      LatLng candidate = _findNearestPointOnSegment(point, p1, p2);
      double dist = distanceBetween(point, candidate);

      if (dist < minDistance) {
        minDistance = dist;
        bestSegment = [p1, p2];
      }
    }

    return bestSegment;
  }

  static LatLng _findNearestPointOnSegment(LatLng p, LatLng start, LatLng end) {
    double x = p.latitude;
    double y = p.longitude;
    double x1 = start.latitude;
    double y1 = start.longitude;
    double x2 = end.latitude;
    double y2 = end.longitude;

    double dx = x2 - x1;
    double dy = y2 - y1;

    if (dx == 0 && dy == 0) return start;

    double t = ((x - x1) * dx + (y - y1) * dy) / (dx * dx + dy * dy);

    if (t < 0) return start;
    if (t > 1) return end;

    return LatLng(x1 + t * dx, y1 + t * dy);
  }

  static double distanceBetween(LatLng p1, LatLng p2) {
    return sqrt(pow(p1.latitude - p2.latitude, 2) +
        pow(p1.longitude - p2.longitude, 2));
  }

  static List<LatLng> decodePolyline(String encoded) {
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

  static LatLngBounds getLatLngBounds(List<LatLng> points) {
    if (points.isEmpty) {
      return LatLngBounds(
          southwest: const LatLng(0, 0), northeast: const LatLng(0, 0));
    }
    double southwestLat = points.first.latitude;
    double southwestLng = points.first.longitude;
    double northeastLat = points.first.latitude;
    double northeastLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < southwestLat) southwestLat = point.latitude;
      if (point.longitude < southwestLng) southwestLng = point.longitude;
      if (point.latitude > northeastLat) northeastLat = point.latitude;
      if (point.longitude > northeastLng) northeastLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(southwestLat, southwestLng),
      northeast: LatLng(northeastLat, northeastLng),
    );
  }

  static Future<void> applyMapStyle(
      GoogleMapController controller, bool isDarkMode) async {
    if (isDarkMode) {
      try {
        final String style = await rootBundle
            .loadString('assets/map_styles/dark_map_style.json');
        await controller.setMapStyle(style);
      } catch (e) {
        // Fallback or log error
      }
    } else {
      await controller.setMapStyle(null);
    }
  }
}
