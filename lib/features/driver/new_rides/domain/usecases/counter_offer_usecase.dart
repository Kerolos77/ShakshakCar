import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/driver/new_rides/domain/repositories/new_ride_repo.dart';

class CounterOfferUseCase extends BaseUseCase<bool, CounterOfferParams> {
  final NewRideRepo newRideRepo;

  CounterOfferUseCase(this.newRideRepo);

  @override
  Future<Either<Failure, bool>> call(CounterOfferParams parameters) async {
    return await newRideRepo.counterOffer(
        parameters.orderId, parameters.offerRate);
  }
}

class CounterOfferParams {
  final int orderId;
  final double offerRate;

  const CounterOfferParams({required this.orderId, required this.offerRate});
}
