import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_app_bar.dart';
import 'package:shakshak/generated/l10n.dart';

class CouponDetailsView extends StatelessWidget {
  final String title;
  final String description;
  final String code;
  final String? discountText;
  final String? expiryDateStr;
  final String? imageUrl;
  final double? minSpend;

  const CouponDetailsView({
    super.key,
    required this.title,
    required this.description,
    required this.code,
    this.discountText,
    this.expiryDateStr,
    this.imageUrl,
    this.minSpend,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            10.pw,
            Expanded(
              child: Text(
                S.of(context).codeCopiedSuccess(code),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasImage = _isValidUrl(imageUrl);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          color: AppColors.primaryColor,
          child: SafeArea(
            child: CustomAppBar(title: S.of(context).couponDetails),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            // Main Ticket Card Container
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Theme.of(context).cardColor : Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.35)
                        : AppColors.primaryColor.withValues(alpha: 0.08),
                    blurRadius: 20.r,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Image Header if present
                    if (hasImage)
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () => _showFullImageDialog(context, imageUrl!.trim()),
                            child: Container(
                              height: 180.h,
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
                                  child: Center(
                                    child: Icon(
                                      Icons.local_offer_rounded,
                                      size: 45.sp,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10.h,
                            right: 10.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.zoom_in_rounded,
                                    color: Colors.white,
                                    size: 13.sp,
                                  ),
                                  4.pw,
                                  Text(
                                    S.of(context).tapToZoom,
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

                    Padding(
                      padding: EdgeInsets.all(22.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Tag & Icon
                          Row(
                            children: [
                              Container(
                                width: 50.r,
                                height: 50.r,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF9800).withValues(alpha: 0.35),
                                      blurRadius: 10.r,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.local_offer_rounded,
                                    color: Colors.white,
                                    size: 26.sp,
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
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    if (discountText != null && discountText!.isNotEmpty) ...[
                                      4.ph,
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 3.h),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF9800).withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        child: Text(
                                          discountText!,
                                          style: TextStyle(
                                            color: const Color(0xFFE65100),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),

                          20.ph,
                          const Divider(),
                          20.ph,

                          // Prominent Coupon Code Container with Copy Button
                          Text(
                            S.of(context).yourCouponCode,
                            style: Styles.textStyle12Bold(context).copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          10.ph,
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 14.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppColors.primaryColor.withValues(alpha: 0.35),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.confirmation_number_rounded,
                                  color: AppColors.primaryColor,
                                  size: 22.sp,
                                ),
                                10.pw,
                                Expanded(
                                  child: SelectableText(
                                    code,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2.0,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14.w, vertical: 8.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  onPressed: () => _copyToClipboard(context),
                                  icon: Icon(Icons.copy_rounded, size: 16.sp),
                                  label: Text(
                                    S.of(context).copyCode,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          20.ph,

                          // Description Section
                          Text(
                            S.of(context).offerDetailsAndTerms,
                            style: Styles.textStyle14Bold(context),
                          ),
                          10.ph,
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(14.r),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.04)
                                  : Colors.grey.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  description.isNotEmpty ? description : title,
                                  style: Styles.textStyle14Regular(context).copyWith(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.85)
                                        : Colors.black87,
                                    height: 1.6,
                                  ),
                                ),
                                if (minSpend != null && minSpend! > 0) ...[
                                  12.ph,
                                  Row(
                                    children: [
                                      Icon(Icons.info_outline_rounded,
                                          size: 16.sp, color: AppColors.primaryColor),
                                      6.pw,
                                      Text(
                                        S.of(context).minSpendLimit(minSpend!.toStringAsFixed(0)),
                                        style: Styles.textStyle12Bold(context).copyWith(
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),

                          if (expiryDateStr != null && expiryDateStr!.isNotEmpty) ...[
                            16.ph,
                            Row(
                              children: [
                                Icon(
                                  Icons.event_available_rounded,
                                  size: 18.sp,
                                  color: Colors.redAccent,
                                ),
                                8.pw,
                                Text(
                                  S.of(context).validUntilDate(expiryDateStr!),
                                  style: Styles.textStyle12Bold(context).copyWith(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          28.ph,

                          // Big Action Button "استخدام الكوبون"
                          SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor: AppColors.primaryColor.withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              onPressed: () {
                                _copyToClipboard(context);
                                context.go(
                                  Routes.userHomeView,
                                  extra: {
                                    'appliedCouponCode': code,
                                  },
                                );
                              },
                              icon: Icon(Icons.card_giftcard_rounded, size: 20.sp),
                              label: Text(
                                S.of(context).useCouponNow,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
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
                        Text(
                          S.of(context).failedToLoadImage,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
