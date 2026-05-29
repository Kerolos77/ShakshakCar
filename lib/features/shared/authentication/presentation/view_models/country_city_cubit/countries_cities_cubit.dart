import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/country_entity.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/city_entity.dart';
import 'package:shakshak/features/shared/authentication/domain/usecases/get_countries_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/usecases/get_cities_usecase.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';

part 'countries_cities_state.dart';

class CountriesCitiesCubit extends Cubit<CountriesCitiesState> {
  CountriesCitiesCubit({
    required this.getCountriesUseCase,
    required this.getCitiesUseCase,
  }) : super(CountryCityInitial());

  final GetCountriesUseCase getCountriesUseCase;
  final GetCitiesUseCase getCitiesUseCase;

  int? selectedCountryId;
  int? selectedCityId;
  int? selectedCitiesDistricts;

  Future<void> getCountries() async {
    emit(CountryLoading());
    var result = await getCountriesUseCase(const NoParameters());
    result.fold((error) {
      debugPrint("error while get countries data ${error.message}");
      return emit(CountryFailure(errorMessage: error.message));
    }, (success) {
      return emit(CountrySuccess(countriesModel: success));
    });
  }

  Future<void> getCities({required int countryId}) async {
    emit(CitiesLoading());
    var result = await getCitiesUseCase(GetCitiesParams(countryId: countryId));
    result.fold((error) {
      debugPrint("error while get cities data ${error.message}");
      return emit(CitiesFailure(errorMessage: error.message));
    }, (success) {
      return emit(CitiesSuccess(citiesModel: success));
    });
  }
}
