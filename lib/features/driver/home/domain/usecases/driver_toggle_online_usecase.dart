import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/driver/home/domain/entities/driver_toggle_online_entity.dart';
import 'package:shakshak/features/driver/home/domain/repositories/driver_home_repo.dart';

class DriverToggleOnlineUseCase
    extends BaseUseCase<DriverToggleOnlineEntity, DriverToggleOnlineParams> {
  final DriverHomeRepo driverHomeRepo;

  DriverToggleOnlineUseCase(this.driverHomeRepo);

  @override
  Future<Either<Failure, DriverToggleOnlineEntity>> call(
      DriverToggleOnlineParams parameters) async {
    return await driverHomeRepo.driverToggleOnline(value: parameters.value);
  }
}

class DriverToggleOnlineParams {
  final int value;

  const DriverToggleOnlineParams({required this.value});
}
