import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/country_entity.dart';
import 'package:shakshak/features/shared/authentication/domain/repositories/auth_repo.dart';

class GetCountriesUseCase extends BaseUseCase<CountryEntity, NoParameters> {
  final AuthRepo authRepo;

  GetCountriesUseCase(this.authRepo);

  @override
  Future<Either<Failure, CountryEntity>> call(NoParameters parameters) async {
    return await authRepo.getCountries();
  }
}
