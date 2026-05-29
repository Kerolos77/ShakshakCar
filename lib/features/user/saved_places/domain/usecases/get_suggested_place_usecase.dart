import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/rides/domain/repositories/rides_repo.dart';
import 'package:shakshak/features/user/saved_places/domain/entities/saved_place_entity.dart';
import 'package:shakshak/features/user/saved_places/domain/repositories/saved_places_repo.dart';

class GetSuggestedPlaceUseCase
    implements BaseUseCase<List<SavedPlaceEntity>, NoParameters> {
  final SavedPlacesRepo savedPlacesRepo;
  final RidesRepo? ridesRepo; // Kept for backwards compatibility in DI but unused

  GetSuggestedPlaceUseCase({required this.savedPlacesRepo, this.ridesRepo});

  @override
  Future<Either<Failure, List<SavedPlaceEntity>>> call(
      NoParameters parameters) async {
    return await savedPlacesRepo.getSuggestedPlaces();
  }
}
