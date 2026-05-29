import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/wallet/domain/entities/charge_wallet_entity.dart';
import 'package:shakshak/features/shared/wallet/domain/repositories/wallet_repo.dart';

class ChargeWalletUseCase
    extends BaseUseCase<ChargeWalletEntity, ChargeWalletParams> {
  final WalletRepo walletRepo;

  ChargeWalletUseCase(this.walletRepo);

  @override
  Future<Either<Failure, ChargeWalletEntity>> call(
      ChargeWalletParams parameters) async {
    return await walletRepo.chargeWallet(value: parameters.value);
  }
}

class ChargeWalletParams {
  final double value;

  const ChargeWalletParams({required this.value});
}
