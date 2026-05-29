import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/entities/accept_offer_entity.dart';
import 'package:shakshak/features/user/user_home/domain/repositories/user_home_repo.dart';

class CancelOrderUseCase
    extends BaseUseCase<AcceptOfferEntity, CancelOrderUseCaseParams> {
  final UserHomeRepo userHomeRepo;

  CancelOrderUseCase(this.userHomeRepo);

  @override
  Future<Either<Failure, AcceptOfferEntity>> call(
      CancelOrderUseCaseParams parameters) async {
    return await userHomeRepo.cancelOrder(orderId: parameters.orderId);
  }
}

class CancelOrderUseCaseParams {
  final int orderId;

  CancelOrderUseCaseParams({required this.orderId});
}
