import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/payment/domain/entities/saved_card_entity.dart';
import 'package:shakshak/features/shared/payment/domain/entities/add_card_intent_entity.dart';

abstract class SavedCardsRepo {
  Future<Either<Failure, List<SavedCardEntity>>> getSavedCards();

  Future<Either<Failure, void>> payWithSavedCard({
    required int savedCardId,
    required double amount,
    required int orderId,
  });

  Future<Either<Failure, AddCardIntentEntity>> addCard();

  Future<Either<Failure, void>> deleteCard({required String cardId});

  Future<Either<Failure, void>> payWithSavedCardForWallet({
    required int savedCardId,
    required double amount,
  });

  Future<Either<Failure, AddCardIntentEntity>> chargeWalletWithNewCard({
    required double amount,
  });
}
