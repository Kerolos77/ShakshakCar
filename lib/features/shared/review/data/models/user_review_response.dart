import 'package:shakshak/features/shared/review/domain/entities/user_review_response_entity.dart';

class UserReviewResponse extends UserReviewResponseEntity {
  UserReviewResponse({
    required super.success,
    required super.message,
    required super.data,
  });

  factory UserReviewResponse.fromJson(Map<String, dynamic> json) {
    return UserReviewResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: UserReviewData.fromJson(json['data'] ?? {}),
    );
  }
}

class UserReviewData extends UserReviewDataEntity {
  UserReviewData({
    required super.user,
    required super.reviews,
    required super.pagination,
  });

  factory UserReviewData.fromJson(Map<String, dynamic> json) {
    return UserReviewData(
      user: ReviewUser.fromJson(json['user'] ?? {}),
      reviews: (json['reviews'] as List? ?? [])
          .map((e) => ReviewItem.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class ReviewUser extends ReviewUserEntity {
  ReviewUser({
    required super.id,
    required super.name,
    required super.avatar,
    required super.averageRating,
    required super.totalReviews,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      averageRating:
          double.tryParse(json['average_rating']?.toString() ?? '0') ?? 0.0,
      totalReviews: json['total_reviews'] ?? 0,
    );
  }
}

class ReviewItem extends ReviewItemEntity {
  ReviewItem({
    required super.id,
    required super.rate,
    required super.comment,
    required super.createdAt,
  });

  factory ReviewItem.fromJson(Map<String, dynamic> json) {
    return ReviewItem(
      id: json['id'] ?? 0,
      rate: double.tryParse(json['rate']?.toString() ?? '0') ?? 0.0,
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class Pagination extends PaginationEntity {
  Pagination({
    required super.currentPage,
    required super.totalPages,
    required super.totalReviews,
    required super.perPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalReviews: json['total_reviews'] ?? 0,
      perPage: json['per_page'] ?? 10,
    );
  }
}
