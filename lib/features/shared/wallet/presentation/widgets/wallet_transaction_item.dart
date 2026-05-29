import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';

import 'package:shakshak/core/utils/common_use.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/wallet/domain/entities/wallet_transaction_entity.dart';

class WalletTransactionItem extends StatelessWidget {
  const WalletTransactionItem({super.key, required this.walletTransactionData});

  final WalletTransactionEntity walletTransactionData;

  @override
  Widget build(BuildContext context) {
    final bool isCredit =
        walletTransactionData.type?.toLowerCase() == 'deposit' ||
            walletTransactionData.type?.toLowerCase() == 'credit';
    final Color amountColor =
        isCredit ? AppColors.secondaryColor : Colors.redAccent;
    final String sign = isCredit ? '+' : '-';

    return InkWell(
      onTap: () => _showTransactionDetails(context),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: amountColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getTransactionIcon(walletTransactionData.type),
                color: amountColor,
                size: 24.r,
              ),
            ),
            16.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTransactionTitle(context, walletTransactionData.type),
                    style: Styles.textStyle16SemiBold(context),
                  ),
                  4.ph,
                  Text(
                    formatCustomDate(walletTransactionData.createdAt ?? ''),
                    style: Styles.textStyle12(context).copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$sign${walletTransactionData.amount ?? 0} ${S.of(context).currency}',
                  style: Styles.textStyle16Bold(context).copyWith(
                    color: amountColor,
                  ),
                ),
                4.ph,
                _buildStatusBadge(context, walletTransactionData.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _TransactionDetailsSheet(data: walletTransactionData),
    );
  }

  IconData _getTransactionIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'deposit':
        return Icons.add_circle_outline;
      case 'withdrawal':
        return Icons.outbox_outlined;
      case 'payment':
        return Icons.payment_outlined;
      default:
        return Icons.swap_horiz_rounded;
    }
  }

  String _getTransactionTitle(BuildContext context, String? type) {
    switch (type?.toLowerCase()) {
      case 'deposit':
        return S.of(context).deposit;
      case 'withdrawal':
        return S.of(context).withdrawal;
      case 'payment':
        return 'Ride Payment';
      default:
        return type ?? 'Transaction';
    }
  }

  Widget _buildStatusBadge(BuildContext context, String? status) {
    Color color;
    switch (status?.toLowerCase()) {
      case 'success':
      case 'completed':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'failed':
      case 'canceled':
        color = Colors.red;
        break;
      default:
        color = Theme.of(context).disabledColor;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        status ?? '',
        style: Styles.textStyle10SemiBold(context).copyWith(color: color),
      ),
    );
  }
}

class _TransactionDetailsSheet extends StatelessWidget {
  const _TransactionDetailsSheet({required this.data});

  final WalletTransactionEntity data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          24.ph,
          Text(
            S.of(context).tripDetails,
            style: Styles.textStyle18Bold(context),
          ),
          24.ph,
          _buildDetailRow(context, S.of(context).transactionId,
              '#${data.paymentId ?? data.id}'),
          _buildDetailRow(context, S.of(context).date,
              formatCustomDate(data.createdAt ?? '')),
          _buildDetailRow(
              context, S.of(context).paidVia, data.paymentMethod ?? '-'),
          _buildDetailRow(context, S.of(context).status, data.status ?? '-'),
          if (data.note != null)
            _buildDetailRow(context, S.of(context).notes, data.note.toString()),
          const Divider(),
          16.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).totalPrice,
                style: Styles.textStyle18Bold(context),
              ),
              Text(
                '${data.amount} ${S.of(context).currency}',
                style: Styles.textStyle18Bold(context).copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          32.ph,
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: Styles.textStyle14Medium(context)
                  .copyWith(color: Theme.of(context).hintColor)),
          Text(value, style: Styles.textStyle14SemiBold(context)),
        ],
      ),
    );
  }
}
