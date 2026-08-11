import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shakshak/firebase_options.dart';
import 'package:shakshak/core/services/audio_service.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/features/shared/notifications/presentation/manager/notification_cubit.dart';
import 'package:shakshak/core/services/notification_router_helper.dart';
import 'package:shakshak/core/router/app_router.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  late FirebaseMessaging _fcm;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Initialize FCM (Firebase already initialized in main.dart)
    _fcm = FirebaseMessaging.instance;

    // 2. Request Permissions
    await _requestPermissions();

    // 3. Initialize Local Notifications
    await _initLocalNotifications();

    // 4. Set up Listeners
    _setupMessageListeners();

    // 5. Get Token for debugging
    String? token = await getToken();
    debugPrint('FCM Token: $token');

    // 6. Send token to backend if registered
    if (token != null) {
      if (sl.isRegistered<NotificationCubit>()) {
        sl<NotificationCubit>().updateFcmToken(token);
      }
    }

    // 7. Listen to token refresh
    _fcm.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token Refreshed: $newToken');
      if (sl.isRegistered<NotificationCubit>()) {
        sl<NotificationCubit>().updateFcmToken(newToken);
      }
    });
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Handle notification tap when app is in foreground
        debugPrint('Notification tapped: ${details.payload}');
        try {
          if (details.payload != null && AppRouter.navigatorKey.currentContext != null) {
            final Map<String, dynamic> data = jsonDecode(details.payload!);
            final message = RemoteMessage(data: data);
            NotificationRouterHelper.handleNotificationRouting(message, AppRouter.navigatorKey.currentContext!);
          }
        } catch (e) {
          debugPrint('Payload parse error: $e');
        }
      },
    );

    // Create Android Channel for foreground high importance
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _setupMessageListeners() {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received foreground message: ${message.notification?.title}');
      AudioService().playNotificationSound();
      _showLocalNotification(message);
    });

    // Background (Tapped while in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('App opened from notification: ${message.notification?.title}');
      if (AppRouter.navigatorKey.currentContext != null) {
        NotificationRouterHelper.handleNotificationRouting(message, AppRouter.navigatorKey.currentContext!);
      }
    });

    // Terminated state is handled via checkInitialMessage()
  }

  static Future<void> checkInitialMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (AppRouter.navigatorKey.currentContext != null) {
          NotificationRouterHelper.handleNotificationRouting(
              initialMessage, AppRouter.navigatorKey.currentContext!);
        }
      });
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic> data = message.data;

    String title = notification?.title ?? data['title'] ?? '';
    String body = notification?.body ?? data['body'] ?? '';

    // Extract image URL if available
    String? imageUrl = notification?.android?.imageUrl ??
        notification?.apple?.imageUrl ??
        data['image'] ??
        data['image_url'] ??
        data['imageUrl'] ??
        data['picture'] ??
        data['photo'];

    if (title.isEmpty && body.isEmpty) return;

    StyleInformation? styleInformation;
    if (_isValidUrl(imageUrl)) {
      try {
        final Uri? parsedUri = Uri.tryParse(imageUrl!.trim());
        if (parsedUri != null && (parsedUri.scheme == 'http' || parsedUri.scheme == 'https')) {
          final http.Response response =
              await http.get(parsedUri).timeout(const Duration(seconds: 4));
          if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
            final Directory tempDir = await getTemporaryDirectory();
            final String filePath =
                '${tempDir.path}/notif_img_${DateTime.now().millisecondsSinceEpoch}.jpg';
            final File file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);

            styleInformation = BigPictureStyleInformation(
              FilePathAndroidBitmap(filePath),
              largeIcon: FilePathAndroidBitmap(filePath),
              contentTitle: title,
              summaryText: body,
              htmlFormatContentTitle: true,
              htmlFormatSummaryText: true,
            );
          }
        }
      } catch (e) {
        debugPrint("Error downloading notification image safely: $e");
      }
    }

    styleInformation ??= BigTextStyleInformation(
      body,
      contentTitle: title,
      htmlFormatContentTitle: true,
      htmlFormatBigText: true,
    );

    // Merge payload data
    final Map<String, dynamic> payloadMap = Map<String, dynamic>.from(data);
    payloadMap['title'] = title;
    payloadMap['body'] = body;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      payloadMap['imageUrl'] = imageUrl;
    }

    await _localNotifications.show(
      id: notification.hashCode != 0
          ? notification.hashCode
          : DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF6D28D9),
          ledColor: const Color(0xFF6D28D9),
          ledOnMs: 1000,
          ledOffMs: 500,
          enableLights: true,
          enableVibration: true,
          styleInformation: styleInformation,
          subText: 'ShakShak Car',
          ticker: title,
          visibility: NotificationVisibility.public,
          playSound: true,
          sound: const RawResourceAndroidNotificationSound('notification'),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'notification.mp3',
          interruptionLevel: InterruptionLevel.active,
        ),
      ),
      payload: jsonEncode(payloadMap),
    );
  }

  Future<String?> getToken() async {
    return await _fcm.getToken();
  }

  Future<void> deleteToken() async {
    await _fcm.deleteToken();
  }

  bool _isValidUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final clean = url.trim().toLowerCase();
    if (clean == 'null' || clean == 'undefined' || clean == 'false' || clean == 'none') return false;
    final uri = Uri.tryParse(url.trim());
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    debugPrint("Handling background message: ${message.messageId}");
  }
}
