import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/driver/new_rides/domain/repositories/new_ride_repo.dart';

class RejectRideUseCase {
  final NewRideRepo _repository;

  RejectRideUseCase(this._repository);

  Future<Either<Failure, bool>> call(int orderId) async {
    return await _repository.rejectRide(orderId);
  }
}
