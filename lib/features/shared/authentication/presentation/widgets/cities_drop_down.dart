import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_drop_down.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/country_city_cubit/countries_cities_cubit.dart';
import 'package:shakshak/generated/assets.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../domain/entities/city_entity.dart';
import '../../domain/entities/country_entity.dart';

class CitiesDropDown extends StatefulWidget {
  final Function(int)? onCountrySelected;
  final Function(int)? onCitySelected;
  final Function(int)? onDistrictSelected;
  final int? initialCountryId;
  final int? initialCityId;
  final bool enabled;

  const CitiesDropDown({
    super.key,
    this.onCountrySelected,
    this.onCitySelected,
    this.onDistrictSelected,
    this.initialCountryId,
    this.initialCityId,
    this.enabled = true,
  });

  @override
  State<CitiesDropDown> createState() => _CitiesDropDownState();
}

class _CitiesDropDownState extends State<CitiesDropDown> {
  String? selectedCountryName;
  String? selectedCityName;
  List<CountryDataEntity> countries = [];
  List<CityDataEntity> cities = [];

  @override
  void initState() {
    super.initState();
    context.read<CountriesCitiesCubit>().getCountries();
  }

  @override
  void didUpdateWidget(covariant CitiesDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCountryId != oldWidget.initialCountryId ||
        widget.initialCityId != oldWidget.initialCityId) {
      _updateNamesFromIds();
    }
  }

  void _updateNamesFromIds() {
    final state = context.read<CountriesCitiesCubit>().state;

    if (state is CountrySuccess) {
      countries = state.countriesModel.data ?? [];
    }

    if (countries.isNotEmpty) {
      if (widget.initialCountryId != null) {
        final countryMatch =
            countries.where((c) => c.id == widget.initialCountryId);
        final country =
            countryMatch.isNotEmpty ? countryMatch.first : countries.first;
        selectedCountryName = country.name;

        if (context.read<CountriesCitiesCubit>().selectedCountryId !=
            country.id) {
          context.read<CountriesCitiesCubit>().selectedCountryId = country.id;
          context
              .read<CountriesCitiesCubit>()
              .getCities(countryId: country.id!);
        }
      }
    }

    if (state is CitiesSuccess) {
      cities = state.citiesModel.data ?? [];
    }

    if (cities.isNotEmpty) {
      if (widget.initialCityId != null) {
        final cityMatch = cities.where((c) => c.id == widget.initialCityId);
        if (cityMatch.isNotEmpty) {
          selectedCityName = cityMatch.first.name;
        } else {
          selectedCityName = cities.first.name;
        }
      }
    } else if (widget.initialCityId == null) {
      selectedCityName = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocConsumer<CountriesCitiesCubit, CountriesCitiesState>(
          buildWhen: (previous, current) =>
              current is CountryLoading ||
              current is CountrySuccess ||
              current is CountryFailure,
          listener: (context, state) {
            if (state is CountrySuccess) {
              _updateNamesFromIds();
              setState(() {}); // Force rebuild with new names
            }
          },
          builder: (context, state) {
            CountriesCitiesCubit cubit = context.read<CountriesCitiesCubit>();
            if (state is CountryLoading) {
              return Skeletonizer(
                child: CustomDropDown(
                  enabled: widget.enabled,
                  hint: S.of(context).selectCountry,
                  prefix: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: SvgPicture.asset(Assets.svgLocation),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).countryIsRequired;
                    }
                    return null;
                  },
                  items: const [],
                ),
              );
            } else if (state is CountrySuccess) {
              final countriesList = state.countriesModel.data ?? [];
              final List<String> countryNames = countriesList
                  .map((country) => country.name)
                  .where((name) => name != null)
                  .cast<String>()
                  .toList();
              countryNames.sort();

              return CustomDropDown(
                enabled: widget.enabled,
                hint: S.of(context).selectCountry,
                prefix: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: SvgPicture.asset(Assets.svgLocation),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).countryIsRequired;
                  }
                  return null;
                },
                items: countryNames,
                value: selectedCountryName,
                onChange: (countryName) {
                  setState(() {
                    selectedCountryName = countryName;
                  });
                  final selectedCountry = countriesList
                      .firstWhere((country) => country.name == countryName);
                  cubit.getCities(countryId: selectedCountry.id!);
                  cubit.selectedCountryId = selectedCountry.id;

                  // Call the country selection callback if provided
                  if (widget.onCountrySelected != null &&
                      selectedCountry.id != null) {
                    widget.onCountrySelected!(selectedCountry.id!);
                  }
                },
              );
            } else if (state is CitiesFailure) {
              return Text(state.errorMessage);
            } else {
              return const SizedBox();
            }
          },
        ),
        16.ph,
        BlocConsumer<CountriesCitiesCubit, CountriesCitiesState>(
          buildWhen: (previous, current) =>
              current is CitiesLoading ||
              current is CitiesSuccess ||
              current is CitiesFailure,
          listener: (context, state) {
            if (state is CitiesSuccess) {
              _updateNamesFromIds();
              setState(() {}); // Force rebuild with new names
            }
          },
          builder: (context, state) {
            CountriesCitiesCubit cubit = context.read<CountriesCitiesCubit>();
            if (state is CitiesLoading) {
              return Skeletonizer(
                child: CustomDropDown(
                  enabled: widget.enabled,
                  hint: S.of(context).selectCity,
                  prefix: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: SvgPicture.asset(Assets.svgLocation),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).cityIsRequired;
                    }
                    return null;
                  },
                  items: const [],
                ),
              );
            } else if (state is CitiesSuccess) {
              final citiesList = state.citiesModel.data ?? [];
              final List<String> cityNames = citiesList
                  .map((city) => city.name)
                  .where((name) => name != null)
                  .cast<String>()
                  .toList();

              return citiesList.isNotEmpty
                  ? CustomDropDown(
                      enabled: widget.enabled,
                      hint: S.of(context).selectCity,
                      prefix: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: SvgPicture.asset(Assets.svgLocation),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).cityIsRequired;
                        }
                        return null;
                      },
                      items: cityNames,
                      value: selectedCityName,
                      onChange: (cityName) {
                        setState(() {
                          selectedCityName = cityName;
                        });
                        final selectedCity = citiesList
                            .firstWhere((city) => city.name == cityName);
                        cubit.selectedCityId = selectedCity.id;

                        // Call the city selection callback if provided
                        if (widget.onCitySelected != null &&
                            selectedCity.id != null) {
                          widget.onCitySelected!(selectedCity.id!);
                        }
                      },
                    )
                  : SizedBox();
            } else if (state is CitiesFailure) {
              return Text(state.errorMessage);
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }
}
