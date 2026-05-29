import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/driver/new_rides/domain/repositories/new_ride_repo.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';

class FetchNewRidesUseCase
    extends BaseUseCase<List<NewRideData>, NoParameters> {
  final NewRideRepo newRideRepo;

  FetchNewRidesUseCase(this.newRideRepo);

  @override
  Future<Either<Failure, List<NewRideData>>> call(
      NoParameters parameters) async {
    return await newRideRepo.fetchNewRides();
  }
}
