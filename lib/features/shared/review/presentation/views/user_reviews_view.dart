import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/review/presentation/view_models/review_cubit.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:intl/intl.dart';

class UserReviewsView extends StatelessWidget {
  final int userId;
  final String userName;

  const UserReviewsView({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReviewCubit(sl(), sl())..fetchUserReviews(userId: userId),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
          minHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              12.ph,
              // Handle for bottom sheet
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              16.ph,
              Text(
                S.of(context).review,
                style: Styles.textStyle18Bold(context),
              ),
              8.ph,
              Text(
                userName,
                style: Styles.textStyle14SemiBold(context).copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              20.ph,
              const Divider(height: 1),
              Flexible(
                child: BlocBuilder<ReviewCubit, ReviewState>(
                  builder: (context, state) {
                    if (state is ReviewLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is UserReviewSuccess) {
                      final reviews = state.userReviewResponse.data.reviews;

                      if (reviews.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(40.0.r),
                          child: Column(
                            children: [
                              Icon(Icons.rate_review_outlined,
                                  size: 64.r,
                                  color: Theme.of(context).dividerColor),
                              16.ph,
                              Text(
                                "لا توجد تعليقات بعد", // Fallback for now
                                style: Styles.textStyle16Bold(context),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(20.r),
                        itemCount: reviews.length,
                        separatorBuilder: (context, index) => 16.ph,
                        itemBuilder: (context, index) {
                          final item = reviews[index];
                          return Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: Theme.of(context)
                                    .dividerColor
                                    .withOpacity(0.1),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: List.generate(5, (starIndex) {
                                        return Icon(
                                          starIndex < item.rate.floor()
                                              ? Icons.star_rounded
                                              : Icons.star_outline_rounded,
                                          color: Colors.amber,
                                          size: 18.r,
                                        );
                                      }),
                                    ),
                                    Text(
                                      _formatDate(item.createdAt),
                                      style: Styles.textStyle12SemiBold(context)
                                          .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.4),
                                      ),
                                    ),
                                  ],
                                ),
                                8.ph,
                                if (item.comment.isNotEmpty)
                                  Text(
                                    item.comment,
                                    style: Styles.textStyle14SemiBold(context),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (state is ReviewFailure) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0.r),
                          child: Text(state.errorMessage),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              20.ph,
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final DateTime date = DateTime.parse(dateStr);
      return DateFormat.yMMMd().format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
