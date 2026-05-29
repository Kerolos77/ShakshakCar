import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/user/saved_places/domain/repositories/saved_places_repo.dart';

class RemoveSavedPlaceUseCase implements BaseUseCase<void, String> {
  final SavedPlacesRepo repository;

  RemoveSavedPlaceUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String parameters) async {
    return await repository.removeSavedPlace(parameters);
  }
}
