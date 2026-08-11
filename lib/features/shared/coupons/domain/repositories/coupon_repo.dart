import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/coupons/domain/entities/coupon_entity.dart';

abstract class CouponRepo {
  Future<Either<Failure, List<CouponEntity>>> getUserCoupons();
  Future<Either<Failure, Map<String, dynamic>>> validateCoupon({
    required String code,
    required double amount,
  });
}
