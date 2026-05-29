import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/payment/domain/entities/card_entity.dart';

abstract class PaymentRepo {
  Future<Either<Failure, List<CardEntity>>> getSavedCards();
  Future<Either<Failure, CardEntity>> addNewCard({required CardEntity card});
}
