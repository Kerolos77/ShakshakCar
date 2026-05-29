import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/driver/online_registration/domain/entities/car_brand_entity.dart';
import 'package:shakshak/features/driver/online_registration/domain/repositories/driver_registration_repo.dart';

class GetCarBrandsUseCase
    extends BaseUseCase<List<CarBrandEntity>, NoParameters> {
  final DriverRegistrationRepo driverRegistrationRepo;

  GetCarBrandsUseCase(this.driverRegistrationRepo);

  @override
  Future<Either<Failure, List<CarBrandEntity>>> call(
      NoParameters parameters) async {
    return await driverRegistrationRepo.getCarBrands();
  }
}
