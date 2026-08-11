import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/shared/coupons/data/models/coupon_model.dart';
import 'package:shakshak/features/shared/coupons/domain/entities/coupon_entity.dart';
import 'package:shakshak/features/shared/coupons/domain/repositories/coupon_repo.dart';

class CouponRepoImp implements CouponRepo {
  @override
  Future<Either<Failure, List<CouponEntity>>> getUserCoupons() async {
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

        final List<CouponEntity> coupons = rawList
            .whereType<Map<String, dynamic>>()
            .map((item) => CouponModel.fromJson(item))
            .toList();

        return right(coupons);
      }
      return right([]);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> validateCoupon({
    required String code,
    required double amount,
  }) async {
    try {
      final token = CacheHelper.getData(key: AppConstant.kToken);
      
      dynamic response;
      try {
        response = await DioHelper.postData(
          url: 'coupons/validate',
          token: token,
          data: {
            'code': code,
            'amount': amount,
          },
        );
      } catch (e) {
        // Fallback endpoint if coupons/validate is named user/coupons/validate
        try {
          response = await DioHelper.postData(
            url: 'user/coupons/apply',
            token: token,
            data: {
              'code': code,
              'amount': amount,
            },
          );
        } catch (_) {
          rethrow;
        }
      }

      if (response != null && response.data != null) {
        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          bool status = resData['status'] == true || resData['success'] == true;
          if (status || resData['data'] != null) {
            final couponInfo = resData['data'] ?? resData;
            return right({
              'coupon_id': couponInfo['coupon_id'] ?? couponInfo['id'],
              'code': couponInfo['code'] ?? code,
              'type': couponInfo['type'] ?? 'fixed',
              'discount_amount': double.tryParse(couponInfo['discount_amount']?.toString() ?? '0') ?? 0.0,
              'final_amount': double.tryParse(couponInfo['final_amount']?.toString() ?? '0') ?? (amount - (double.tryParse(couponInfo['discount_amount']?.toString() ?? '0') ?? 0.0)),
              'message': resData['message'] ?? 'تم تطبيق الكوبون بنجاح',
            });
          } else {
            return left(ServerFailure(resData['message'] ?? 'الكوبون غير صالح'));
          }
        }
      }
      return left(ServerFailure('تعذر التحقق من الكوبون'));
    } catch (e) {
      if (e is DioException) {
        // If 404 or backend route not ready yet, return a clean ServerFailure so local check can handle it
        final msg = e.response?.data is Map && e.response?.data['message'] != null
            ? e.response?.data['message']
            : 'الكوبون غير صالح أو انتهت صلاحيته';
        return left(ServerFailure(msg));
      }
      return left(ServerFailure('حدث خطأ أثناء التحقق من الكوبون'));
    }
  }
}
