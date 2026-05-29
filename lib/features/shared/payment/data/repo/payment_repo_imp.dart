import 'package:dartz/dartz.dart';

import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/payment/data/models/card_model.dart';
import 'package:shakshak/features/shared/payment/domain/repositories/payment_repo.dart';
import 'package:shakshak/features/shared/payment/domain/entities/card_entity.dart';

class PaymentRepoImp implements PaymentRepo {
  // TODO: Inject DioHelper/DataSource here

  @override
  Future<Either<Failure, List<CardEntity>>> getSavedCards() async {
    try {
      return right([
        CardModel(
            id: '1',
            cardNumber: '**** **** **** 1234',
            holderName: 'John Doe',
            type: 'visa'),
        CardModel(
            id: '2',
            cardNumber: '**** **** **** 5678',
            holderName: 'John Doe',
            type: 'mastercard'),
      ]);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CardEntity>> addNewCard(
      {required CardEntity card}) async {
    try {
      return right(card);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
