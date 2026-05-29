import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/entities/saved_card_entity.dart';
import 'package:shakshak/features/shared/payment/domain/repositories/saved_cards_repo.dart';

class FetchSavedCardsUseCase
    extends BaseUseCase<List<SavedCardEntity>, NoParameters> {
  final SavedCardsRepo repo;

  FetchSavedCardsUseCase(this.repo);

  @override
  Future<Either<Failure, List<SavedCardEntity>>> call(
      NoParameters parameters) async {
    return await repo.getSavedCards();
  }
}

class PayWithSavedCardUseCase
    extends BaseUseCase<void, PayWithSavedCardParams> {
  final SavedCardsRepo repo;

  PayWithSavedCardUseCase(this.repo);

  @override
  Future<Either<Failure, void>> call(PayWithSavedCardParams parameters) async {
    return await repo.payWithSavedCard(
      savedCardId: parameters.savedCardId,
      amount: parameters.amount,
      orderId: parameters.orderId,
    );
  }
}

class PayWithSavedCardParams {
  final int savedCardId;
  final double amount;
  final int orderId;

  PayWithSavedCardParams({
    required this.savedCardId,
    required this.amount,
    required this.orderId,
  });
}
