import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/user/saved_places/domain/entities/saved_place_entity.dart';

abstract class SavedPlacesRepo {
  Future<Either<Failure, List<SavedPlaceEntity>>> getSavedPlaces();
  Future<Either<Failure, void>> addSavedPlace(SavedPlaceEntity place);
  Future<Either<Failure, void>> removeSavedPlace(String id);
  Future<Either<Failure, List<SavedPlaceEntity>>> getSuggestedPlaces();
  Future<Either<Failure, void>> updateSavedPlace(SavedPlaceEntity place);
}
