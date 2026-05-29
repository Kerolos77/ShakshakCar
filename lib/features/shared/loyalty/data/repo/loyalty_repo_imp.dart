import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/shared/loyalty/data/models/points_history_model.dart';
import 'package:shakshak/features/shared/loyalty/data/repo/loyalty_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class LoyaltyRepoImp implements LoyaltyRepo {
  @override
  Future<Either<Failure, PointsHistoryResponse>> getPointsHistory() async {
    try {
      var data = await DioHelper.getData(
        url: ApiConstant.pointsHistoryUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      return right(PointsHistoryResponse.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
