import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/wallet/data/models/wallet_transactions_model.dart';
import 'package:shakshak/features/shared/wallet/presentation/view_models/wallet_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:shakshak/features/shared/wallet/presentation/widgets/wallet_transaction_item.dart';

class WalletTransactionsList extends StatefulWidget {
  const WalletTransactionsList({
    super.key,
  });

  @override
  State<WalletTransactionsList> createState() => _WalletTransactionsListState();
}

class _WalletTransactionsListState extends State<WalletTransactionsList> {
  @override
  void initState() {
    super.initState();
    context.read<WalletCubit>().getWalletTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        if (state is WalletTransactionsSuccess) {
          final transactions =
              List<WalletTransactionData>.from(state.walletTransactionsResponseEntity.data ?? []);
          transactions.sort((a, b) {
            final aDate = DateTime.tryParse(a.createdAt ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bDate = DateTime.tryParse(b.createdAt ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bDate.compareTo(aDate); // Descending (newest first)
          });
          
          return transactions.isNotEmpty
              ? SliverPadding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: WalletTransactionItem(
                          walletTransactionData: transactions[index],
                        ),
                      ),
                      childCount: transactions.length,
                    ),
                  ),
                )
              : SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Text(
                        S.of(context).noData,
                        style: Styles.textStyle16Medium(context),
                      ),
                    ),
                  ),
                );
        } else if (state is WalletTransactionsLoading) {
          return SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Skeletonizer(
                    child: WalletTransactionItem(
                      walletTransactionData: WalletTransactionData(
                        id: 66,
                        paymentId: "341463213",
                        status: "pending",
                        success: 0,
                        amount: "110.0",
                        paymentMethod: "card",
                        paymentGateway: "paymob",
                        userID: 45,
                        createdAt: "2025-06-11T12:21:42.000000Z",
                        updatedAt: "2025-06-11T12:21:42.000000Z",
                        type: "deposit",
                        note: "aaaa",
                      ),
                    ),
                  ),
                ),
                childCount: 6,
              ),
            ),
          );
        } else if (state is WalletTransactionsFailure) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(
                state.errorMessage,
                style: Styles.textStyle16Medium(context),
              ),
            ),
          );
        } else {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
      },
    );
  }
}
