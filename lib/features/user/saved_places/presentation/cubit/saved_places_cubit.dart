import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/user/saved_places/domain/entities/saved_place_entity.dart';
import 'package:shakshak/features/user/saved_places/domain/usecases/add_saved_place_usecase.dart';
import 'package:shakshak/features/user/saved_places/domain/usecases/get_saved_places_usecase.dart';
import 'package:shakshak/features/user/saved_places/domain/usecases/get_suggested_place_usecase.dart';
import 'package:shakshak/features/user/saved_places/domain/usecases/remove_saved_place_usecase.dart';
import 'package:shakshak/features/user/saved_places/domain/usecases/update_saved_place_usecase.dart';

abstract class SavedPlacesState {}

class SavedPlacesInitial extends SavedPlacesState {}

class SavedPlacesLoading extends SavedPlacesState {}

class SavedPlacesSuccess extends SavedPlacesState {
  final List<SavedPlaceEntity> places;
  final List<SavedPlaceEntity> suggestedPlaces;
  SavedPlacesSuccess(this.places, {this.suggestedPlaces = const []});
}

class SavedPlacesFailure extends SavedPlacesState {
  final String errorMessage;
  SavedPlacesFailure(this.errorMessage);
}

class SavedPlacesCubit extends Cubit<SavedPlacesState> {
  final GetSavedPlacesUseCase getSavedPlacesUseCase;
  final AddSavedPlaceUseCase addSavedPlaceUseCase;
  final RemoveSavedPlaceUseCase removeSavedPlaceUseCase;
  final UpdateSavedPlaceUseCase updateSavedPlaceUseCase;
  final GetSuggestedPlaceUseCase getSuggestedPlaceUseCase;

  SavedPlacesCubit({
    required this.getSavedPlacesUseCase,
    required this.addSavedPlaceUseCase,
    required this.removeSavedPlaceUseCase,
    required this.updateSavedPlaceUseCase,
    required this.getSuggestedPlaceUseCase,
  }) : super(SavedPlacesInitial());

  Future<void> fetchSavedPlaces() async {
    emit(SavedPlacesLoading());

    final placesResult = await getSavedPlacesUseCase(const NoParameters());

    placesResult.fold(
      (failure) => emit(SavedPlacesFailure(failure.message)),
      (places) async {
        final sortedPlaces = _sortPlaces(List.from(places));

        List<SavedPlaceEntity> suggestions = [];
        final suggestionResult =
            await getSuggestedPlaceUseCase(const NoParameters());
        suggestionResult.fold(
          (l) => null, // Ignore failure for suggestions
          (s) => suggestions = s,
        );

        emit(SavedPlacesSuccess(sortedPlaces, suggestedPlaces: suggestions));
      },
    );
  }

  List<SavedPlaceEntity> _sortPlaces(List<SavedPlaceEntity> places) {
    // Put "Home" first if exists
    final homeIndex = places.indexWhere(
        (p) => p.name.toLowerCase().contains('home') || p.name.contains('بيت'));
    if (homeIndex != -1 && homeIndex != 0) {
      final home = places.removeAt(homeIndex);
      places.insert(0, home);
    }
    return places;
  }

  Future<void> addSavedPlace(SavedPlaceEntity place) async {
    final result = await addSavedPlaceUseCase(place);
    result.fold(
      (failure) => emit(SavedPlacesFailure(failure.message)),
      (_) => fetchSavedPlaces(),
    );
  }

  Future<void> removeSavedPlace(String id) async {
    final result = await removeSavedPlaceUseCase(id);
    result.fold(
      (failure) => emit(SavedPlacesFailure(failure.message)),
      (_) => fetchSavedPlaces(),
    );
  }

  Future<void> updateSavedPlace(SavedPlaceEntity place) async {
    final result = await updateSavedPlaceUseCase(UpdateSavedPlaceParams(place));
    result.fold(
      (failure) => emit(SavedPlacesFailure(failure.message)),
      (_) => fetchSavedPlaces(),
    );
  }
}
