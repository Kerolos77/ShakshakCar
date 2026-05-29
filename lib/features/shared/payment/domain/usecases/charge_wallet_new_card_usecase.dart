import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/entities/add_card_intent_entity.dart';
import 'package:shakshak/features/shared/payment/domain/repositories/saved_cards_repo.dart';

class ChargeWalletNewCardUseCase
    extends BaseUseCase<AddCardIntentEntity, ChargeWalletNewCardParams> {
  final SavedCardsRepo savedCardsRepo;

  ChargeWalletNewCardUseCase(this.savedCardsRepo);

  @override
  Future<Either<Failure, AddCardIntentEntity>> call(
      ChargeWalletNewCardParams parameters) async {
    return await savedCardsRepo.chargeWalletWithNewCard(
      amount: parameters.amount,
    );
  }
}

class ChargeWalletNewCardParams {
  final double amount;

  const ChargeWalletNewCardParams({
    required this.amount,
  });
}
