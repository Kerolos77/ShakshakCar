import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/city_entity.dart';
import 'package:shakshak/features/shared/authentication/domain/repositories/auth_repo.dart';

class GetCitiesUseCase extends BaseUseCase<CityEntity, GetCitiesParams> {
  final AuthRepo authRepo;

  GetCitiesUseCase(this.authRepo);

  @override
  Future<Either<Failure, CityEntity>> call(GetCitiesParams parameters) async {
    return await authRepo.getCities(countryId: parameters.countryId);
  }
}

class GetCitiesParams {
  final int countryId;

  GetCitiesParams({required this.countryId});
}
