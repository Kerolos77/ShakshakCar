import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/rides/data/models/rides_model.dart';
import 'package:shakshak/features/user/user_home/domain/repositories/user_home_repo.dart';

class GetRidesUseCase extends BaseUseCase<RideModel, GetRidesUseCaseParams> {
  final UserHomeRepo userHomeRepo;

  GetRidesUseCase(this.userHomeRepo);

  @override
  Future<Either<Failure, RideModel>> call(
      GetRidesUseCaseParams parameters) async {
    return await userHomeRepo.getRides(inCity: parameters.inCity);
  }
}

class GetRidesUseCaseParams {
  final int inCity;
  GetRidesUseCaseParams({required this.inCity});
}
