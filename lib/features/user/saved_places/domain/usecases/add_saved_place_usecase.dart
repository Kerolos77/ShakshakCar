import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/user/saved_places/domain/entities/saved_place_entity.dart';
import 'package:shakshak/features/user/saved_places/domain/repositories/saved_places_repo.dart';

class AddSavedPlaceUseCase implements BaseUseCase<void, SavedPlaceEntity> {
  final SavedPlacesRepo repository;

  AddSavedPlaceUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SavedPlaceEntity parameters) async {
    return await repository.addSavedPlace(parameters);
  }
}
