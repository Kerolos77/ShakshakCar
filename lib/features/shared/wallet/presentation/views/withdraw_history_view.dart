import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';

import 'package:shakshak/features/shared/wallet/domain/usecases/get_wallet_transactions_usecase.dart';
import 'package:shakshak/features/shared/wallet/domain/usecases/charge_wallet_usecase.dart';
import 'package:shakshak/features/shared/wallet/domain/usecases/withdraw_request_usecase.dart';
import 'package:shakshak/features/shared/wallet/presentation/view_models/wallet_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/wallet/data/models/wallet_transactions_model.dart';
import 'package:shakshak/features/shared/wallet/presentation/widgets/wallet_transaction_item.dart';

class WithdrawHistoryView extends StatelessWidget {
  const WithdrawHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletCubit(
        sl<GetWalletTransactionsUseCase>(),
        sl<ChargeWalletUseCase>(),
        sl<WithdrawRequestUseCase>(),
      )..getWalletTransactions(),
      child: BaseLayoutView(
        title: S.of(context).withdrawRequests,
        horizontalPadding: 0,
        body: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            if (state is WalletTransactionsSuccess) {
              final withdrawals = state.walletTransactionsResponseEntity.data
                      ?.where((e) => e.type != 'deposit')
                      .toList() ??
                  [];
              return withdrawals.isNotEmpty
                  ? ListView.separated(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      itemBuilder: (context, index) => WalletTransactionItem(
                        walletTransactionData: withdrawals[index],
                      ),
                      separatorBuilder: (context, index) => 16.ph,
                      itemCount: withdrawals.length,
                    )
                  : Center(
                      child: Text(
                        S.of(context).noData,
                        style: Styles.textStyle16Medium(context),
                      ),
                    );
            } else if (state is WalletTransactionsLoading) {
              return Skeletonizer(
                child: ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  itemBuilder: (context, index) => WalletTransactionItem(
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
                      type: "withdraw",
                    ),
                  ),
                  separatorBuilder: (context, index) => 16.ph,
                  itemCount: 6,
                ),
              );
            } else if (state is WalletTransactionsFailure) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: Styles.textStyle16Medium(context),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
