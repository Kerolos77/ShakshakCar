import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/features/shared/notifications/presentation/manager/notification_cubit.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';

import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';

class UserHomeHeader extends StatelessWidget {
  const UserHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                child: Icon(Icons.person,
                    color: Theme.of(context).colorScheme.onPrimary, size: 28.r),
              ),
              12.pw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${S.of(context).welcomeBack},',
                    style: Styles.textStyle14(context).copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.8),
                    ),
                  ),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final profile = context.read<AuthCubit>().profileModel?.data;
                      final points = profile?.rewardPoints ?? 0;
                      return Row(
                        children: [
                          Text(
                            CacheHelper.getData(key: AppConstant.kUserName) ?? 'User',
                            style: Styles.textStyle18Bold(context).copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          if (points > 0) ...[
                            8.pw,
                            GestureDetector(
                              onTap: () => navigateTo(context, Routes.pointsView),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: Colors.orange.withOpacity(0.5)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.stars_rounded, color: Colors.orange, size: 14.r),
                                    4.pw,
                                    Text(
                                      points.toString(),
                                      style: Styles.textStyle12(context).copyWith(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              int unreadCount = 0;
              if (state is NotificationLoaded) {
                unreadCount = state.unreadCount;
              } else {
                unreadCount = context.read<NotificationCubit>().unreadCount;
              }
              return IconButton(
                onPressed: () {
                  navigateTo(context, Routes.notificationView);
                },
                icon: Badge(
                  isLabelVisible: unreadCount > 0,
                  label: Text(unreadCount.toString()),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 28.r,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
