import 'package:shakshak/features/shared/wallet/domain/entities/wallet_transaction_entity.dart';

class WalletTransactionsResponseEntity {
  final List<WalletTransactionEntity>? data;
  final String? msg;
  final int? status;
  final bool? statusval;

  WalletTransactionsResponseEntity({
    this.data,
    this.msg,
    this.status,
    this.statusval,
  });
}
