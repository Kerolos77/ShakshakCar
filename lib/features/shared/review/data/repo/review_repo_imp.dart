import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';

import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/features/shared/review/data/models/review_model.dart';
import 'package:shakshak/features/shared/review/data/models/user_review_response.dart';
import 'package:shakshak/features/shared/review/domain/entities/review_entity.dart';
import 'package:shakshak/features/shared/review/domain/entities/user_review_response_entity.dart';
import 'package:shakshak/features/shared/review/domain/repositories/review_repo.dart';

class ReviewRepoImp implements ReviewRepo {
  @override
  Future<Either<Failure, ReviewEntity>> submitReview({
    required int rate,
    required String comment,
    required int orderId,
  }) async {
    try {
      var data = await DioHelper.postData(
          url: '${ApiConstant.reviewUrl}/order/$orderId',
          token: CacheHelper.getData(key: AppConstant.kToken),
          data: {
            'rating': rate,
            'comment': comment,
          });
      return right(ReviewModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserReviewResponseEntity>> getUserReviews({
    required int userId,
  }) async {
    try {
      var data = await DioHelper.getData(
        url: '${ApiConstant.userReviewUrl}/$userId',
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      return right(UserReviewResponse.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
