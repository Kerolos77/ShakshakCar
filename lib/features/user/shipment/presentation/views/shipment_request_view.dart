import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/core/utils/shared_widgets/select_location/select_destination_map_screen.dart';
import 'package:shakshak/features/user/shipment/presentation/view_models/shipment_cubit.dart';
import 'package:shakshak/features/user/shipment/presentation/view_models/shipment_state.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_states.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_state.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/select_destination_components/location_inputs_section.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/select_destination_components/place_suggestions_list.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_drop_down.dart';
import 'package:shakshak/generated/l10n.dart';

class ShipmentRequestView extends StatefulWidget {
  const ShipmentRequestView({super.key});

  @override
  State<ShipmentRequestView> createState() => _ShipmentRequestViewState();
}

class _ShipmentRequestViewState extends State<ShipmentRequestView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Global Keys for smooth scrolling
  final GlobalKey _nameKey = GlobalKey();
  final GlobalKey _phoneKey = GlobalKey();
  final GlobalKey _detailsKey = GlobalKey();
  final GlobalKey _weightKey = GlobalKey();
  final GlobalKey _imageKey = GlobalKey();
  final GlobalKey _termsKey = GlobalKey();

  // Focus Nodes for programmatic focusing
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  bool _isWeightError = false;
  bool _isImageError = false;
  bool _isTermsError = false;

  void _scrollToField(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = ShipmentCubit.get(context);
    final locationCubit = context.read<LocationCubit>();

    void updateMapLocation() {
      if (locationCubit.isSourceSelected &&
          locationCubit.sourcePlace != null &&
          locationCubit.sourcePlace!.lat != null) {
        locationCubit.changeLocation(
            LatLng(locationCubit.sourcePlace!.lat!, locationCubit.sourcePlace!.lng!));
      } else if (!locationCubit.isSourceSelected &&
          locationCubit.destinationPlace != null &&
          locationCubit.destinationPlace!.lat != null) {
        locationCubit.changeLocation(
            LatLng(locationCubit.destinationPlace!.lat!, locationCubit.destinationPlace!.lng!));
      }
    }

    void navigateToMap() {
      FocusScope.of(context).unfocus();
      updateMapLocation();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: locationCubit,
            child: const SelectDestinationMapScreen(),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).shipPackage),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ShipmentCubit, ShipmentState>(
            listener: (context, state) {
              if (state is ShipmentValidationError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ));
              }
            },
          ),
          BlocListener<UserHomeCubit, UserHomeState>(
            listener: (context, state) {
              if (state is NewRideRequestLoading) {
                // Show loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
              } else if (state is NewRideRequestSuccess) {
                Navigator.pop(context); // hide loading
                navigateAndFinish(
                  context,
                  Routes.offersView,
                  extra: OffersViewArgs(newRideData: state.newRideModel),
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(S.of(context).shipmentRequestSuccess),
                  backgroundColor: Colors.green,
                ));
              } else if (state is NewRideRequestFailure) {
                Navigator.pop(context); // hide loading
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ));
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocationInputsSection(cubit: locationCubit),
                  10.ph,
                  BlocBuilder<LocationCubit, LocationState>(
                    builder: (context, state) {
                      if (state is SuggestionsLoadedState &&
                          locationCubit.placePredictions.isNotEmpty) {
                        return PlaceSuggestionsList(
                          suggestions: locationCubit.placePredictions,
                          savedPlaces: const [], // Could provide saved places if needed
                          onMapTap: navigateToMap,
                          onSuggestionTap: (place) {
                            FocusScope.of(context).unfocus();
                            locationCubit.selectPlace(
                              placeId: place.placeId,
                              isSource: locationCubit.isSourceSelected,
                            );
                          },
                          onSavedPlaceTap: (place) {
                            FocusScope.of(context).unfocus();
                            locationCubit.selectPlace(
                              lat: place.lat,
                              lng: place.lng,
                              isSource: locationCubit.isSourceSelected,
                            );
                          },
                        );
                      }
                      return InkWell(
                        onTap: navigateToMap,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Row(
                            children: [
                              Icon(Icons.add_location_alt,
                                  color: AppColors.primaryColor, size: 20.sp),
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
                        ),
                      );
                    },
                  ),
                  24.ph,
                  Text(
                    S.of(context).receiverName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  10.ph,
                  CustomTextField(
                    key: _nameKey,
                    focusNode: _nameFocusNode,
                    hint: S.of(context).receiverName,
                    controller: shipmentCubit.receiverNameController,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return S.of(context).receiverNameRequired;
                      }
                      return null;
                    },
                  ),
                  16.ph,
                  Text(
                    S.of(context).receiverPhone,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  10.ph,
                  CustomTextField(
                    key: _phoneKey,
                    focusNode: _phoneFocusNode,
                    hint: S.of(context).receiverPhone,
                    controller: shipmentCubit.receiverPhoneController,
                    keyType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return S.of(context).receiverPhoneRequired;
                      }
                      final RegExp phoneRegExp = RegExp(r'^01[0125][0-9]{8}$');
                      if (!phoneRegExp.hasMatch(val.trim())) {
                        return S.of(context).invalidPhone;
                      }
                      return null;
                    },
                  ),
                  16.ph,
                  Text(
                    S.of(context).packageType,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  10.ph,
                  BlocBuilder<ShipmentCubit, ShipmentState>(
                    key: _detailsKey,
                    builder: (context, state) {
                      final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
                      return CustomDropDown(
                        hint: S.of(context).packageDetailsRequired,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return S.of(context).packageDetailsRequired;
                          }
                          return null;
                        },
                        items: isArabic
                            ? ['طرد / كرتونة', 'مستندات / أوراق', 'ملابس', 'أجهزة إلكترونية', 'أطعمة / مأكولات', 'أخرى']
                            : ['Box / Parcel', 'Documents', 'Clothes', 'Electronics', 'Food', 'Other'],
                        value: shipmentCubit.packageDetailsController.text.isNotEmpty
                            ? shipmentCubit.packageDetailsController.text
                            : null,
                        onChange: (val) {
                          if (val != null) {
                            shipmentCubit.packageDetailsController.text = val;
                          }
                        },
                      );
                    },
                  ),
                  16.ph,
                  Text(
                    S.of(context).packageWeight,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  10.ph,
                  BlocBuilder<ShipmentCubit, ShipmentState>(
                    key: _weightKey,
                    builder: (context, state) {
                      final weights = [
                        {'value': 'light', 'label': S.of(context).weightLight, 'icon': Icons.card_giftcard},
                        {'value': 'medium', 'label': S.of(context).weightMedium, 'icon': Icons.local_shipping},
                        {'value': 'heavy', 'label': S.of(context).weightHeavy, 'icon': Icons.airport_shuttle},
                      ];
                      return Row(
                        children: weights.map((w) {
                          final isSelected = shipmentCubit.selectedWeight == w['value'];
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                shipmentCubit.setWeight(w['value'] as String);
                                setState(() {
                                  _isWeightError = false;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.primaryColor.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : (_isWeightError ? AppColors.redColor.withValues(alpha: 0.6) : AppColors.primaryColor.withValues(alpha: 0.15)),
                                    width: 1.0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      w['icon'] as IconData,
                                      color: isSelected ? Colors.white : AppColors.primaryColor,
                                      size: 24.sp,
                                    ),
                                    6.ph,
                                    Text(
                                      w['label'] as String,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  16.ph,
                  Text(
                    S.of(context).packageImageMandatory,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  10.ph,
                  BlocBuilder<ShipmentCubit, ShipmentState>(
                    key: _imageKey,
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: shipmentCubit.packageImage != null
                            ? null
                            : () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (_) => SafeArea(
                                    child: Wrap(
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: Text(S.of(context).camera),
                                          onTap: () {
                                            Navigator.pop(context);
                                            shipmentCubit.takePhoto().then((_) {
                                              if (shipmentCubit.packageImage != null) {
                                                setState(() {
                                                  _isImageError = false;
                                                });
                                              }
                                            });
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.photo_library),
                                          title: Text(S.of(context).gallery),
                                          onTap: () {
                                            Navigator.pop(context);
                                            shipmentCubit.pickImage().then((_) {
                                              if (shipmentCubit.packageImage != null) {
                                                setState(() {
                                                  _isImageError = false;
                                                });
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                        child: Container(
                          height: 120.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: _isImageError ? AppColors.redColor : AppColors.primaryColor.withValues(alpha: 0.3),
                              width: 1.0,
                            ),
                          ),
                          child: shipmentCubit.packageImage != null
                              ? Stack(
                                  children: [
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.r),
                                        child: Image.file(
                                          shipmentCubit.packageImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8.h,
                                      right: 8.w,
                                      child: GestureDetector(
                                        onTap: () {
                                          shipmentCubit.removeImage();
                                          setState(() {
                                            _isImageError = true;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(4.w),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 20.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo, color: AppColors.primaryColor, size: 40.sp),
                                    8.ph,
                                    Text(
                                      S.of(context).uploadPackageImage,
                                      style: TextStyle(color: AppColors.primaryColor),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
                  16.ph,
                  BlocBuilder<ShipmentCubit, ShipmentState>(
                    key: _termsKey,
                    builder: (context, state) {
                      return Row(
                        children: [
                          Checkbox(
                            value: shipmentCubit.acceptedTerms,
                            onChanged: (val) {
                              shipmentCubit.toggleTerms(val);
                              setState(() {
                                _isTermsError = !(val ?? false);
                              });
                            },
                            activeColor: AppColors.primaryColor,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                navigateTo(context, Routes.shipmentTermsView);
                              },
                              child: Text(
                                '${S.of(context).agreeToTerms}${S.of(context).termsLink}',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: _isTermsError ? AppColors.redColor : AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  24.ph,
                  CustomButton(
                    buttonColor: AppColors.primaryColor,
                    text: S.of(context).confirmShipmentRequest,
                    onTap: () {
                      final isFormValid = _formKey.currentState?.validate() ?? false;
                      final isWeightValid = shipmentCubit.selectedWeight != null;
                      final isImageValid = shipmentCubit.packageImage != null;
                      final isTermsValid = shipmentCubit.acceptedTerms;

                      setState(() {
                        _isWeightError = !isWeightValid;
                        _isImageError = !isImageValid;
                        _isTermsError = !isTermsValid;
                      });

                      if (isFormValid && isWeightValid && isImageValid && isTermsValid) {
                        shipmentCubit.submitShipmentRequest(context);
                        return;
                      }

                      // Focus and scroll to first invalid field chronologically
                      final nameVal = shipmentCubit.receiverNameController.text.trim();
                      if (nameVal.isEmpty) {
                        _scrollToField(_nameKey);
                        _nameFocusNode.requestFocus();
                        return;
                      }

                      final phoneVal = shipmentCubit.receiverPhoneController.text.trim();
                      final RegExp phoneRegExp = RegExp(r'^01[0125][0-9]{8}$');
                      if (phoneVal.isEmpty || !phoneRegExp.hasMatch(phoneVal)) {
                        _scrollToField(_phoneKey);
                        _phoneFocusNode.requestFocus();
                        return;
                      }

                      final detailsVal = shipmentCubit.packageDetailsController.text.trim();
                      if (detailsVal.isEmpty) {
                        _scrollToField(_detailsKey);
                        return;
                      }

                      if (!isWeightValid) {
                        _scrollToField(_weightKey);
                        return;
                      }

                      if (!isImageValid) {
                        _scrollToField(_imageKey);
                        return;
                      }

                      if (!isTermsValid) {
                        _scrollToField(_termsKey);
                        return;
                      }
                    },
                  ),
                  40.ph, // Bottom padding
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
