import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/repositories/user_home_repo.dart';

class GetNearbyDriversUseCase
    extends BaseUseCase<dynamic, GetNearbyDriversUseCaseParams> {
  final UserHomeRepo userHomeRepo;

  GetNearbyDriversUseCase(this.userHomeRepo);

  @override
  Future<Either<Failure, dynamic>> call(
      GetNearbyDriversUseCaseParams parameters) async {
    return await userHomeRepo.getNearbyDrivers(
      latitude: parameters.latitude,
      longitude: parameters.longitude,
    );
  }
}

class GetNearbyDriversUseCaseParams {
  final double latitude;
  final double longitude;

  GetNearbyDriversUseCaseParams(
      {required this.latitude, required this.longitude});
}
