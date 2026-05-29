import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shakshak/features/shared/review/domain/entities/review_entity.dart';
import 'package:shakshak/features/shared/review/domain/entities/user_review_response_entity.dart';
import 'package:shakshak/features/shared/review/domain/usecases/submit_review_usecase.dart';
import 'package:shakshak/features/shared/review/domain/usecases/get_user_reviews_usecase.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit(this.submitReviewUseCase, this.getUserReviewsUseCase)
      : super(ReviewInitial());

  final SubmitReviewUseCase submitReviewUseCase;
  final GetUserReviewsUseCase getUserReviewsUseCase;

  Future<void> submitReview({
    required int rate,
    required String comment,
    required int orderId,
  }) async {
    emit(ReviewLoading());
    var result = await submitReviewUseCase(SubmitReviewParameters(
      rate: rate,
      comment: comment,
      orderId: orderId,
    ));
    result.fold((error) {
      debugPrint("error while submitting review ${error.message}");
      return emit(ReviewFailure(errorMessage: error.message));
    }, (success) {
      return emit(ReviewSuccess(reviewModel: success));
    });
  }

  Future<void> fetchUserReviews({required int userId}) async {
    emit(ReviewLoading());
    var result = await getUserReviewsUseCase(userId);
    result.fold((error) {
      debugPrint("error while fetching user reviews ${error.message}");
      return emit(ReviewFailure(errorMessage: error.message));
    }, (success) {
      return emit(UserReviewSuccess(userReviewResponse: success));
    });
  }
}
