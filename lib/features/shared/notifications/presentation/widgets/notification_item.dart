import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/notifications/domain/entities/notification_entity.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  IconData _getNotificationIcon() {
    final type = notification.type?.toLowerCase() ?? '';
    final title = notification.title.toLowerCase();

    if (type.contains('trip') ||
        type.contains('shipping') ||
        title.contains('شحن') ||
        title.contains('رحلة') ||
        title.contains('طرد')) {
      return Icons.local_shipping_rounded;
    } else if (type.contains('offer') ||
        title.contains('عرض') ||
        title.contains('خصم') ||
        title.contains('سعر')) {
      return Icons.local_offer_rounded;
    } else if (type.contains('wallet') ||
        type.contains('payment') ||
        title.contains('رصيد') ||
        title.contains('دفع') ||
        title.contains('محفظة')) {
      return Icons.account_balance_wallet_rounded;
    }
    return Icons.notifications_active_rounded;
  }

  List<Color> _getIconGradient() {
    final type = notification.type?.toLowerCase() ?? '';
    final title = notification.title.toLowerCase();

    if (type.contains('trip') ||
        type.contains('shipping') ||
        title.contains('شحن') ||
        title.contains('رحلة') ||
        title.contains('طرد')) {
      return [const Color(0xFF1E88E5), const Color(0xFF1565C0)];
    } else if (type.contains('offer') ||
        title.contains('عرض') ||
        title.contains('خصم') ||
        title.contains('سعر')) {
      return [const Color(0xFFFF9800), const Color(0xFFF57C00)];
    } else if (type.contains('wallet') ||
        type.contains('payment') ||
        title.contains('رصيد') ||
        title.contains('دفع') ||
        title.contains('محفظة')) {
      return [const Color(0xFF43A047), const Color(0xFF2E7D32)];
    }
    return [AppColors.primaryColor, AppColors.primaryColor.withValues(alpha: 0.8)];
  }

  bool _isValidUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final clean = url.trim().toLowerCase();
    if (clean == 'null' || clean == 'undefined' || clean == 'false' || clean == 'none') return false;
    final uri = Uri.tryParse(url.trim());
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final iconGradient = _getIconGradient();
    final primaryIconColor = iconGradient.first;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasImage = _isValidUrl(notification.imageUrl);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: isUnread
            ? (isDark
                ? AppColors.primaryColor.withValues(alpha: 0.14)
                : AppColors.primaryColor.withValues(alpha: 0.05))
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isUnread
              ? AppColors.primaryColor.withValues(alpha: 0.4)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.grey.withValues(alpha: 0.15)),
          width: isUnread ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isUnread
                ? AppColors.primaryColor.withValues(alpha: 0.12)
                : (isDark
                    ? Colors.black.withValues(alpha: 0.25)
                    : Colors.black.withValues(alpha: 0.04)),
            blurRadius: 14.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: primaryIconColor.withValues(alpha: 0.15),
            highlightColor: primaryIconColor.withValues(alpha: 0.08),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Unread indicator bar
                  if (isUnread)
                    Container(
                      width: 5.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: iconGradient,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          bottomLeft: Radius.circular(20.r),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(14.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon badge with gradient and subtle glow
                              Container(
                                width: 44.r,
                                height: 44.r,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: iconGradient,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryIconColor.withValues(alpha: 0.35),
                                      blurRadius: 8.r,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    _getNotificationIcon(),
                                    color: Colors.white,
                                    size: 22.sp,
                                  ),
                                ),
                              ),
                              12.pw,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notification.title,
                                            style: Styles.textStyle15Bold(context).copyWith(
                                              color: isDark ? Colors.white : Colors.black87,
                                              fontWeight: isUnread
                                                  ? FontWeight.w700
                                                  : FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isUnread) ...[
                                          6.pw,
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 9.w, vertical: 3.h),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppColors.primaryColor,
                                                  AppColors.primaryColor.withValues(alpha: 0.8),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(12.r),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.primaryColor.withValues(alpha: 0.3),
                                                  blurRadius: 6.r,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              "جديد",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    4.ph,
                                    Text(
                                      notification.body,
                                      style: Styles.textStyle12Regular(context).copyWith(
                                        color: isDark
                                            ? Colors.white.withValues(alpha: 0.7)
                                            : Colors.black.withValues(alpha: 0.65),
                                        height: 1.4,
                                      ),
                                      maxLines: hasImage ? 2 : 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Image banner preview if image is attached
                          if (hasImage) ...[
                            12.ph,
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                height: 130.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.grey[900] : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: primaryIconColor.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: notification.imageUrl!.trim(),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: isDark ? Colors.grey[850] : Colors.grey[200],
                                    child: Center(
                                      child: SizedBox(
                                        width: 24.r,
                                        height: 24.r,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: isDark ? Colors.grey[850] : Colors.grey[200],
                                    child: Center(
                                      child: Icon(
                                        Icons.image_not_supported_rounded,
                                        color: Theme.of(context).hintColor,
                                        size: 28.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],

                          8.ph,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 12.sp,
                                color: Theme.of(context).hintColor,
                              ),
                              4.pw,
                              Text(
                                _formatDate(context, notification.date),
                                style: Styles.textStyle10Regular(context).copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return "الآن";
    } else if (difference.inMinutes < 60) {
      return "منذ ${difference.inMinutes} دقيقة";
    } else if (difference.inHours < 24) {
      return "منذ ${difference.inHours} ساعة";
    } else if (difference.inDays < 7) {
      return "منذ ${difference.inDays} يوم";
    } else {
      try {
        return DateFormat('d MMM yyyy, h:mm a',
                Localizations.localeOf(context).toString())
            .format(date);
      } catch (_) {
        return DateFormat('d MMM yyyy, h:mm a').format(date);
      }
    }
  }
}
