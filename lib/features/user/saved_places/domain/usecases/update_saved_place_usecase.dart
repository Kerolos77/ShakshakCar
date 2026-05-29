import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/user/saved_places/domain/entities/saved_place_entity.dart';
import 'package:shakshak/features/user/saved_places/domain/repositories/saved_places_repo.dart';

class UpdateSavedPlaceUseCase extends BaseUseCase<void, UpdateSavedPlaceParams> {
  final SavedPlacesRepo repository;

  UpdateSavedPlaceUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateSavedPlaceParams parameters) async {
    return await repository.updateSavedPlace(parameters.place);
  }
}

class UpdateSavedPlaceParams {
  final SavedPlaceEntity place;

  UpdateSavedPlaceParams(this.place);
}
