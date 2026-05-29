import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/driver/home/domain/repositories/driver_home_repo.dart';

class SetDriverDestinationUseCase {
  final DriverHomeRepo _repository;

  SetDriverDestinationUseCase(this._repository);

  Future<Either<Failure, bool>> call({
    required bool isHeadingDestination,
    double? lat,
    double? lng,
    String? address,
  }) async {
    return await _repository.driverSetDestination(
      isHeadingDestination: isHeadingDestination,
      lat: lat,
      lng: lng,
      address: address,
    );
  }
}
