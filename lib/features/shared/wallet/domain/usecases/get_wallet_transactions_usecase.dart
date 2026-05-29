import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/wallet/domain/entities/wallet_transactions_response_entity.dart';
import 'package:shakshak/features/shared/wallet/domain/repositories/wallet_repo.dart';

class GetWalletTransactionsUseCase
    extends BaseUseCase<WalletTransactionsResponseEntity, NoParameters> {
  final WalletRepo walletRepo;

  GetWalletTransactionsUseCase(this.walletRepo);

  @override
  Future<Either<Failure, WalletTransactionsResponseEntity>> call(
      NoParameters parameters) async {
    return await walletRepo.getWalletTransactions();
  }
}
