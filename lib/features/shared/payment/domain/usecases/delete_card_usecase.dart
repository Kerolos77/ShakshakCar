import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/repositories/saved_cards_repo.dart';

class DeleteCardUseCase extends BaseUseCase<void, String> {
  final SavedCardsRepo repo;

  DeleteCardUseCase(this.repo);

  @override
  Future<Either<Failure, void>> call(String parameters) async {
    return await repo.deleteCard(cardId: parameters);
  }
}
