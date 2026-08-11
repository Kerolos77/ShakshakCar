import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/shared/notifications/domain/entities/notification_entity.dart';
import 'package:shakshak/features/shared/notifications/presentation/manager/notification_cubit.dart';
import 'package:shakshak/features/shared/notifications/presentation/widgets/notification_item.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:go_router/go_router.dart';
import 'package:shakshak/core/router/routes.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationCubit>().loadNotifications();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleNotificationTap(BuildContext context, NotificationEntity notification) {
    final type = notification.type?.toLowerCase() ?? '';
    final title = notification.title;
    final body = notification.body;
    final textContent = '$title $body'.toLowerCase();
    final payload = notification.payload ?? {};

    final isCoupon = type.contains('coupon') ||
        type.contains('discount') ||
        type.contains('promo') ||
        type.contains('offer') ||
        type.contains('voucher') ||
        textContent.contains('كوبون') ||
        textContent.contains('خصم') ||
        textContent.contains('عرض') ||
        textContent.contains('كود') ||
        payload.containsKey('coupon_code') ||
        payload.containsKey('code') ||
        payload.containsKey('discount');

    if (isCoupon) {
      String code = payload['coupon_code']?.toString() ??
          payload['code']?.toString() ??
          payload['coupon']?.toString() ??
          '';

      if (code.isEmpty) {
        final RegExp regExp = RegExp(r'[A-Za-z0-9]{4,15}');
        final matches = regExp.allMatches('$title $body');
        for (final match in matches) {
          final val = match.group(0)!;
          if (val != 'http' && val != 'https' && val != 'null' && val.length >= 4) {
            code = val;
            break;
          }
        }
      }
      if (code.isEmpty) code = 'SHAKSHAK';

      context.push(
        Routes.couponDetailsView,
        extra: {
          'title': title,
          'description': body,
          'code': code,
          'discountText': payload['discount']?.toString() ?? payload['discount_text']?.toString(),
          'expiryDateStr': payload['expiry_date']?.toString() ?? payload['expiryDate']?.toString(),
          'imageUrl': notification.imageUrl,
          'minSpend': payload['min_spend'] != null
              ? double.tryParse(payload['min_spend'].toString())
              : null,
        },
      );
    } else {
      context.push(
        Routes.notificationDetailsView,
        extra: {
          'title': notification.title,
          'body': notification.body,
          'imageUrl': notification.imageUrl,
        },
      );
    }
  }

  Widget _buildLoadingSkeleton() {
    final dummyNotifications = List.generate(
      5,
      (index) => NotificationEntity(
        id: '$index',
        title: 'جاري تحميل إشعار التجربة...',
        body: 'هذا النص تجريبي لعرض هيكل الإشعار أثناء التنزيل من السيرفر.',
        date: DateTime.now(),
        isRead: false,
      ),
    );

    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
        itemCount: dummyNotifications.length,
        itemBuilder: (context, index) => NotificationItem(
          notification: dummyNotifications[index],
          onTap: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutView(
      title: S.of(context).notifications,
      body: BlocBuilder<NotificationCubit, NotificationState>(
        buildWhen: (previous, current) =>
            current is NotificationLoading ||
            current is NotificationLoaded ||
            current is NotificationError,
        builder: (context, state) {
          if (state is NotificationLoading) {
            return _buildLoadingSkeleton();
          } else if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded,
                      size: 60.r, color: AppColors.redColor),
                  12.ph,
                  Text(
                    state.message,
                    style: Styles.textStyle14Bold(context)
                        .copyWith(color: AppColors.redColor),
                    textAlign: TextAlign.center,
                  ),
                  16.ph,
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () {
                      context
                          .read<NotificationCubit>()
                          .loadNotifications(refresh: true);
                    },
                    icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                    label: const Text("إعادة المحاولة",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          } else if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(24.r),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.08),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          size: 64.r,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      20.ph,
                      Text(
                        S.of(context).noNotificationsYet,
                        style: Styles.textStyle16Bold(context),
                        textAlign: TextAlign.center,
                      ),
                      8.ph,
                      Text(
                        "ستظهر لك هنا كافة التحديثات والعروض فور وصولها",
                        style: Styles.textStyle12Regular(context).copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      24.ph,
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: () {
                          context
                              .read<NotificationCubit>()
                              .loadNotifications(refresh: true);
                        },
                        icon: Icon(Icons.refresh_rounded,
                            color: AppColors.primaryColor),
                        label: Text(
                          "تحديث قائمة الإشعارات",
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final hasUnread = state.notifications.any((n) => !n.isRead);

            return Column(
              children: [
                if (hasUnread)
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8.r,
                              height: 8.r,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            6.pw,
                            Text(
                              "تنبيهات جديدة غير مقروءة",
                              style: Styles.textStyle12Bold(context).copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                            backgroundColor:
                                AppColors.primaryColor.withOpacity(0.08),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              side: BorderSide(
                                color: AppColors.primaryColor.withOpacity(0.2),
                              ),
                            ),
                          ),
                          onPressed: () {
                            context.read<NotificationCubit>().markAllAsRead();
                          },
                          icon: Icon(Icons.done_all_rounded,
                              size: 18.r, color: AppColors.primaryColor),
                          label: Text(
                            'تحديد الكل كمقروء',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await context
                          .read<NotificationCubit>()
                          .loadNotifications(refresh: true);
                      await context
                          .read<NotificationCubit>()
                          .fetchUnreadCount();
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
                      itemCount: state.notifications.length +
                          (state.isFetchingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.notifications.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final notification = state.notifications[index];
                        return NotificationItem(
                          notification: notification,
                          onTap: () {
                            context
                                .read<NotificationCubit>()
                                .markAsRead(notification.id);
                            _handleNotificationTap(context, notification);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
