import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shakshak/core/router/routes.dart';

class NotificationRouterHelper {
  static void handleNotificationRouting(
      RemoteMessage message, BuildContext context) {
    final data = message.data;

    // Check if data is empty (Ad/Discount Notification)
    if (data.isEmpty || !data.containsKey('type')) {
      final title = message.notification?.title ?? 'إشعار جديد';
      final body = message.notification?.body ?? '';
      
      // Navigate to generic notification details view
      context.push(
        Routes.notificationDetailsView,
        extra: {'title': title, 'body': body},
      );
      return;
    }

    final type = data['type'];

    // Route based on User or Driver types
    switch (type) {
      // Driver Types
      case 'new_order':
      case 'user_counter_offer':
      case 'offer_accepted':
      case 'offer_denied':
      case 'trip_cancelled':
        context.go(Routes.driverHomeView);
        break;

      // User Types
      case 'new_offer':
      case 'trip_update':
        context.go(Routes.userHomeView);
        break;

      default:
        // Fallback or unknown types
        break;
    }
  }
}
