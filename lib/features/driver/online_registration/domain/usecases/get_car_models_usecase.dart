import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/driver/online_registration/domain/entities/car_model_entity.dart';
import 'package:shakshak/features/driver/online_registration/domain/repositories/driver_registration_repo.dart';

class GetCarModelsUseCase
    extends BaseUseCase<List<CarModelEntity>, GetCarModelsParams> {
  final DriverRegistrationRepo driverRegistrationRepo;

  GetCarModelsUseCase(this.driverRegistrationRepo);

  @override
  Future<Either<Failure, List<CarModelEntity>>> call(
      GetCarModelsParams parameters) async {
    return await driverRegistrationRepo.getCarModels(
        brandId: parameters.brandId);
  }
}

class GetCarModelsParams {
  final int brandId;

  GetCarModelsParams({required this.brandId});
}
