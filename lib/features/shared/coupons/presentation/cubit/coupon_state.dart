import 'package:equatable/equatable.dart';
import 'package:shakshak/features/shared/coupons/domain/entities/coupon_entity.dart';

abstract class CouponState extends Equatable {
  const CouponState();

  @override
  List<Object?> get props => [];
}

class CouponInitial extends CouponState {}

class CouponLoading extends CouponState {}

class UserCouponsLoaded extends CouponState {
  final List<CouponEntity> coupons;
  const UserCouponsLoaded(this.coupons);

  @override
  List<Object?> get props => [coupons];
}

class CouponAppliedSuccess extends CouponState {
  final String code;
  final String? couponId;
  final double discountAmount;
  final double finalAmount;
  final String message;

  const CouponAppliedSuccess({
    required this.code,
    this.couponId,
    required this.discountAmount,
    required this.finalAmount,
    required this.message,
  });

  @override
  List<Object?> get props => [code, couponId, discountAmount, finalAmount, message];
}

class CouponValidationError extends CouponState {
  final String message;
  const CouponValidationError(this.message);

  @override
  List<Object?> get props => [message];
}

class CouponRemoved extends CouponState {}
