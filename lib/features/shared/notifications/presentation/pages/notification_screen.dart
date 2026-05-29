import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/shared/notifications/presentation/manager/notification_cubit.dart';
import 'package:shakshak/features/shared/notifications/presentation/widgets/notification_item.dart';
import 'package:shakshak/generated/l10n.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationCubit>().loadNotifications();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutView(
      title: S.of(context).notifications,
      body: BlocBuilder<NotificationCubit, NotificationState>(
        buildWhen: (previous, current) =>
            current is NotificationLoading ||
            current is NotificationLoaded ||
            current is NotificationError,
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationError) {
            return Center(child: Text(state.message));
          } else if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.notifications_off_outlined,
                        size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(S.of(context).noNotificationsYet,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            final hasUnread = state.notifications.any((n) => !n.isRead);

            return Column(
              children: [
                if (hasUnread)
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r)),
                        ),
                        onPressed: () {
                          context.read<NotificationCubit>().markAllAsRead();
                        },
                        icon: Icon(Icons.done_all,
                            size: 20.r, color: Theme.of(context).primaryColor),
                        label: Text(
                          'Mark all as read',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await context
                          .read<NotificationCubit>()
                          .loadNotifications(refresh: true);
                      await context
                          .read<NotificationCubit>()
                          .fetchUnreadCount();
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
                      itemCount: state.notifications.length +
                          (state.isFetchingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.notifications.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final notification = state.notifications[index];
                        return NotificationItem(
                          notification: notification,
                          onTap: () {
                            context
                                .read<NotificationCubit>()
                                .markAsRead(notification.id);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
