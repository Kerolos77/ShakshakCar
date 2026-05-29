import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/rides/domain/entities/rides_entity.dart';
import 'package:shakshak/features/shared/rides/domain/repositories/rides_repo.dart';

class GetSharedRidesUseCase
    extends BaseUseCase<RidesEntity, GetSharedRidesParams> {
  final RidesRepo ridesRepo;

  GetSharedRidesUseCase(this.ridesRepo);

  @override
  Future<Either<Failure, RidesEntity>> call(
      GetSharedRidesParams parameters) async {
    return await ridesRepo.getRides(
      inCity: parameters.inCity,
      isDriver: parameters.isDriver,
    );
  }
}

class GetSharedRidesParams {
  final int? inCity;
  final bool isDriver;

  const GetSharedRidesParams({this.inCity, this.isDriver = false});
}
