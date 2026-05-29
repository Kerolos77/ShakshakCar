part of 'countries_cities_cubit.dart';

@immutable
sealed class CountriesCitiesState {}

final class CountryCityInitial extends CountriesCitiesState {}
// country states

final class CountryLoading extends CountriesCitiesState {}

final class CountrySuccess extends CountriesCitiesState {
  final CountryEntity countriesModel;

  CountrySuccess({required this.countriesModel});
}

final class CountryFailure extends CountriesCitiesState {
  final String errorMessage;

  CountryFailure({required this.errorMessage});
}

// city states

final class CitiesLoading extends CountriesCitiesState {}

final class CitiesSuccess extends CountriesCitiesState {
  final CityEntity citiesModel;

  CitiesSuccess({required this.citiesModel});
}

final class CitiesFailure extends CountriesCitiesState {
  final String errorMessage;

  CitiesFailure({required this.errorMessage});
}
