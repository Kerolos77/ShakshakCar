import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/review/domain/entities/review_entity.dart';
import 'package:shakshak/features/shared/review/domain/repositories/review_repo.dart';

class SubmitReviewParameters {
  final int rate;
  final String comment;
  final int orderId;

  const SubmitReviewParameters({
    required this.rate,
    required this.comment,
    required this.orderId,
  });
}

class SubmitReviewUseCase
    extends BaseUseCase<ReviewEntity, SubmitReviewParameters> {
  final ReviewRepo reviewRepo;

  SubmitReviewUseCase(this.reviewRepo);

  @override
  Future<Either<Failure, ReviewEntity>> call(
      SubmitReviewParameters parameters) async {
    return await reviewRepo.submitReview(
      rate: parameters.rate,
      comment: parameters.comment,
      orderId: parameters.orderId,
    );
  }
}
