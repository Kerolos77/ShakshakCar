import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/shared/support_tickets/domain/entities/support_ticket_entity.dart';
import 'package:shakshak/features/shared/support_tickets/presentation/cubit/support_ticket_cubit.dart';
import 'package:shakshak/features/shared/support_tickets/presentation/cubit/support_ticket_state.dart';
import 'package:shakshak/features/shared/support_tickets/presentation/widgets/ticket_status_badge.dart';
import 'package:intl/intl.dart';

class SupportTicketsView extends StatefulWidget {
  const SupportTicketsView({super.key});

  @override
  State<SupportTicketsView> createState() => _SupportTicketsViewState();
}

class _SupportTicketsViewState extends State<SupportTicketsView> {
  @override
  void initState() {
    super.initState();
    context.read<SupportTicketCubit>().fetchMyTickets();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutView(
      title: 'تذاكر الدعم الفني',
      body: BlocConsumer<SupportTicketCubit, SupportTicketState>(
        listener: (context, state) {
          if (state is SupportTicketError) {
            showSnackBar(
              context,
              state.message,
              'حدث خطأ',
              AppColors.redColor,
              ContentType.failure,
            );
          }
        },
        builder: (context, state) {
          if (state is SupportTicketLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is MyTicketsLoaded) {
            if (state.tickets.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildTicketsListWithFab(context, state.tickets);
          }
          if (state is SupportTicketError) {
            return _buildEmptyState(context);
          }
          return _buildEmptyState(context);
        },
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.h, right: 16.w, left: 16.w),
        child: FloatingActionButton.extended(
          onPressed: () => navigateTo(context, Routes.createTicketView),
          backgroundColor: AppColors.primaryColor,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text(
            'تكيت جديد',
            style: Styles.textStyle14Medium(context)
                .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: FadeInUp(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.support_agent_rounded,
                size: 50.r,
                color: AppColors.primaryColor.withOpacity(0.6),
              ),
            ),
            20.ph,
            Text(
              'لا توجد تذاكر دعم',
              style: Styles.textStyle18Bold(context),
            ),
            8.ph,
            Text(
              'يمكنك إنشاء تكيت دعم جديد لأي مشكلة تواجهها',
              style: Styles.textStyle14Medium(context),
              textAlign: TextAlign.center,
            ),
            32.ph,
            ElevatedButton.icon(
              onPressed: () => navigateTo(context, Routes.createTicketView),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding:
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: Text(
                'إنشاء تكيت جديد',
                style: Styles.textStyle14Bold(context)
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketsListWithFab(
      BuildContext context, List<SupportTicketEntity> tickets) {
    return Stack(
      children: [
        RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () => context.read<SupportTicketCubit>().fetchMyTickets(),
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 90.h),
            itemCount: tickets.length,
            separatorBuilder: (_, __) => 12.ph,
            itemBuilder: (context, index) {
              return FadeInUp(
                delay: Duration(milliseconds: index * 60),
                child: _buildTicketCard(context, tickets[index]),
              );
            },
          ),
        ),
        _buildFab(context),
      ],
    );
  }

  Widget _buildTicketCard(BuildContext context, SupportTicketEntity ticket) {
    final priorityColors = {
      'low': Colors.green,
      'medium': Colors.blue,
      'high': Colors.orange,
      'urgent': Colors.red,
    };
    final priorityLabels = {
      'low': 'منخفضة',
      'medium': 'متوسطة',
      'high': 'عالية',
      'urgent': 'عاجلة',
    };

    final priorityColor =
        priorityColors[ticket.priority] ?? Colors.grey;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticket.ticketNumber,
                  style: Styles.textStyle12Regular(context).copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TicketStatusBadge(status: ticket.status),
              ],
            ),
            12.ph,
            // Subject
            Text(
              ticket.subject,
              style: Styles.textStyle16Bold(context),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            8.ph,
            // Description
            Text(
              ticket.description,
              style: Styles.textStyle14Medium(context),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            12.ph,
            const Divider(height: 1),
            12.ph,
            // Footer Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Priority Badge
                Row(
                  children: [
                    Icon(Icons.flag_rounded,
                        size: 14.r, color: priorityColor),
                    4.pw,
                    Text(
                      priorityLabels[ticket.priority] ?? ticket.priority,
                      style: Styles.textStyle12Regular(context)
                          .copyWith(color: priorityColor),
                    ),
                  ],
                ),
                // Date
                Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 13.r,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.4)),
                    4.pw,
                    Text(
                      DateFormat('yyyy/MM/dd').format(ticket.createdAt),
                      style: Styles.textStyle12Regular(context).copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Admin Notes (if any)
            if (ticket.adminNotes != null && ticket.adminNotes!.isNotEmpty) ...[
              12.ph,
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8.r),
                  border:
                      Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.admin_panel_settings_rounded,
                        size: 16.r, color: Colors.amber.shade700),
                    8.pw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'رد الدعم الفني:',
                            style: Styles.textStyle12Regular(context).copyWith(
                              color: Colors.amber.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          4.ph,
                          Text(
                            ticket.adminNotes!,
                            style: Styles.textStyle12Regular(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
