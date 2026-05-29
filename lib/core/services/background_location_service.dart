import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/constants/app_const.dart';

class BackgroundLocationService {
  static final BackgroundLocationService _instance =
      BackgroundLocationService._internal();
  factory BackgroundLocationService() => _instance;
  BackgroundLocationService._internal();

  final FlutterBackgroundService _service = FlutterBackgroundService();

  Future<void> initializeService() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground', // id
      'Location Tracking', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.low,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (Platform.isIOS || Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.initialize(
        settings: const InitializationSettings(
          iOS: DarwinInitializationSettings(),
          android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        ),
      );
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,
        // auto start service
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'Driver Online',
        initialNotificationContent: 'Tracking your location...',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  Future<void> startService() async {
    await _service.startService();
  }

  void stopService() {
    _service.invoke("stopService");
  }
}

// to ensure this is executed run app from xcode, then from xcode menu, select Simulate Background Fetch
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Init Location manually since get_it doesn't propagate to headless isolates
  final Location location = Location();

  try {
    await location.enableBackgroundMode(enable: true);
  } catch (e) {
    debugPrint("Could not enable background mode: $e");
  }

  await location.changeSettings(
    accuracy: LocationAccuracy.high,
    interval: 10000, // 10 seconds
    distanceFilter: 10.0, // 10 meters
  );

  final dio = Dio();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  location.onLocationChanged.listen((LocationData currentLocation) async {
    if (currentLocation.latitude == null || currentLocation.longitude == null)
      return;

    final token = prefs.getString(AppConstant.kToken);

    if (token == null || token.isEmpty) {
      debugPrint("Background Tracking Error: No user token found.");
      return;
    }

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Driver Online",
        content:
            "Tracking Location: ${currentLocation.latitude}, ${currentLocation.longitude}",
      );
    }

    // Send silently to server
    try {
      dio.options.headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };

      await dio.post(
        ApiConstant.baseUrl + ApiConstant.locationUpdateUrl,
        data: {
          'latitude': currentLocation.latitude,
          'longitude': currentLocation.longitude,
        },
      );
      debugPrint(
          "✅ BG Location Posted: ${currentLocation.latitude}, ${currentLocation.longitude}");
    } catch (e) {
      debugPrint("❌ BG Location Post Error: $e");
    }
  });
}
