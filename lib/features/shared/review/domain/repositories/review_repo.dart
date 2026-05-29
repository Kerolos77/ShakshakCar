import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/review/domain/entities/review_entity.dart';
import 'package:shakshak/features/shared/review/domain/entities/user_review_response_entity.dart';

abstract class ReviewRepo {
  Future<Either<Failure, ReviewEntity>> submitReview({
    required int rate,
    required String comment,
    required int orderId,
  });

  Future<Either<Failure, UserReviewResponseEntity>> getUserReviews({
    required int userId,
  });
}
