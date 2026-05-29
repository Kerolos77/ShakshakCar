import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/driver/new_rides/domain/repositories/new_ride_repo.dart';

class AcceptRideUseCase extends BaseUseCase<bool, AcceptRideParams> {
  final NewRideRepo newRideRepo;

  AcceptRideUseCase(this.newRideRepo);

  @override
  Future<Either<Failure, bool>> call(AcceptRideParams parameters) async {
    return await newRideRepo.acceptRide(parameters.orderId);
  }
}

class AcceptRideParams {
  final int orderId;

  const AcceptRideParams({required this.orderId});
}
