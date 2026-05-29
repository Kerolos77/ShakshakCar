import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/driver/new_rides/domain/entities/negotiation_settings_entity.dart';
import 'package:shakshak/features/driver/new_rides/domain/repositories/new_ride_repo.dart';

class FetchNegotiationSettingsUseCase
    extends BaseUseCase<NegotiationSettingsEntity, NoParameters> {
  final NewRideRepo newRideRepo;

  FetchNegotiationSettingsUseCase(this.newRideRepo);

  @override
  Future<Either<Failure, NegotiationSettingsEntity>> call(
      NoParameters parameters) async {
    return await newRideRepo.fetchNegotiationSettings();
  }
}
