part of 'review_cubit.dart';

@immutable
sealed class ReviewState {}

final class ReviewInitial extends ReviewState {}

final class ReviewLoading extends ReviewState {}

final class ReviewSuccess extends ReviewState {
  final ReviewEntity reviewModel;

  ReviewSuccess({required this.reviewModel});
}

final class UserReviewSuccess extends ReviewState {
  final UserReviewResponseEntity userReviewResponse;

  UserReviewSuccess({required this.userReviewResponse});
}

final class ReviewFailure extends ReviewState {
  final String errorMessage;

  ReviewFailure({required this.errorMessage});
}
