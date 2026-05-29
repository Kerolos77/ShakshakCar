import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_request_body_model.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';
import 'package:shakshak/features/user/user_home/domain/repositories/user_home_repo.dart';

class NewRideRequestUseCase
    extends BaseUseCase<NewRideDataEntity, NewRideRequestUseCaseParams> {
  final UserHomeRepo userHomeRepo;

  NewRideRequestUseCase(this.userHomeRepo);

  @override
  Future<Either<Failure, NewRideDataEntity>> call(
      NewRideRequestUseCaseParams parameters) async {
    return await userHomeRepo.newRideRequest(
        newRideRequestBodyModel: parameters.newRideRequestBodyModel);
  }
}

class NewRideRequestUseCaseParams {
  final NewRideRequestBodyModel newRideRequestBodyModel;

  NewRideRequestUseCaseParams({required this.newRideRequestBodyModel});
}
