import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/shared/shop/data/models/package_model.dart';
import 'package:shakshak/features/shared/shop/data/models/subscription_status_model.dart';
import 'package:shakshak/features/shared/shop/domain/repositories/shop_repo.dart';

class ShopRepoImp implements ShopRepo {
  @override
  Future<Either<Failure, ShopResponseModel>> getPackages({required bool isDriver}) async {
    try {
      final url = ApiConstant.packagesUrl;
      final response = await DioHelper.getData(
        url: url,
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      return right(ShopResponseModel.fromJson(response.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> buyPackage({
    required bool isDriver,
    required int packageId,
    required String paymentMethod,
  }) async {
    try {
      final method = paymentMethod == 'wallet' ? 'cash' : paymentMethod;
      final url = ApiConstant.buyPackageUrl;
      final response = await DioHelper.postData(
        url: url,
        token: CacheHelper.getData(key: AppConstant.kToken),
        data: {
          'package_id': packageId,
          'payment_method': method,
        },
      );
      return right(response.data);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionStatusModel>> getSubscriptionStatus() async {
    try {
      final url = ApiConstant.subscriptionStatusUrl;
      final response = await DioHelper.getData(
        url: url,
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      return right(SubscriptionStatusModel.fromJson(response.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
