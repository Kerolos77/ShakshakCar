import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/review/domain/entities/user_review_response_entity.dart';
import 'package:shakshak/features/shared/review/domain/repositories/review_repo.dart';

class GetUserReviewsUseCase extends BaseUseCase<UserReviewResponseEntity, int> {
  final ReviewRepo reviewRepo;

  GetUserReviewsUseCase(this.reviewRepo);

  @override
  Future<Either<Failure, UserReviewResponseEntity>> call(int parameters) async {
    return await reviewRepo.getUserReviews(userId: parameters);
  }
}
