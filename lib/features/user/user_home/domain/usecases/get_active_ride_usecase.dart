import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';
import 'package:shakshak/features/user/user_home/domain/repositories/user_home_repo.dart';

class GetUserActiveRideUseCase implements BaseUseCase<NewRideDataEntity, NoParameters> {
  final UserHomeRepo repo;

  GetUserActiveRideUseCase(this.repo);

  @override
  Future<Either<Failure, NewRideDataEntity>> call(NoParameters parameters) async {
    return await repo.getActiveRide();
  }
}
