import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/driver/earnings/data/models/earnings_summary_model.dart';
import 'package:shakshak/features/driver/earnings/data/models/earnings_trip_model.dart';
import 'package:shakshak/features/driver/earnings/presentation/manager/earnings_cubit.dart';
import 'package:shakshak/features/driver/earnings/presentation/manager/earnings_state.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/generated/l10n.dart';

class EarningsView extends StatelessWidget {
  const EarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EarningsCubit>()..fetchEarnings(),
      child: BaseLayoutView(
        title: S.of(context).earnings,
        body: BlocBuilder<EarningsCubit, EarningsState>(
          builder: (context, state) {
            if (state is EarningsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EarningsError) {
              return Center(child: Text(state.errMessage));
            } else if (state is EarningsSuccess) {
              return _buildContent(context, state.summary, state.history);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, EarningsSummaryModel summary,
      List<EarningsTripModel> history) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPeriodSelector(context),
          16.ph,
          _buildMainEarningsCard(context, summary),
          24.ph,
          _buildDetailedStats(context, summary),
          24.ph,
          Text(
            S.of(context).performance,
            style: Styles.textStyle18SemiBold(context),
          ),
          12.ph,
          _buildChart(context, summary.chartData),
          24.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).recentEarnings,
                style: Styles.textStyle18SemiBold(context),
              ),
              Text(
                '(${summary.completedTripsCount} ${S.of(context).trips})',
                style: Styles.textStyle14(context).copyWith(color: Colors.grey),
              ),
            ],
          ),
          12.ph,
          _buildHistoryList(context, history),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    final cubit = context.read<EarningsCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPeriodChip(context, 'today', S.of(context).today, cubit),
        8.pw,
        _buildPeriodChip(context, 'week', S.of(context).thisWeek, cubit),
        8.pw,
        _buildPeriodChip(context, 'month', S.of(context).thisMonth, cubit),
      ],
    );
  }

  Widget _buildPeriodChip(
      BuildContext context, String value, String label, EarningsCubit cubit) {
    bool isSelected = cubit.currentPeriod == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) cubit.fetchEarnings(period: value);
      },
      selectedColor: AppColors.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontSize: 12.sp,
      ),
    );
  }

  Widget _buildMainEarningsCard(
      BuildContext context, EarningsSummaryModel summary) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryColor, Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            S.of(context).netEarnings,
            style: Styles.textStyle14(context).copyWith(color: Colors.white70),
          ),
          4.ph,
          Text(
            '${summary.netEarnings.toStringAsFixed(2)} ${S.of(context).currency}',
            style:
                Styles.textStyle32Bold(context).copyWith(color: Colors.white),
          ),
          16.ph,
          const Divider(color: Colors.white24),
          16.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSmallStat(context, S.of(context).grossEarnings,
                  summary.grossEarnings.toStringAsFixed(2)),
              Container(width: 1, height: 30, color: Colors.white24),
              _buildSmallStat(context, S.of(context).commission,
                  summary.totalCommission.toStringAsFixed(2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Styles.textStyle16Bold(context).copyWith(color: Colors.white),
        ),
        Text(
          label,
          style: Styles.textStyle12(context).copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildDetailedStats(
      BuildContext context, EarningsSummaryModel summary) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoBox(
            context,
            title: S.of(context).cashCollected,
            value: summary.cashCollected,
            color: Colors.blue,
            icon: Icons.money,
          ),
        ),
        12.pw,
        Expanded(
          child: _buildInfoBox(
            context,
            title: S.of(context).digitalEarnings,
            value: summary.digitalEarnings,
            color: Colors.green,
            icon: Icons.account_balance_wallet,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox(BuildContext context,
      {required String title,
      required double value,
      required Color color,
      required IconData icon}) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          12.ph,
          Text(
            title,
            style:
                Styles.textStyle12(context).copyWith(color: Colors.grey[600]),
          ),
          4.ph,
          Text(
            '${value.toStringAsFixed(2)}',
            style: Styles.textStyle18Bold(context).copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<ChartDataModel> data) {
    if (data.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Text(S.of(context).noData),
        ),
      );
    }

    return Container(
      height: 200.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: data.map((e) => e.net).reduce((a, b) => a > b ? a : b) * 1.2,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < 0 || index >= data.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      data[index].date.split('-').last,
                      style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: data.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.net,
                  color: AppColors.primaryColor,
                  width: 12.w,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context, List<EarningsTripModel> history) {
    if (history.isEmpty) {
      return Center(child: Text(S.of(context).noTripsYet));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length,
      separatorBuilder: (context, index) => 12.ph,
      itemBuilder: (context, index) {
        final item = history[index];
        bool isCash = item.paymentBreakdown.paymentType == 'cash';
        
        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.grey[100]!),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: (isCash ? Colors.blue : Colors.green).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCash ? Icons.money : Icons.account_balance_wallet,
                  color: isCash ? Colors.blue : Colors.green,
                  size: 20.sp,
                ),
              ),
              12.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.userName,
                      style: Styles.textStyle14Bold(context),
                    ),
                    Text(
                      '${item.serviceTitle} • ${item.completedAt}',
                      style: Styles.textStyle12(context).copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+${item.netEarnings.toStringAsFixed(2)}',
                    style: Styles.textStyle16Bold(context).copyWith(color: Colors.green),
                  ),
                  Text(
                    '${S.of(context).commission}: ${item.commission}',
                    style: Styles.textStyle10(context).copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
