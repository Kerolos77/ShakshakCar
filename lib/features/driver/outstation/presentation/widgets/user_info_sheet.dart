import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/utils/styles.dart';

import 'package:shakshak/features/shared/review/presentation/view_models/review_cubit.dart';
import 'package:shakshak/features/shared/review/presentation/views/user_reviews_view.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_user_entity.dart';

class UserInfoSheet extends StatelessWidget {
  final NewRideUserEntity user;

  const UserInfoSheet({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewCubit(sl(), sl())
        ..fetchUserReviews(userId: int.tryParse(user.id.toString()) ?? 0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.9),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
              child: BlocBuilder<ReviewCubit, ReviewState>(
                builder: (context, state) {
                  double rating = 0.0;
                  int totalReviews = 0;
                  bool isLoading = state is ReviewLoading;

                  if (state is UserReviewSuccess) {
                    rating = state.userReviewResponse.data.user.averageRating;
                    totalReviews =
                        state.userReviewResponse.data.user.totalReviews;
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Handle
                      Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      24.ph,

                      // Big Avatar with Ring
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Styles.getPrimaryColor(context)
                                .withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50.r,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: user.image.isNotEmpty
                              ? NetworkImage(user.image)
                              : null,
                          child: user.image.isEmpty
                              ? Icon(Icons.person,
                                  size: 40.r, color: Colors.grey)
                              : null,
                        ),
                      ),
                      16.ph,

                      // Name & Verified Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.name,
                            style: Styles.textStyle20Bold(context),
                          ),
                          8.pw,
                          Icon(Icons.verified,
                              color: Colors.blue.shade400, size: 20.r),
                        ],
                      ),
                      4.ph,

                      // Average Rating
                      if (isLoading)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Styles.getPrimaryColor(context),
                            ),
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(5, (index) {
                              if (index < rating.floor()) {
                                return Icon(Icons.star_rounded,
                                    color: Colors.orange, size: 20.r);
                              } else if (index < rating &&
                                  rating % 1 != 0 &&
                                  index == rating.floor()) {
                                return Icon(Icons.star_half_rounded,
                                    color: Colors.orange, size: 20.r);
                              } else {
                                return Icon(Icons.star_outline_rounded,
                                    color: Colors.orange, size: 20.r);
                              }
                            }),
                            8.pw,
                            Text(rating.toStringAsFixed(1),
                                style: Styles.textStyle14Bold(context)),
                            4.pw,
                            Text('($totalReviews)',
                                style: Styles.textStyle12SemiBold(context)
                                    .copyWith(color: Colors.grey)),
                          ],
                        ),
                      24.ph,

                      // Stats Row
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => UserReviewsView(
                              userId: int.tryParse(user.id.toString()) ?? 0,
                              userName: user.name,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem(
                                context, 'تقييم', totalReviews.toString()),
                            _buildDivider(),
                            _buildStatItem(
                                context, 'انضم', '2024'), // Mock for now
                            _buildDivider(),
                            _buildStatItem(
                                context, 'رحلة', '15+'), // Mock for now
                          ],
                        ),
                      ),
                      24.ph,

                      // Close Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Styles.getPrimaryColor(context),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('حسناً',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(value, style: Styles.textStyle16Bold(context)),
        4.ph,
        Text(label,
            style: Styles.textStyle12SemiBold(context)
                .copyWith(color: Colors.grey)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30.h,
      width: 1,
      color: Colors.grey.shade300,
    );
  }
}
