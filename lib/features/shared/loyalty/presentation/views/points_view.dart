import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/loyalty/presentation/view_models/loyalty_cubit.dart';
import 'package:shakshak/features/shared/loyalty/presentation/view_models/loyalty_state.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/features/shared/shop/presentation/view_models/shop_cubit.dart';
import 'package:shakshak/features/shared/shop/presentation/view_models/shop_state.dart';
import 'package:shakshak/features/shared/shop/presentation/widgets/subscription_countdown_timer.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';

class PointsView extends StatelessWidget {
  const PointsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit(
            getPackagesUseCase: sl(),
            buyPackageUseCase: sl(),
            getSubscriptionStatusUseCase: sl(),
          )..getSubscriptionStatus(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(S.of(context).pointsHistory, style: Styles.textStyle18Bold(context)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
      body: BlocBuilder<LoyaltyCubit, LoyaltyState>(
        builder: (context, state) {
          if (state is LoyaltyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoyaltyError) {
            return Center(child: Text(state.message));
          } else if (state is LoyaltySuccess) {
            final response = state.response;
            return Column(
              children: [
                _buildPointsHeader(context, response.currentPoints),
                BlocBuilder<ShopCubit, ShopState>(
                  builder: (context, state) {
                    if (state is ShopLoaded && state.subscriptionDetails != null) {
                      return _buildSubscriptionStatus(context, state.subscriptionDetails!);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                Expanded(
                  child: response.transactions.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: response.transactions.length,
                          separatorBuilder: (context, index) => const Divider(height: 24),
                          itemBuilder: (context, index) {
                            final transaction = response.transactions[index];
                            return _buildTransactionItem(context, transaction);
                          },
                        ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    ),
  );
}

  Widget _buildPointsHeader(BuildContext context, int points) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade700, Colors.orange.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.stars, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          Text(
            S.of(context).pointsSuffix(points),
            style: Styles.textStyle30Bold(context).copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            "رصيدك الحالي من النقاط",
            style: Styles.textStyle14(context).copyWith(color: Colors.white.withOpacity(0.9)),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final isDriver = CacheHelper.getData(key: AppConstant.kIsDriver) == 1;
              navigateTo(context, isDriver ? Routes.driverStoreView : Routes.userStoreView);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: const Text("متجر الباقات", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, dynamic transaction) {
    final bool isPositive = transaction.amount > 0;
    final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(transaction.createdAt);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isPositive ? Colors.green.shade50 : Colors.red.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isPositive ? Icons.add_circle_outline : Icons.remove_circle_outline,
            color: isPositive ? Colors.green : Colors.red,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.description,
                style: Styles.textStyle16SemiBold(context),
              ),
              const SizedBox(height: 4),
              Text(
                dateStr,
                style: Styles.textStyle12(context).copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        Text(
          "${isPositive ? '+' : ''}${transaction.amount}",
          style: Styles.textStyle18Bold(context).copyWith(
            color: isPositive ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "لا يوجد سجل نقاط حتى الآن",
            style: Styles.textStyle16(context).copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
  Widget _buildSubscriptionStatus(BuildContext context, dynamic subscription) {
    final expiresAt = DateTime.tryParse(subscription.expiresAt);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.workspace_premium_rounded, color: Colors.blue.shade700, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "الباقة النشطة: ${subscription.package.name}",
                  style: Styles.textStyle14Bold(context).copyWith(color: Colors.blue.shade900),
                ),
                if (expiresAt != null) ...[
                  const SizedBox(height: 4),
                  SubscriptionCountdownTimer(
                    expiresAt: expiresAt,
                    showLabel: true,
                    textStyle: Styles.textStyle12SemiBold(context).copyWith(color: Colors.blue.shade700),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
