import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_states.dart';
import 'select_destination_components/location_inputs_section.dart';
import 'select_destination_components/place_suggestions_list.dart';
import 'package:shakshak/features/user/saved_places/domain/entities/saved_place_entity.dart';
import 'package:shakshak/features/user/saved_places/presentation/cubit/saved_places_cubit.dart';
import 'package:shakshak/features/user/saved_places/presentation/widgets/saved_places_sheet.dart';
import 'title_with_close_button.dart';

class SelectDestinationWidget extends StatefulWidget {
  const SelectDestinationWidget({
    super.key,
    required this.changeMapTap,
  });

  final Function()? changeMapTap;

  @override
  State<SelectDestinationWidget> createState() =>
      _SelectDestinationWidgetState();
}

class _SelectDestinationWidgetState extends State<SelectDestinationWidget> {
  @override
  Widget build(BuildContext context) {
    LocationCubit cubit = LocationCubit.get(context);
    cubit.isConfirmedDestinations = false;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Column(
                children: [
                  TitleWithCloseButton(
                    title: S.of(context).selectAddress,
                    trailing: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => BlocProvider.value(
                            value: context.read<SavedPlacesCubit>(),
                            child: SavedPlacesSheet(
                              onPlaceSelected: (place) {
                                cubit.selectPlace(
                                  lat: place.lat,
                                  lng: place.lng,
                                  isSource: cubit.isSourceSelected,
                                );
                              },
                            ),
                          ),
                        );
                      },
                      icon: CircleAvatar(
                        backgroundColor:
                            AppColors.primaryColor.withOpacity(0.1),
                        child: Icon(Icons.stars,
                            color: AppColors.primaryColor, size: 22.sp),
                      ),
                    ),
                  ),
                  20.ph,
                  LocationInputsSection(cubit: cubit),
                  10.ph,
                  BlocBuilder<LocationCubit, LocationState>(
                    builder: (context, state) {
                      cubit = context.read<LocationCubit>();
                      return BlocBuilder<SavedPlacesCubit, SavedPlacesState>(
                        builder: (context, savedState) {
                          List<SavedPlaceEntity> savedPlaces = [];
                          if (savedState is SavedPlacesSuccess) {
                            savedPlaces = savedState.places;
                          }

                          if ((state is SuggestionsLoadedState &&
                                  cubit.placePredictions.isNotEmpty) ||
                              savedPlaces.isNotEmpty) {
                            return PlaceSuggestionsList(
                              suggestions: state is SuggestionsLoadedState
                                  ? cubit.placePredictions
                                  : [],
                              savedPlaces: savedPlaces,
                              onMapTap: () {
                                FocusScope.of(context).unfocus();
                                _updateMapLocation(cubit);
                                widget.changeMapTap?.call();
                              },
                              onSuggestionTap: (place) {
                                FocusScope.of(context).unfocus();
                                cubit.selectPlace(
                                  placeId: place.placeId,
                                  isSource: cubit.isSourceSelected,
                                );
                              },
                              onSavedPlaceTap: (place) {
                                FocusScope.of(context).unfocus();
                                cubit.selectPlace(
                                  lat: place.lat,
                                  lng: place.lng,
                                  isSource: cubit.isSourceSelected,
                                );
                              },
                            );
                          }
                          return InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _updateMapLocation(cubit);
                              widget.changeMapTap?.call();
                            },
                            child: Row(
                              children: [
                                Icon(Icons.add_location_alt,
                                    color: AppColors.primaryColor),
                                10.pw,
                                Expanded(
                                  child: Text(
                                    S.of(context).chooseOnMap,
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(12.r),
          child: CustomButton(
            buttonColor: AppColors.primaryColor,
            onTap: () {
              if (cubit.sourcePlace != null && cubit.destinationPlace != null) {
                double distance = cubit.calculateDistanceKm(
                  cubit.sourcePlace!.lat!,
                  cubit.sourcePlace!.lng!,
                  cubit.destinationPlace!.lat!,
                  cubit.destinationPlace!.lng!,
                );

                if (distance > 100) {
                  _showDistanceWarningDialog(context, cubit);
                } else {
                  cubit.confirmDestinations();
                  navigateTo(context, Routes.bookRide);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(S.of(context).pleaseSelectRide),
                ));
              }
            },
            text: S.of(context).confirmDestination,
          ),
        ),
      ),
    );
  }

  void _updateMapLocation(LocationCubit cubit) {
    if (cubit.isSourceSelected &&
        cubit.sourcePlace != null &&
        cubit.sourcePlace!.lat != null) {
      cubit.changeLocation(
          LatLng(cubit.sourcePlace!.lat!, cubit.sourcePlace!.lng!));
    } else if (!cubit.isSourceSelected &&
        cubit.destinationPlace != null &&
        cubit.destinationPlace!.lat != null) {
      cubit.changeLocation(
          LatLng(cubit.destinationPlace!.lat!, cubit.destinationPlace!.lng!));
    }
  }

  void _showDistanceWarningDialog(BuildContext context, LocationCubit cubit) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Theme.of(context).dividerColor.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.primaryColor,
                      size: 32.sp,
                    ),
                  ),
                  16.ph,
                  Text(
                    S.of(context).warning,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  12.ph,
                  Text(
                    S.of(context).longDistanceMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.darkGreyColor,
                    ),
                  ),
                  24.ph,
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: S.of(context).cancel,
                          buttonColor: Colors.white,
                          textColor: AppColors.primaryColor,
                          borderColor: AppColors.primaryColor,
                          onTap: () => Navigator.pop(context),
                          height: 48,
                        ),
                      ),
                      16.pw,
                      Expanded(
                        child: CustomButton(
                          text: S.of(context).confirm,
                          buttonColor: AppColors.primaryColor,
                          textColor: Colors.white,
                          onTap: () {
                            Navigator.pop(context);
                            cubit.confirmDestinations();
                            navigateTo(context, Routes.bookRide);
                          },
                          height: 48,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim, secondaryAnim, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutBack,
          ),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}
