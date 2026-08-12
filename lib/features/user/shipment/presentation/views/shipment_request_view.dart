import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_drop_down.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/core/utils/shared_widgets/select_location/select_destination_map_screen.dart';
import 'package:shakshak/features/user/shipment/presentation/view_models/shipment_cubit.dart';
import 'package:shakshak/features/user/shipment/presentation/view_models/shipment_state.dart';
import 'package:shakshak/features/user/shipment/presentation/widgets/receiver_otp_verification_dialog.dart';
import 'package:shakshak/features/user/shipment/presentation/widgets/shipment_active_trip_dialog.dart';
import 'package:shakshak/features/user/shipment/presentation/widgets/shipment_image_uploader.dart';
import 'package:shakshak/features/user/shipment/presentation/widgets/shipment_terms_checkbox.dart';
import 'package:shakshak/features/user/shipment/presentation/widgets/shipment_weight_selector.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_request_body_model.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_states.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_state.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/select_destination_components/location_inputs_section.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/select_destination_components/place_suggestions_list.dart';
import 'package:shakshak/generated/l10n.dart';

class ShipmentRequestView extends StatefulWidget {
  const ShipmentRequestView({super.key});

  @override
  State<ShipmentRequestView> createState() => _ShipmentRequestViewState();
}

class _ShipmentRequestViewState extends State<ShipmentRequestView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Global Keys for smooth scrolling to invalid fields
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

  @override
  void initState() {
    super.initState();
    context.read<UserHomeCubit>().getServices('shipping');
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _scrollToField(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final c = cos;
    final a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = ShipmentCubit.get(context);
    final locationCubit = context.read<LocationCubit>();

    void updateMapLocation() {
      if (locationCubit.isSourceSelected &&
          locationCubit.sourcePlace != null &&
          locationCubit.sourcePlace!.lat != null) {
        locationCubit.changeLocation(LatLng(
            locationCubit.sourcePlace!.lat!, locationCubit.sourcePlace!.lng!));
      } else if (!locationCubit.isSourceSelected &&
          locationCubit.destinationPlace != null &&
          locationCubit.destinationPlace!.lat != null) {
        locationCubit.changeLocation(LatLng(
            locationCubit.destinationPlace!.lat!,
            locationCubit.destinationPlace!.lng!));
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
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
              } else if (state is NewRideRequestSuccess) {
                Navigator.of(context, rootNavigator: true).pop(); // hide loading
                if (!state.newRideModel.isReceiverVerified) {
                  ReceiverOtpVerificationDialog.show(
                    context,
                    newRideData: state.newRideModel,
                    fallbackPhone: shipmentCubit.receiverPhoneController.text.trim(),
                  );
                } else {
                  navigateAndFinish(
                    context,
                    Routes.offersView,
                    extra: OffersViewArgs(newRideData: state.newRideModel),
                  );
                }
              } else if (state is NewRideRequestFailure) {
                Navigator.of(context, rootNavigator: true).pop(); // hide loading
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ));
                if (state.errorMessage.contains('توثيق') ||
                    state.errorMessage.contains('بطاقة') ||
                    state.errorMessage.toLowerCase().contains('identity') ||
                    state.errorMessage.toLowerCase().contains('verify')) {
                  navigateTo(context, Routes.userIdentityVerificationView);
                }
              } else if (state is NewRideRequestActiveTripFound) {
                Navigator.of(context, rootNavigator: true).pop(); // hide loading
                final msg = state.message == 'already_has_active_trip'
                    ? S.of(context).alreadyHasActiveTrip
                    : state.message;
                ShipmentActiveTripDialog.show(
                  context,
                  activeOrderId: state.activeOrderId,
                  message: msg,
                );
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
                  // 1. Location Inputs Section
                  LocationInputsSection(cubit: locationCubit),
                  10.ph,
                  BlocBuilder<LocationCubit, LocationState>(
                    builder: (context, state) {
                      if (state is SuggestionsLoadedState &&
                          locationCubit.placePredictions.isNotEmpty) {
                        return PlaceSuggestionsList(
                          suggestions: locationCubit.placePredictions,
                          savedPlaces: const [],
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

                  // 2. Receiver Name
                  Text(
                    S.of(context).receiverName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.sp),
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

                  // 3. Receiver Phone
                  Text(
                    S.of(context).receiverPhone,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.sp),
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

                  // 4. Package Type Dropdown
                  Text(
                    S.of(context).packageType,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  10.ph,
                  BlocBuilder<ShipmentCubit, ShipmentState>(
                    key: _detailsKey,
                    builder: (context, state) {
                      final bool isArabic =
                          Localizations.localeOf(context).languageCode == 'ar';
                      return CustomDropDown(
                        hint: S.of(context).packageDetailsRequired,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return S.of(context).packageDetailsRequired;
                          }
                          return null;
                        },
                        items: isArabic
                            ? [
                                'طرد / كرتونة',
                                'مستندات / أوراق',
                                'ملابس',
                                'أجهزة إلكترونية',
                                'أطعمة / مأكولات',
                                'أخرى'
                              ]
                            : [
                                'Box / Parcel',
                                'Documents',
                                'Clothes',
                                'Electronics',
                                'Food',
                                'Other'
                              ],
                        value: shipmentCubit
                                .packageDetailsController.text.isNotEmpty
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

                  // 5. Package Weight Selector Widget
                  Text(
                    S.of(context).packageWeight,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  10.ph,
                  BlocBuilder<ShipmentCubit, ShipmentState>(
                    key: _weightKey,
                    builder: (context, state) {
                      return ShipmentWeightSelector(
                        selectedWeight: shipmentCubit.selectedWeight,
                        isWeightError: _isWeightError,
                        onWeightSelected: (weight) {
                          shipmentCubit.setWeight(weight);
                          setState(() {
                            _isWeightError = false;
                          });
                        },
                      );
                    },
                  ),
                  16.ph,

                  // 6. Package Image Uploader Widget
                  Text(
                    S.of(context).packageImageMandatory,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  10.ph,
                  BlocBuilder<ShipmentCubit, ShipmentState>(
                    key: _imageKey,
                    builder: (context, state) {
                      return ShipmentImageUploader(
                        packageImage: shipmentCubit.packageImage,
                        isImageError: _isImageError,
                        onTakePhoto: () {
                          shipmentCubit.takePhoto().then((_) {
                            if (shipmentCubit.packageImage != null) {
                              setState(() {
                                _isImageError = false;
                              });
                            }
                          });
                        },
                        onPickImage: () {
                          shipmentCubit.pickImage().then((_) {
                            if (shipmentCubit.packageImage != null) {
                              setState(() {
                                _isImageError = false;
                              });
                            }
                          });
                        },
                        onRemoveImage: () {
                          shipmentCubit.removeImage();
                          setState(() {
                            _isImageError = true;
                          });
                        },
                      );
                    },
                  ),
                  16.ph,

                  // 7. Terms & Conditions Checkbox Widget
                  BlocBuilder<ShipmentCubit, ShipmentState>(
                    key: _termsKey,
                    builder: (context, state) {
                      return ShipmentTermsCheckbox(
                        acceptedTerms: shipmentCubit.acceptedTerms,
                        isTermsError: _isTermsError,
                        onChanged: (val) {
                          shipmentCubit.toggleTerms(val);
                          setState(() {
                            _isTermsError = !(val ?? false);
                          });
                        },
                        onTapTerms: () {
                          navigateTo(context, Routes.shipmentTermsView);
                        },
                      );
                    },
                  ),
                  24.ph,

                  // 8. Submit Request Button
                  CustomButton(
                    buttonColor: AppColors.primaryColor,
                    text: S.of(context).confirmShipmentRequest,
                    onTap: () => _onConfirmShipment(
                      context,
                      shipmentCubit: shipmentCubit,
                      locationCubit: locationCubit,
                    ),
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

  void _onConfirmShipment(
    BuildContext context, {
    required ShipmentCubit shipmentCubit,
    required LocationCubit locationCubit,
  }) {
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
      if (locationCubit.sourcePlace == null ||
          locationCubit.destinationPlace == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("يرجى تحديد مكان الاستلام ومكان التسليم أولاً"),
          backgroundColor: Colors.red,
        ));
        return;
      }

      double distance = 5.0;
      if (locationCubit.sourcePlace?.lat != null &&
          locationCubit.destinationPlace?.lat != null) {
        distance = _calculateDistance(
          locationCubit.sourcePlace!.lat!,
          locationCubit.sourcePlace!.lng!,
          locationCubit.destinationPlace!.lat!,
          locationCubit.destinationPlace!.lng!,
        );
      }

      final userHomeCubit = context.read<UserHomeCubit>();
      int serviceId = 1;
      if (userHomeCubit.servicesDetails.isNotEmpty) {
        final shippingService = userHomeCubit.servicesDetails.firstWhere(
          (s) => s.service.serviceType == 'shipping',
          orElse: () => userHomeCubit.servicesDetails.first,
        );
        serviceId = shippingService.service.id!.toInt();
      }

      final model = NewRideRequestBodyModel(
        serviceId: serviceId,
        distance: distance.toStringAsFixed(1),
        destinationAddress:
            locationCubit.destinationPlace?.description ?? "",
        destinationLat:
            locationCubit.destinationPlace!.lat!.toString(),
        destinationLong:
            locationCubit.destinationPlace!.lng!.toString(),
        sourceAddress:
            locationCubit.sourcePlace?.description ?? "",
        sourceLat: locationCubit.sourcePlace!.lat!.toString(),
        sourceLong:
            locationCubit.sourcePlace!.lng!.toString(),
        offerRate: "0",
        interCity: false,
        paymentType: "cash",
        whenDate: DateTime.now().add(const Duration(minutes: 5)),
        numberOfPassenger: 1,
        receiverName: shipmentCubit.receiverNameController.text.trim(),
        receiverPhone: shipmentCubit.receiverPhoneController.text.trim(),
        parcelWeight: shipmentCubit.selectedWeight,
        parcelDimension:
            shipmentCubit.packageDetailsController.text.trim(),
        parcelImagePath: shipmentCubit.packageImage!.path,
      );

      userHomeCubit.newRideRequest(newRideRequestBodyModel: model);
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
  }
}
