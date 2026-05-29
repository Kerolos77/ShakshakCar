import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/entities/card_entity.dart';
import 'package:shakshak/features/shared/payment/domain/repositories/payment_repo.dart';

class GetSavedCardsUseCase extends BaseUseCase<List<CardEntity>, NoParameters> {
  final PaymentRepo paymentRepo;

  GetSavedCardsUseCase(this.paymentRepo);

  @override
  Future<Either<Failure, List<CardEntity>>> call(
      NoParameters parameters) async {
    return await paymentRepo.getSavedCards();
  }
}
