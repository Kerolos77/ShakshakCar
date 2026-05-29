import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/driver/store/data/models/driver_package_model.dart';
import 'package:shakshak/features/user/store/domain/repositories/user_store_repo.dart';

class UserStoreRepoImp implements UserStoreRepo {
  @override
  Future<Either<Failure, List<DriverPackageModel>>> getPackages() async {
    try {
      var response = await DioHelper.getData(
        url: ApiConstant.packagesUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      List<DriverPackageModel> packages = [];
      if (response.data['data'] != null && response.data['data']['packages'] != null) {
        packages = (response.data['data']['packages'] as List)
            .map((e) => DriverPackageModel.fromJson(e))
            .toList();
      }
      return right(packages);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> buyPackage({required int packageId, required String paymentMethod}) async {
    try {
      var response = await DioHelper.postData(
        url: ApiConstant.buyPackageUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
        data: {
          'package_id': packageId,
          'payment_method': paymentMethod, // 'points' or 'cash' (per backend controller)
        },
      );
      return right(response.statusCode == 200 || response.statusCode == 201);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
