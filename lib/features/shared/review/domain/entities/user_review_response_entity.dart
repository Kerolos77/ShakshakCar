class UserReviewResponseEntity {
  final bool success;
  final String message;
  final UserReviewDataEntity data;

  const UserReviewResponseEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}

class UserReviewDataEntity {
  final ReviewUserEntity user;
  final List<ReviewItemEntity> reviews;
  final PaginationEntity pagination;

  const UserReviewDataEntity({
    required this.user,
    required this.reviews,
    required this.pagination,
  });
}

class ReviewUserEntity {
  final int id;
  final String name;
  final String avatar;
  final double averageRating;
  final int totalReviews;

  const ReviewUserEntity({
    required this.id,
    required this.name,
    required this.avatar,
    required this.averageRating,
    required this.totalReviews,
  });
}

class ReviewItemEntity {
  final int id;
  final double rate;
  final String comment;
  final String createdAt;

  const ReviewItemEntity({
    required this.id,
    required this.rate,
    required this.comment,
    required this.createdAt,
  });
}

class PaginationEntity {
  final int currentPage;
  final int totalPages;
  final int totalReviews;
  final int perPage;

  const PaginationEntity({
    required this.currentPage,
    required this.totalPages,
    required this.totalReviews,
    required this.perPage,
  });
}
