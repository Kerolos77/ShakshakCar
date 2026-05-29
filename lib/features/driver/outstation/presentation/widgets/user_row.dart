import 'package:flutter/material.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/features/driver/outstation/presentation/widgets/user_info_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';

import 'package:shakshak/features/shared/review/presentation/view_models/review_cubit.dart';

import '../../../../../core/router/route_args.dart';
import '../../../../../core/router/router_helper.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../generated/l10n.dart';
import '../../../../user/user_home/domain/entities/new_ride_data_entity.dart';

class UserRow extends StatelessWidget {
  const UserRow({
    super.key,
    required this.ride,
    required this.currentAmount,
    required this.isAnyActionLoading,
    this.showDetailsButton = true,
  });

  final NewRideDataEntity ride;
  final double currentAmount;
  final bool isAnyActionLoading;
  final bool showDetailsButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => UserInfoSheet(user: ride.user),
            );
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                backgroundImage: ride.user.image.isNotEmpty
                    ? NetworkImage(ride.user.image)
                    : null,
                child: ride.user.image.isEmpty
                    ? Icon(Icons.person,
                        color: Theme.of(context).hintColor, size: 18.r)
                    : null,
              ),
              12.pw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ride.user.name, style: Styles.textStyle16Bold(context)),
                  BlocProvider(
                    create: (context) => ReviewCubit(sl(), sl())
                      ..fetchUserReviews(
                          userId: int.tryParse(ride.user.id.toString()) ?? 0),
                    child: BlocBuilder<ReviewCubit, ReviewState>(
                      builder: (context, state) {
                        String rating = '...';
                        if (state is UserReviewSuccess) {
                          rating = state
                              .userReviewResponse.data.user.averageRating
                              .toStringAsFixed(1);
                        } else if (state is ReviewFailure) {
                          rating = '0.0';
                        }
                        return Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 16.r),
                            4.pw,
                            Text(
                              rating,
                              style: Styles.textStyle14SemiBold(context),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${currentAmount.toInt()} ${S.of(context).currency}',
              style: Styles.textStyle18Bold(context).copyWith(
                color: Styles.getPrimaryColor(context),
              ),
            ),
            if (showDetailsButton)
              GestureDetector(
                onTap: () {
                  navigateTo(context, Routes.tripMapView,
                      extra: TripMapArgs(ride: ride));
                },
                child: Text(
                  S.of(context).tripDetails,
                  style: Styles.textStyle12SemiBold(context).copyWith(
                    color: Styles.getPrimaryColor(context),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
