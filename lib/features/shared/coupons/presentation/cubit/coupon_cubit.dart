import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/features/shared/coupons/domain/entities/coupon_entity.dart';
import 'package:shakshak/features/shared/coupons/domain/repositories/coupon_repo.dart';
import 'package:shakshak/features/shared/coupons/presentation/cubit/coupon_state.dart';

class CouponCubit extends Cubit<CouponState> {
  final CouponRepo couponRepo;

  CouponCubit({required this.couponRepo}) : super(CouponInitial());

  CouponEntity? selectedCoupon;
  String? appliedCode;
  String? appliedCouponId;
  double appliedDiscount = 0.0;

  Future<void> fetchUserCoupons() async {
    emit(CouponLoading());
    final result = await couponRepo.getUserCoupons();
    result.fold(
      (failure) => emit(CouponValidationError(failure.message)),
      (coupons) => emit(UserCouponsLoaded(coupons)),
    );
  }

  Future<void> validateAndApplyCoupon({
    required String code,
    required double orderAmount,
    List<CouponEntity>? availableCoupons,
  }) async {
    final cleanCode = code.trim();
    if (cleanCode.isEmpty) {
      emit(const CouponValidationError('رجاءً أدخل كود الخصم أولاً'));
      return;
    }

    emit(CouponLoading());

    // 1. Try validating via Backend API first
    final result = await couponRepo.validateCoupon(code: cleanCode, amount: orderAmount);

    await result.fold(
      (failure) async {
        // 2. Fallback: Local Validation if backend route is not created yet
        if (availableCoupons != null && availableCoupons.isNotEmpty) {
          final matched = availableCoupons.firstWhere(
            (c) => c.code.toLowerCase() == cleanCode.toLowerCase(),
            orElse: () => const CouponEntity(id: '', title: '', description: '', code: ''),
          );

          if (matched.id.isNotEmpty) {
            if (matched.isExpired) {
              emit(const CouponValidationError('عذراً، هذا الكوبون منتهي الصلاحية'));
              return;
            }
            if (matched.minSpend != null && orderAmount < matched.minSpend!) {
              emit(CouponValidationError(
                  'الحد الأدنى لقيمة الطلب لاستخدام هذا الكوبون هو ${matched.minSpend!.toStringAsFixed(0)} ج.م'));
              return;
            }

            double discount = 0.0;
            if (matched.discountText != null && matched.discountText!.contains('%')) {
              final pctStr = matched.discountText!.replaceAll(RegExp(r'[^0-9.]'), '');
              final pct = double.tryParse(pctStr) ?? 0.0;
              discount = (orderAmount * pct) / 100.0;
            } else if (matched.discountText != null) {
              final valStr = matched.discountText!.replaceAll(RegExp(r'[^0-9.]'), '');
              discount = double.tryParse(valStr) ?? 0.0;
            } else {
              discount = 10.0; // Default fallback discount
            }

            if (discount > orderAmount) discount = orderAmount;
            final finalAmt = orderAmount - discount;

            selectedCoupon = matched;
            appliedCode = matched.code;
            appliedCouponId = matched.id;
            appliedDiscount = discount;

            emit(CouponAppliedSuccess(
              code: matched.code,
              couponId: matched.id,
              discountAmount: discount,
              finalAmount: finalAmt,
              message: 'تم تطبيق الكوبون بنجاح!',
            ));
            return;
          }
        }

        emit(CouponValidationError(failure.message));
      },
      (data) async {
        appliedCode = data['code']?.toString() ?? cleanCode;
        appliedCouponId = data['coupon_id']?.toString();
        appliedDiscount = (data['discount_amount'] as num?)?.toDouble() ?? 0.0;
        final finalAmt = (data['final_amount'] as num?)?.toDouble() ?? (orderAmount - appliedDiscount);

        emit(CouponAppliedSuccess(
          code: appliedCode!,
          couponId: appliedCouponId,
          discountAmount: appliedDiscount,
          finalAmount: finalAmt,
          message: data['message']?.toString() ?? 'تم تطبيق الكوبون بنجاح!',
        ));
      },
    );
  }

  void removeCoupon() {
    selectedCoupon = null;
    appliedCode = null;
    appliedCouponId = null;
    appliedDiscount = 0.0;
    emit(CouponRemoved());
  }
}
