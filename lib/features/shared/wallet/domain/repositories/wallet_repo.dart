import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/wallet/domain/entities/charge_wallet_entity.dart';
import 'package:shakshak/features/shared/wallet/domain/entities/wallet_transactions_response_entity.dart';

abstract class WalletRepo {
  Future<Either<Failure, WalletTransactionsResponseEntity>>
      getWalletTransactions();

  Future<Either<Failure, ChargeWalletEntity>> chargeWallet(
      {required double value});

  Future<Either<Failure, WalletTransactionsResponseEntity>> withdrawRequest({
    required double amount,
    String? note,
  });
}
