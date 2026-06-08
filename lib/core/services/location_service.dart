import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';

class LocationService {
  final Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;

  Stream<LocationData> get onLocationChanged => _location.onLocationChanged;

  // Test Mode
  String? _testToken;

  void setTestToken(String? token) {
    _testToken = token;
    debugPrint("LocationService: Test token set to: $token");
  }

  bool _isTracking = false;
  bool get isTracking => _isTracking;
  LocationData? _lastSentLocation;

  Future<void> startTracking({bool highAccuracy = true}) async {
    if (_isTracking) {
      debugPrint("Already tracking, updating settings...");
      await _applySettings(highAccuracy: highAccuracy);
      return;
    }

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        debugPrint("Location service is disabled");
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        debugPrint("Location permission denied");
        return;
      }
    }

    // Enable background mode
    try {
      await _location.enableBackgroundMode(enable: true);
    } catch (e) {
      debugPrint("Could not enable background mode: $e");
    }

    await _applySettings(highAccuracy: highAccuracy);

    debugPrint("Starting location tracking...");

    _locationSubscription =
        _location.onLocationChanged.listen((LocationData currentLocation) {
      _onLocationChanged(currentLocation);
    });

    _isTracking = true;
  }

  Future<void> _applySettings({required bool highAccuracy}) async {
    await _location.changeSettings(
      accuracy:
          highAccuracy ? LocationAccuracy.high : LocationAccuracy.balanced,
      interval: highAccuracy ? 5000 : 15000,
      distanceFilter: highAccuracy ? 5.0 : 20.0,
    );
  }

  void stopTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _isTracking = false;
    debugPrint("Stopped location tracking.");
  }

  Future<void> _onLocationChanged(LocationData currentLocation) async {
    if (currentLocation.latitude == null || currentLocation.longitude == null)
      return;

    // The location package's distanceFilter already handles some of this,
    // but we can add an extra layer of protection or logging here.
    if (_lastSentLocation != null &&
        _lastSentLocation!.latitude == currentLocation.latitude &&
        _lastSentLocation!.longitude == currentLocation.longitude) {
      return;
    }

    debugPrint(
        "Location changed: ${currentLocation.latitude}, ${currentLocation.longitude}");
    await _updateLocationOnServer(
        currentLocation.latitude!, currentLocation.longitude!);
    _lastSentLocation = currentLocation;
  }

  Future<void> _updateLocationOnServer(double lat, double lng) async {
    final String? token =
        _testToken ?? CacheHelper.getData(key: AppConstant.kToken);

    // If no token, we probably shouldn't or can't update location (unauthorized)
    if (token == null || token.isEmpty) {
      debugPrint("Skipping location update: No token found");
      return;
    }

    try {
      await DioHelper.postData(
        url: ApiConstant.locationUpdateUrl,
        token: token,
        query: {
          'latitude': lat,
          'longitude': lng,
        },
        data: {},
      );
      debugPrint(" ✅ Server location updated: $lat, $lng");
    } catch (e) {
      debugPrint(" ❌ Failed to update location on server: $e");
    }
  }
}
