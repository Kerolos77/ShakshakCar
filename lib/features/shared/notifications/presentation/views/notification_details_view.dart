import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_app_bar.dart';
import 'package:shakshak/generated/l10n.dart';

class NotificationDetailsView extends StatelessWidget {
  final String title;
  final String body;
  final String? imageUrl;

  const NotificationDetailsView({
    super.key,
    required this.title,
    required this.body,
    this.imageUrl,
  });

  bool _isValidUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final clean = url.trim().toLowerCase();
    if (clean == 'null' || clean == 'undefined' || clean == 'false' || clean == 'none') return false;
    final uri = Uri.tryParse(url.trim());
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasImage = _isValidUrl(imageUrl);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          color: AppColors.primaryColor,
          child: SafeArea(
            child: CustomAppBar(title: S.of(context).notifications),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container with distinguished shadow & border
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Theme.of(context).cardColor : Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: isDark
                      ? AppColors.primaryColor.withValues(alpha: 0.3)
                      : AppColors.primaryColor.withValues(alpha: 0.18),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.35)
                        : Colors.black.withValues(alpha: 0.06),
                    blurRadius: 18.r,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Header Section (If Image exists & valid)
                    if (hasImage) ...[
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showFullImageDialog(context, imageUrl!.trim());
                            },
                            child: Container(
                              height: 220.h,
                              width: double.infinity,
                              color: isDark ? Colors.grey[900] : Colors.grey[100],
                              child: CachedNetworkImage(
                                imageUrl: imageUrl!.trim(),
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: isDark ? Colors.grey[850] : Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: isDark ? Colors.grey[850] : Colors.grey[200],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported_rounded,
                                        size: 40.sp,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      8.ph,
                                      Text(
                                        "تعذر تحميل الصورة",
                                        style: Styles.textStyle12Regular(context).copyWith(
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12.h,
                            right: 12.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.zoom_in_rounded,
                                    color: Colors.white,
                                    size: 14.sp,
                                  ),
                                  4.pw,
                                  Text(
                                    "اضغط التكبير",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    Padding(
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header title with circle gradient icon
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 48.r,
                                height: 48.r,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primaryColor,
                                      AppColors.primaryColor.withValues(alpha: 0.75),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                                      blurRadius: 10.r,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.notifications_active_rounded,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                              14.pw,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: Styles.textStyle18Bold(context).copyWith(
                                        color: isDark ? Colors.white : AppColors.primaryColor,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          18.ph,
                          Divider(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.12)
                                : Colors.black.withValues(alpha: 0.08),
                          ),
                          16.ph,
                          // Notification Body text
                          Container(
                            padding: EdgeInsets.all(14.r),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.03)
                                  : AppColors.primaryColor.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.06)
                                    : AppColors.primaryColor.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Text(
                              body,
                              style: Styles.textStyle14Regular(context).copyWith(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : Colors.black87,
                                height: 1.65,
                                fontSize: 14.5.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullImageDialog(BuildContext context, String url) {
    if (!_isValidUrl(url)) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(12.r),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              clipBehavior: Clip.none,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Container(
                    padding: EdgeInsets.all(40.r),
                    color: Colors.black87,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primaryColor),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.broken_image_rounded, color: Colors.white, size: 50),
                        12.ph,
                        const Text(
                          "عذراً، تعذر تحميل الصورة",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
