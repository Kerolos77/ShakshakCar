import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/coupons/domain/entities/coupon_entity.dart';
import 'package:shakshak/features/shared/coupons/presentation/cubit/coupon_cubit.dart';
import 'package:shakshak/features/shared/coupons/presentation/cubit/coupon_state.dart';

/// A self-contained widget that handles coupon entry, validation, and display.
/// Place it wherever the trip price summary is shown (e.g. user_offer_widget or trip_info_column_widget).
class CouponInputWidget extends StatefulWidget {
  /// The current order/trip amount used to validate min-spend and calculate the discount.
  final double orderAmount;

  /// Pre-filled code (e.g. passed from CouponDetailsView via navigation extra).
  final String? prefilledCode;

  /// Available coupons from the user's coupon list (used as local fallback).
  final List<CouponEntity>? availableCoupons;

  /// Callback fired when a coupon is applied: (couponCode, couponId, discountAmount, finalAmount).
  final void Function(String code, String? couponId, double discount, double finalAmount)? onCouponApplied;

  /// Callback fired when the coupon is removed.
  final void Function()? onCouponRemoved;

  const CouponInputWidget({
    super.key,
    required this.orderAmount,
    this.prefilledCode,
    this.availableCoupons,
    this.onCouponApplied,
    this.onCouponRemoved,
  });

  @override
  State<CouponInputWidget> createState() => _CouponInputWidgetState();
}

class _CouponInputWidgetState extends State<CouponInputWidget> {
  final TextEditingController _codeController = TextEditingController();
  late CouponCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<CouponCubit>();
    if (widget.prefilledCode != null && widget.prefilledCode!.isNotEmpty) {
      _codeController.text = widget.prefilledCode!;
      // Auto-validate if pre-filled
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyCode();
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _applyCode() {
    _cubit.validateAndApplyCoupon(
      code: _codeController.text,
      orderAmount: widget.orderAmount,
      availableCoupons: widget.availableCoupons,
    );
  }

  void _removeCode() {
    _codeController.clear();
    _cubit.removeCoupon();
    widget.onCouponRemoved?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<CouponCubit, CouponState>(
        bloc: _cubit,
        listener: (context, state) {
          if (state is CouponAppliedSuccess) {
            widget.onCouponApplied?.call(
              state.code,
              state.couponId,
              state.discountAmount,
              state.finalAmount,
            );
          }
          if (state is CouponRemoved) {
            widget.onCouponRemoved?.call();
          }
        },
        builder: (context, state) {
          final isLoading = state is CouponLoading;
          final isApplied = state is CouponAppliedSuccess;
          final hasError = state is CouponValidationError;

          return Container(
            margin: EdgeInsets.symmetric(vertical: 4.h),
            decoration: BoxDecoration(
              color: isApplied
                  ? const Color(0xFF2E7D32).withValues(alpha: 0.07)
                  : isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isApplied
                    ? const Color(0xFF2E7D32).withValues(alpha: 0.4)
                    : hasError
                        ? Colors.red.withValues(alpha: 0.4)
                        : AppColors.primaryColor.withValues(alpha: 0.2),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Input Row ──────────────────────────────────────────────
                Row(
                  children: [
                    SizedBox(width: 12.w),
                    Icon(
                      isApplied
                          ? Icons.check_circle_rounded
                          : Icons.confirmation_number_outlined,
                      color: isApplied
                          ? const Color(0xFF2E7D32)
                          : AppColors.primaryColor,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: _codeController,
                        enabled: !isApplied && !isLoading,
                        textCapitalization: TextCapitalization.characters,
                        style: Styles.textStyle14Bold(context).copyWith(
                          letterSpacing: 1.5,
                          color: isApplied
                              ? const Color(0xFF2E7D32)
                              : null,
                        ),
                        decoration: InputDecoration(
                          hintText: 'أدخل كود الخصم',
                          hintStyle: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 13.sp,
                            letterSpacing: 0,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        onSubmitted: (_) => _applyCode(),
                      ),
                    ),
                    // Apply / Remove button
                    isApplied
                        ? GestureDetector(
                            onTap: _removeCode,
                            child: Container(
                              margin: EdgeInsets.all(6.r),
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.red,
                                size: 16.sp,
                              ),
                            ),
                          )
                        : isLoading
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: SizedBox(
                                  width: 18.r,
                                  height: 18.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: _applyCode,
                                child: Container(
                                  margin: EdgeInsets.all(6.r),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    'تطبيق',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                  ],
                ),

                // ── Applied Discount Banner ────────────────────────────────
                if (isApplied) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.r),
                        bottomRight: Radius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_offer_rounded,
                            color: const Color(0xFF2E7D32), size: 14.sp),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            '${state.message} — خصم ${state.discountAmount.toStringAsFixed(0)} ج.م',
                            style: TextStyle(
                              color: const Color(0xFF2E7D32),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // ── Error message ─────────────────────────────────────────
                if (hasError) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.r),
                        bottomRight: Radius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline_rounded,
                            color: Colors.red, size: 14.sp),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            state.message,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
