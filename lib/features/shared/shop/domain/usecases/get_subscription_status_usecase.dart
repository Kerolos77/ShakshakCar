import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/shop/data/models/subscription_status_model.dart';
import 'package:shakshak/features/shared/shop/domain/repositories/shop_repo.dart';

class GetSubscriptionStatusUseCase {
  final ShopRepo repository;

  GetSubscriptionStatusUseCase(this.repository);

  Future<Either<Failure, SubscriptionStatusModel>> call() async {
    return await repository.getSubscriptionStatus();
  }
}
