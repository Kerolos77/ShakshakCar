import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/entities/services_entity.dart';
import 'package:shakshak/features/user/user_home/domain/repositories/user_home_repo.dart';

class GetInCityServicesUseCase
    extends BaseUseCase<ServicesEntity, NoParameters> {
  final UserHomeRepo userHomeRepo;

  GetInCityServicesUseCase(this.userHomeRepo);

  @override
  Future<Either<Failure, ServicesEntity>> call(NoParameters parameters) async {
    return await userHomeRepo.getInCityServices();
  }
}
