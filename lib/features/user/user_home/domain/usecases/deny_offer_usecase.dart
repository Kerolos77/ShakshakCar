import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/entities/accept_offer_entity.dart';
import 'package:shakshak/features/user/user_home/domain/repositories/user_home_repo.dart';

class DenyOfferUseCase
    extends BaseUseCase<AcceptOfferEntity, DenyOfferUseCaseParams> {
  final UserHomeRepo userHomeRepo;

  DenyOfferUseCase(this.userHomeRepo);

  @override
  Future<Either<Failure, AcceptOfferEntity>> call(
      DenyOfferUseCaseParams parameters) async {
    return await userHomeRepo.denyOffer(offerId: parameters.offerId);
  }
}

class DenyOfferUseCaseParams {
  final int offerId;

  DenyOfferUseCaseParams({required this.offerId});
}
