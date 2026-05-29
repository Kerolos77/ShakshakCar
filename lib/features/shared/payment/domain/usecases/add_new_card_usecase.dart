import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/entities/card_entity.dart';
import 'package:shakshak/features/shared/payment/domain/repositories/payment_repo.dart';

class AddNewCardUseCase extends BaseUseCase<CardEntity, CardEntity> {
  final PaymentRepo paymentRepo;

  AddNewCardUseCase(this.paymentRepo);

  @override
  Future<Either<Failure, CardEntity>> call(CardEntity parameters) async {
    return await paymentRepo.addNewCard(card: parameters);
  }
}
