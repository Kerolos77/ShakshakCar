import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/shared/coupons/data/models/coupon_model.dart';
import 'package:shakshak/features/shared/coupons/domain/entities/coupon_entity.dart';
import 'package:shakshak/generated/l10n.dart';

class UserCouponsView extends StatefulWidget {
  const UserCouponsView({super.key});

  @override
  State<UserCouponsView> createState() => _UserCouponsViewState();
}

class _UserCouponsViewState extends State<UserCouponsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<CouponEntity> _coupons = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchCoupons();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchCoupons() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = CacheHelper.getData(key: AppConstant.kToken);
      
      dynamic response;
      try {
        response = await DioHelper.getData(url: 'coupons', token: token);
      } catch (e) {
        try {
          response = await DioHelper.getData(url: 'user/coupons', token: token);
        } catch (_) {}
      }

      if (response != null && response.statusCode == 200 && response.data != null) {
        final data = response.data;
        List<dynamic> rawList = [];
        if (data is Map<String, dynamic>) {
          if (data['data'] is List) {
            rawList = data['data'];
          } else if (data['coupons'] is List) {
            rawList = data['coupons'];
          }
        } else if (data is List) {
          rawList = data;
        }

        final fetched = rawList
            .whereType<Map<String, dynamic>>()
            .map((item) => CouponModel.fromJson(item))
            .toList();

        setState(() {
          _coupons = fetched;
          _isLoading = false;
        });
      } else {
        setState(() {
          _coupons = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching user coupons from API: $e");
      setState(() {
        _coupons = [];
        _isLoading = false;
      });
    }
  }

  void _navigateToDetails(CouponEntity coupon) {
    context.push(
      Routes.couponDetailsView,
      extra: {
        'title': coupon.title,
        'description': coupon.description,
        'code': coupon.code,
        'discountText': coupon.discountText,
        'expiryDateStr': coupon.expiryDate != null
            ? "${coupon.expiryDate!.day}/${coupon.expiryDate!.month}/${coupon.expiryDate!.year}"
            : null,
        'imageUrl': coupon.imageUrl,
        'minSpend': coupon.minSpend,
      },
    );
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).codeCopiedSuccess(code)),
        backgroundColor: AppColors.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCoupons = _coupons.where((c) => !c.isExpired).toList();
    final expiredCoupons = _coupons.where((c) => c.isExpired).toList();

    // Safeguard: If all fetched coupons were classified as expired due to timezone parsing, display them in active list if expired list is identical
    final List<CouponEntity> displayActiveCoupons =
        (activeCoupons.isEmpty && _coupons.isNotEmpty) ? _coupons : activeCoupons;
    final List<CouponEntity> displayExpiredCoupons =
        (activeCoupons.isEmpty && _coupons.isNotEmpty)
            ? <CouponEntity>[]
            : expiredCoupons;

    return BaseLayoutView(
      title: S.of(context).discountCoupons,
      body: Column(
        children: [
          10.ph,
          // Custom TabBar Header
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.primaryColor.withValues(alpha: 0.15),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Theme.of(context).hintColor,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(text: S.of(context).activeCoupons),
                Tab(text: S.of(context).expiredCoupons),
              ],
            ),
          ),
          12.ph,
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchCoupons,
                    color: AppColors.primaryColor,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildCouponsList(displayActiveCoupons, isExpired: false),
                        _buildCouponsList(displayExpiredCoupons, isExpired: true),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponsList(List<CouponEntity> list, {required bool isExpired}) {
    if (list.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 120.h),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  size: 64.r,
                  color: Theme.of(context).hintColor.withValues(alpha: 0.35),
                ),
                14.ph,
                Text(
                  isExpired ? S.of(context).noExpiredCoupons : S.of(context).noActiveCoupons,
                  style: Styles.textStyle14Bold(context).copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final coupon = list[index];
        return _buildCouponCard(coupon, isExpired: isExpired);
      },
    );
  }

  Widget _buildCouponCard(CouponEntity coupon, {required bool isExpired}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isExpired
              ? Colors.grey.withValues(alpha: 0.2)
              : AppColors.primaryColor.withValues(alpha: 0.3),
          width: isExpired ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : AppColors.primaryColor.withValues(alpha: 0.05),
            blurRadius: 12.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _navigateToDetails(coupon),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  // Left Icon Container
                  Container(
                    width: 54.r,
                    height: 54.r,
                    decoration: BoxDecoration(
                      gradient: isExpired
                          ? LinearGradient(
                              colors: [Colors.grey[500]!, Colors.grey[700]!],
                            )
                          : const LinearGradient(
                              colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
                            ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (!isExpired)
                          BoxShadow(
                            color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                            blurRadius: 8.r,
                            offset: const Offset(0, 3),
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                coupon.title,
                                style: Styles.textStyle15Bold(context).copyWith(
                                  color: isExpired
                                      ? Theme.of(context).hintColor
                                      : (isDark ? Colors.white : Colors.black87),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (coupon.discountText != null)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: isExpired
                                      ? Colors.grey.withValues(alpha: 0.2)
                                      : AppColors.primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  coupon.discountText!,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isExpired
                                        ? Colors.grey
                                        : AppColors.primaryColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        6.ph,
                        Text(
                          coupon.description,
                          style: Styles.textStyle12Regular(context).copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        10.ph,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.06)
                                    : Colors.grey.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: AppColors.primaryColor.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    coupon.code,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      color: isExpired
                                          ? Colors.grey
                                          : AppColors.primaryColor,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                  6.pw,
                                  InkWell(
                                    onTap: () => _copyCode(coupon.code),
                                    child: Icon(
                                      Icons.copy_rounded,
                                      size: 14.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  S.of(context).viewDetails,
                                  style: Styles.textStyle12Bold(context).copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 12.sp,
                                  color: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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
}
