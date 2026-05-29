import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/repositories/saved_cards_repo.dart';

class PayWithSavedCardWalletUseCase
    extends BaseUseCase<void, PayWithSavedCardWalletParams> {
  final SavedCardsRepo savedCardsRepo;

  PayWithSavedCardWalletUseCase(this.savedCardsRepo);

  @override
  Future<Either<Failure, void>> call(
      PayWithSavedCardWalletParams parameters) async {
    return await savedCardsRepo.payWithSavedCardForWallet(
      savedCardId: parameters.savedCardId,
      amount: parameters.amount,
    );
  }
}

class PayWithSavedCardWalletParams {
  final int savedCardId;
  final double amount;

  const PayWithSavedCardWalletParams({
    required this.savedCardId,
    required this.amount,
  });
}
