import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/user/saved_places/domain/entities/saved_place_entity.dart';
import 'package:shakshak/features/user/saved_places/domain/repositories/saved_places_repo.dart';

class GetSavedPlacesUseCase
    implements BaseUseCase<List<SavedPlaceEntity>, NoParameters> {
  final SavedPlacesRepo repository;

  GetSavedPlacesUseCase(this.repository);

  @override
  Future<Either<Failure, List<SavedPlaceEntity>>> call(
      NoParameters parameters) async {
    return await repository.getSavedPlaces();
  }
}
