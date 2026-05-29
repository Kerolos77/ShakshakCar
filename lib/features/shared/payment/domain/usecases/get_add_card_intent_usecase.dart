import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/entities/add_card_intent_entity.dart';
import 'package:shakshak/features/shared/payment/domain/repositories/saved_cards_repo.dart';

class GetAddCardIntentUseCase
    extends BaseUseCase<AddCardIntentEntity, NoParameters> {
  final SavedCardsRepo repo;

  GetAddCardIntentUseCase(this.repo);

  @override
  Future<Either<Failure, AddCardIntentEntity>> call(
      NoParameters parameters) async {
    return await repo.addCard();
  }
}
