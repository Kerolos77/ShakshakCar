import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shakshak/features/shared/notifications/data/models/notification_model.dart';
import 'package:shakshak/features/shared/notifications/domain/entities/notification_entity.dart';
import 'package:shakshak/features/shared/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/usecases/save_notification_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/usecases/update_fcm_token_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/usecases/get_unread_notifications_count_usecase.dart';
import 'package:shakshak/core/services/real_time/realtime_manager.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/features/shared/authentication/data/models/profile_model.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final SaveNotificationUseCase saveNotificationUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase markAllNotificationsAsReadUseCase;
  final UpdateFcmTokenUseCase updateFcmTokenUseCase;
  final GetUnreadNotificationsCountUseCase getUnreadNotificationsCountUseCase;
  final RealtimeManager realtimeService;
  UserData? currentUser;
  String? _notificationToken;

  List<NotificationEntity> notifications = [];
  int unreadCount = 0;

  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.saveNotificationUseCase,
    required this.markNotificationAsReadUseCase,
    required this.markAllNotificationsAsReadUseCase,
    required this.updateFcmTokenUseCase,
    required this.getUnreadNotificationsCountUseCase,
  })  : realtimeService = sl<RealtimeManager>(),
        super(NotificationInitial());

  Future<void> init(UserData user) async {
    currentUser = user;
    await fetchUnreadCount();
    await loadNotifications();
    subscribeToNotifications();
  }

  Future<void> fetchUnreadCount() async {
    final result = await getUnreadNotificationsCountUseCase(const NoParameters());
    result.fold(
      (failure) => debugPrint("Failed to load unread count"),
      (count) {
        unreadCount = count;
        if (state is NotificationLoaded) {
          emit(NotificationLoaded(notifications, hasMore: hasMore, unreadCount: unreadCount));
        } else {
          emit(NotificationLoaded(notifications, hasMore: hasMore, unreadCount: unreadCount)); // Emit to update UI
        }
      },
    );
  }

  int currentPage = 1;
  bool hasMore = true;

  Future<void> loadNotifications({bool refresh = false, bool showLoading = true}) async {
    if (refresh) {
      currentPage = 1;
      hasMore = true;
      if (showLoading) {
        notifications.clear();
        emit(NotificationLoading());
      }
    } else {
      if (!hasMore) return;
      if (notifications.isNotEmpty) {
        emit(NotificationLoaded(
          notifications,
          hasMore: hasMore,
          isFetchingMore: true,
          unreadCount: unreadCount,
        ));
      } else {
        if (showLoading) emit(NotificationLoading());
      }
    }

    try {
      final result = await getNotificationsUseCase(GetNotificationsParams(page: currentPage));
      result.fold(
        (failure) {
          if (notifications.isEmpty) {
            emit(NotificationError("Failed to load notifications: ${failure.message}"));
          } else {
            // Restore previous state if pagination fails
            emit(NotificationLoaded(notifications, hasMore: hasMore, unreadCount: unreadCount));
          }
        },
        (paginatedData) {
          if (refresh || currentPage == 1) {
            notifications = List.from(paginatedData.notifications);
          } else {
            notifications.addAll(paginatedData.notifications);
          }
          
          hasMore = paginatedData.hasMore;
          if (hasMore) currentPage++;

          // For testing if empty
          if (notifications.isEmpty) {
             notifications = [
              NotificationEntity(
                id: '1',
                title: 'Welcome to Shakshak',
                body: 'Thank you for joining our community! We are happy to have you.',
                date: DateTime.now().subtract(const Duration(minutes: 5)),
                isRead: false,
              ),
              NotificationEntity(
                id: '2',
                title: 'Ride Completed',
                body: 'Your ride to Dowtown has been completed successfully. Rate your driver now.',
                date: DateTime.now().subtract(const Duration(hours: 2)),
                isRead: true,
              ),
            ];
          }

          emit(NotificationLoaded(notifications, hasMore: hasMore, unreadCount: unreadCount));
        },
      );
    } catch (e) {
      if (notifications.isEmpty) {
        emit(NotificationError("Failed to load notifications"));
      } else {
        emit(NotificationLoaded(notifications, hasMore: hasMore, unreadCount: unreadCount));
      }
    }
  }

  void subscribeToNotifications() {
    if (currentUser == null || currentUser!.id == null) return;

    final String channelName = 'user-${currentUser!.id}';

    // Subscribe to channel
    realtimeService.subscribe(channelName);

    // Listen to 'notification' event
    _notificationToken = realtimeService.addListener(
      channel: channelName,
      event: 'notification',
      callback: (data) {
        _handleIncomingNotification(data);
      },
    );

    debugPrint('🔔 Subscribed to notifications on $channelName');
  }

  void _handleIncomingNotification(dynamic data) async {
    debugPrint('🔔 Notification Received: $data');
    try {
      // 1. Manually parse the new notification to give the user INSTANT feedback
      if (data is Map<String, dynamic> || data is String) {
        Map<String, dynamic> json;
        if (data is String) {
          json = jsonDecode(data);
        } else {
          json = data;
        }
        
        if (!json.containsKey('id')) {
          json['id'] = DateTime.now().millisecondsSinceEpoch.toString();
        }
        if (!json.containsKey('date')) {
          json['date'] = DateTime.now().toIso8601String();
        }
        
        final notification = NotificationModel.fromJson(json);
        
        // Optimistically update UI instantly before fetching from DB
        notifications.insert(0, notification);
        unreadCount++;
        emit(NotificationNewMessage(notification));
        emit(NotificationLoaded(notifications, hasMore: hasMore, unreadCount: unreadCount));
      }

      // 2. Sync unread count and latest notifications with the backend silently in the background
      await fetchUnreadCount();
      await loadNotifications(refresh: true, showLoading: false);

    } catch (e) {
      debugPrint('Error handling notification: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      if (!notifications[index].isRead) {
        notifications[index].isRead = true;
        if (unreadCount > 0) unreadCount--;
        await markNotificationAsReadUseCase(notificationId);
        emit(NotificationLoaded(notifications, hasMore: hasMore, unreadCount: unreadCount));
      }
    }
  }

  Future<void> markAllAsRead() async {
    for (var n in notifications) {
      n.isRead = true;
    }
    unreadCount = 0;
    
    await markAllNotificationsAsReadUseCase(const NoParameters());
    
    if (notifications.isNotEmpty) {
      emit(NotificationLoaded(notifications, hasMore: hasMore, unreadCount: unreadCount));
    }
  }
  
  Future<void> updateFcmToken(String token) async {
    final result = await updateFcmTokenUseCase(token);
    result.fold(
      (failure) => debugPrint("Failed to update FCM token: ${failure.message}"),
      (_) => debugPrint("FCM token updated successfully"),
    );
  }

  @override
  Future<void> close() {
    if (_notificationToken != null) {
      realtimeService.removeListener(_notificationToken!);
    }
    return super.close();
  }
}
