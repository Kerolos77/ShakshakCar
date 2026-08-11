import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';

class NotificationRouterHelper {
  static void handleNotificationRouting(
      RemoteMessage message, BuildContext context) {
    final data = message.data;
    final type = data['type']?.toString().toLowerCase() ?? '';
    final title = message.notification?.title ?? data['title'] ?? 'إشعار جديد';
    final body = message.notification?.body ?? data['body'] ?? '';
    final imageUrl = message.notification?.android?.imageUrl ??
        data['image'] ??
        data['image_url'] ??
        data['imageUrl'] ??
        data['picture'] ??
        data['photo'];

    // 1. Coupon / Discount Notifications
    final isCoupon = type.contains('coupon') ||
        type.contains('discount') ||
        type.contains('promo') ||
        data.containsKey('coupon_code') ||
        data.containsKey('code') ||
        title.contains('كوبون') ||
        (title.contains('خصم') && !type.contains('trip') && !type.contains('order'));

    if (isCoupon) {
      context.push(
        Routes.couponDetailsView,
        extra: {
          'title': title,
          'description': body,
          'code': data['coupon_code'] ?? data['code'] ?? 'SHAKSHAK',
          'discountText': data['discount'] ?? data['discount_text'],
          'expiryDateStr': data['expiry_date'] ?? data['expiryDate'],
          'imageUrl': imageUrl,
          'minSpend': data['min_spend'],
        },
      );
      return;
    }

    // 2. Chat Notifications
    if (type.contains('chat') || type.contains('message')) {
      final tripId = data['trip_id'] ?? data['ride_id'] ?? data['order_id'];
      final driverName = data['driver_name'] ?? data['sender_name'] ?? 'السائق';
      final parsedRideId = int.tryParse(tripId.toString()) ?? 0;
      context.push(
        Routes.chatView,
        extra: ChatViewArgs(
          rideId: parsedRideId,
          driverName: driverName.toString(),
        ),
      );
      return;
    }

    // 3. Trip / Ride Offer Notifications (e.g. driver sent an offer on a pending request)
    final isNewOffer = type == 'new_offer' ||
        type == 'driver_offer' ||
        type == 'counter_offer' ||
        type == 'trip_offer' ||
        type.contains('offer') ||
        title.contains('عرض') ||
        title.contains('سعر');

    if (isNewOffer) {
      // If ride payload is directly passed in notification
      if (data.containsKey('ride') || data.containsKey('new_ride')) {
        try {
          final rideJson = data['ride'] is String
              ? jsonDecode(data['ride'])
              : (data['new_ride'] is String
                  ? jsonDecode(data['new_ride'])
                  : data['ride'] ?? data['new_ride']);
          if (rideJson is Map<String, dynamic>) {
            final rideData = NewRideData.fromJson(rideJson);
            context.go(
              Routes.offersView,
              extra: OffersViewArgs(newRideData: rideData),
            );
            return;
          }
        } catch (e) {
          debugPrint('Error parsing ride model from notification: $e');
        }
      }
      // Otherwise navigate to UserHomeView which loads active ride & opens OffersView
      context.go(Routes.userHomeView);
      return;
    }

    // 4. Trip Status / In-Progress Notifications (e.g. driver accepted, driver arrived, trip started)
    final isTripInProgress = type == 'trip_update' ||
        type == 'trip_accepted' ||
        type == 'offer_accepted' ||
        type == 'driver_arrived' ||
        type == 'trip_started' ||
        type == 'in_progress' ||
        title.contains('تم قبول') ||
        title.contains('وصل السائق') ||
        title.contains('بدأت الرحلة');

    if (isTripInProgress) {
      context.go(Routes.userHomeView);
      return;
    }

    // 5. Trip Completed Notifications
    final isTripCompleted = type == 'trip_completed' ||
        type == 'trip_finished' ||
        type == 'trip_ended' ||
        title.contains('مكتملة') ||
        title.contains('انتهت الرحلة');

    if (isTripCompleted) {
      context.go(Routes.ridesView);
      return;
    }

    // 6. Driver-side Notifications
    final isDriverNotification = type == 'new_order' ||
        type == 'user_counter_offer' ||
        type == 'offer_denied' ||
        type == 'shipping_request' ||
        type.contains('driver');

    if (isDriverNotification) {
      context.go(Routes.driverHomeView);
      return;
    }

    // 7. Generic Fallback
    context.push(
      Routes.notificationDetailsView,
      extra: {
        'title': title,
        'body': body,
        'imageUrl': imageUrl,
      },
    );
  }
}
