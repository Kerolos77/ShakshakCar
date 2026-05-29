import 'package:flutter/foundation.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/shared/notifications/data/models/notification_model.dart';
import 'package:shakshak/features/shared/notifications/domain/entities/notification_entity.dart';
import 'package:shakshak/features/shared/notifications/domain/repositories/notification_repo.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';

class NotificationRepoImp implements NotificationRepo {
  static const String _storageKey = 'user_notifications';

  @override
  Future<PaginatedNotificationEntity> getNotifications({int page = 1}) async {
    try {
      final userToken = CacheHelper.getData(key: AppConstant.kToken);
      if (userToken == null) {
        return PaginatedNotificationEntity(notifications: [], hasMore: false);
      }

      final response = await DioHelper.getData(
        url: ApiConstant.notificationsUrl,
        query: {'page': page},
        token: userToken,
      );

      final data = response.data;
      if (data['status'] == 'success') {
        final notificationsData = data['data']['data'] as List;
        final notifications =
            notificationsData.map((e) => NotificationModel.fromJson(e)).toList();
        final currentPage = data['data']['current_page'] ?? 1;
        final lastPage = data['data']['last_page'] ?? 1;
        
        return PaginatedNotificationEntity(
          notifications: notifications,
          hasMore: currentPage < lastPage,
        );
      }
      return PaginatedNotificationEntity(notifications: [], hasMore: false);
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      throw e;
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final userToken = CacheHelper.getData(key: AppConstant.kToken);
      if (userToken == null) return 0;

      final response = await DioHelper.getData(
        url: ApiConstant.unreadNotificationsCountUrl,
        token: userToken,
      );

      final data = response.data;
      if (data['status'] == 'success') {
        final count = data['data']['unread_count'];
        return int.tryParse(count.toString()) ?? 0;
      }
      return 0;
    } catch (e) {
      debugPrint('Error getting unread count: $e');
      return 0;
    }
  }

  @override
  Future<void> saveNotification(NotificationEntity notification) async {
    // If we want to persist incoming realtime notifications locally before they are synced from backend,
    // we could do so, but since we rely on the backend for the source of truth now,
    // we can just let it be handled by Cubit's memory.
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      final userToken = CacheHelper.getData(key: AppConstant.kToken);
      if (userToken == null) return;

      await DioHelper.postData(
        url: ApiConstant.markNotificationReadUrl(notificationId),
        token: userToken,
        data: {}, // The API might not require a body, but DioHelper.postData might require an empty map
      );
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      final userToken = CacheHelper.getData(key: AppConstant.kToken);
      if (userToken == null) return;

      await DioHelper.postData(
        url: ApiConstant.markAllNotificationsReadUrl,
        token: userToken,
        data: {},
      );
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
    }
  }

  @override
  Future<void> clearAll() async {
    await CacheHelper.removeData(key: _storageKey);
  }

  @override
  Future<void> updateFcmToken(String token) async {
    try {
      final userToken = CacheHelper.getData(key: AppConstant.kToken);
      if (userToken == null) return; // Only update if logged in

      await DioHelper.postData(
        url: ApiConstant.fcmTokenUrl,
        token: userToken,
        data: {'fcm_token': token},
      );
    } catch (e) {
      debugPrint('Error updating FCM token: $e');
      rethrow;
    }
  }
}
