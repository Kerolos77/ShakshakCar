import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/driver/home/data/models/demand_map_model.dart';
import 'package:shakshak/features/driver/home/domain/repositories/driver_home_repo.dart';

class GetDemandMapUseCase extends BaseUseCase<DemandMapModel, NoParameters> {
  final DriverHomeRepo repository;

  GetDemandMapUseCase(this.repository);

  @override
  Future<Either<Failure, DemandMapModel>> call(NoParameters parameters) async {
    return await repository.getDemandMap();
  }
}
