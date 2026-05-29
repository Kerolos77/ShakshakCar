import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/entities/price_entity.dart';
import 'package:shakshak/features/user/user_home/domain/repositories/user_home_repo.dart';

class GetPriceUseCase extends BaseUseCase<PriceEntity, GetPriceUseCaseParams> {
  final UserHomeRepo userHomeRepo;

  GetPriceUseCase(this.userHomeRepo);

  @override
  Future<Either<Failure, PriceEntity>> call(
      GetPriceUseCaseParams parameters) async {
    return await userHomeRepo.getPrice(
      serviceId: parameters.serviceId,
      origin: parameters.origin,
      destination: parameters.destination,
    );
  }
}

class GetPriceUseCaseParams {
  final int serviceId;
  final String origin;
  final String destination;

  GetPriceUseCaseParams({
    required this.serviceId,
    required this.origin,
    required this.destination,
  });
}
