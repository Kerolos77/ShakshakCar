import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/wallet/domain/entities/wallet_transactions_response_entity.dart';
import 'package:shakshak/features/shared/wallet/domain/repositories/wallet_repo.dart';

class WithdrawRequestUseCase extends BaseUseCase<
    WalletTransactionsResponseEntity, WithdrawRequestParams> {
  final WalletRepo walletRepo;

  WithdrawRequestUseCase(this.walletRepo);

  @override
  Future<Either<Failure, WalletTransactionsResponseEntity>> call(
      WithdrawRequestParams parameters) async {
    return await walletRepo.withdrawRequest(
        amount: parameters.amount, note: parameters.note);
  }
}

class WithdrawRequestParams {
  final double amount;
  final String? note;

  const WithdrawRequestParams({required this.amount, this.note});
}
