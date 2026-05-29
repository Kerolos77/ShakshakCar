import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/entities/accept_offer_entity.dart';
import 'package:shakshak/features/user/user_home/domain/repositories/user_home_repo.dart';

class AcceptOfferUseCase
    extends BaseUseCase<AcceptOfferEntity, AcceptOfferUseCaseParams> {
  final UserHomeRepo userHomeRepo;

  AcceptOfferUseCase(this.userHomeRepo);

  @override
  Future<Either<Failure, AcceptOfferEntity>> call(
      AcceptOfferUseCaseParams parameters) async {
    return await userHomeRepo.acceptOffer(
      offerId: parameters.offerId,
      driverId: parameters.driverId,
    );
  }
}

class AcceptOfferUseCaseParams {
  final int offerId;
  final int driverId;

  AcceptOfferUseCaseParams({required this.offerId, required this.driverId});
}
