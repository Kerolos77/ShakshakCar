import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/google_maps_resolver.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/payment_cubit.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/payment_states.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_request_body_model.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_states.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_state.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/book_ride/book_ride_map.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/book_ride/book_ride_sheet_content.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:pinput/pinput.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/generated/l10n.dart';

class BookRide extends StatefulWidget {
  const BookRide({super.key, this.args});

  final BookRideArgs? args;

  @override
  State<BookRide> createState() => _BookRideState();
}

class _BookRideState extends State<BookRide> {
  final Completer<GoogleMapController> mapCompleter =
      Completer<GoogleMapController>();
  GoogleMapController? mapController;
  int selectedServiceIndex = -1;
  bool? _lastIsInCity;

  bool _isVerificationChecked = false;
  bool _isUserVerified = false;

  Future<void> _checkVerificationStatus() async {
    try {
      final token = CacheHelper.getData(key: AppConstant.kToken);
      final response = await DioHelper.getData(
        url: 'user/identity-status',
        token: token,
      );
      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data['data'];
        if (resData != null) {
          setState(() {
            _isUserVerified = resData['verification_status'] == 'verified';
            _isVerificationChecked = true;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint("Error checking verification status in BookRide: $e");
    }
    setState(() {
      _isUserVerified = false;
      _isVerificationChecked = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkVerificationStatus();
    selectedPaymentMethod =
        CacheHelper.getData(key: 'default_payment_method') ?? 'cash';
    useWallet = CacheHelper.getData(key: 'use_wallet') ?? false;
    if (selectedPaymentMethod == 'wallet') {
      selectedPaymentMethod = 'cash';
      useWallet = true;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthCubit>().getProfile();
        // If source and destination are already selected (e.g. from ShipmentRequestView), fetch prices immediately!
        final locationCubit = context.read<LocationCubit>();
        if (locationCubit.sourcePlace != null &&
            locationCubit.destinationPlace != null) {
          context.read<UserHomeCubit>().getPrice(
                originLat: locationCubit.sourcePlace!.lat ?? 0,
                originLng: locationCubit.sourcePlace!.lng ?? 0,
                destinationLat: locationCubit.destinationPlace!.lat ?? 0,
                destinationLng: locationCubit.destinationPlace!.lng ?? 0,
              );
        }
      }
    });
    _handleDeepLink();
  }

  void _handleDeepLink() {
    final locationCubit = context.read<LocationCubit>();
    locationCubit.getMyLocation();

    final args = widget.args;
    if (args != null) {
      if (args.latParam != null && args.lngParam != null) {
        final lat = double.tryParse(args.latParam!);
        final lng = double.tryParse(args.lngParam!);
        if (lat != null && lng != null) {
          locationCubit.setDestinationFromCoordinates(lat, lng);
        }
      } else if (args.googleMapsUrl != null) {
        GoogleMapsUrlResolver.getCoordinatesFromUrl(args.googleMapsUrl!)
            .then((coords) {
          if (coords != null) {
            locationCubit.setDestinationFromCoordinates(
                coords.latitude, coords.longitude);
          }
        });
      }
    }
  }

  // Price Control Variables

  double currentOffer = 0.0;
  double minPriceLimit = 0.0;
  double maxPriceLimit = 0.0;
  final double priceStep = 5.0; // Fixed increment/decrement amount
  final double priceFactor = 0.5; // 50% variation

  // Payment Method
  String selectedPaymentMethod = 'cash'; // Default
  bool useWallet = false;

  // Schedule & Passengers
  DateTime scheduledDate = DateTime.now().add(const Duration(minutes: 5));
  int passengerCount = 1;

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    mapCompleter.complete(controller);
    mapController = controller;
  }

  void _initializePrice(String basePriceStr) {
    basePriceStr = basePriceStr.replaceAll(',', '');
    double basePrice = double.tryParse(basePriceStr) ?? 0.0;
    setState(() {
      currentOffer = basePrice;
      minPriceLimit = basePrice * (1 - priceFactor); // e.g., 50% less
      maxPriceLimit = basePrice * (1 + priceFactor); // e.g., 50% more
    });
  }

  void _resetPrice(String basePriceStr) {
    basePriceStr = basePriceStr.replaceAll(',', '');
    double basePrice = double.tryParse(basePriceStr) ?? 0.0;
    setState(() {
      currentOffer = basePrice;
    });
  }

  void _increasePrice() {
    setState(() {
      if (currentOffer + priceStep <= maxPriceLimit) {
        currentOffer += priceStep;
      } else {
        currentOffer = maxPriceLimit;
      }
    });
  }

  void _decreasePrice() {
    setState(() {
      if (currentOffer - priceStep >= minPriceLimit) {
        currentOffer -= priceStep;
      } else {
        currentOffer = minPriceLimit;
      }
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      currentOffer = value;
    });
  }

  void _onPaymentMethodChanged(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });
    CacheHelper.saveData(key: 'default_payment_method', value: method);
  }

  void _onWalletToggled(bool value) {
    setState(() {
      useWallet = value;
    });
    CacheHelper.saveData(key: 'use_wallet', value: value);
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      scheduledDate = date;
    });
  }

  void _onPassengerCountChanged(int count) {
    setState(() {
      passengerCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    var locationCubit = context.read<LocationCubit>();
    var userHomeCubit = context.read<UserHomeCubit>();
    return BlocListener<LocationCubit, LocationState>(
      listener: (context, state) {
        if (state is PlaceSelectedState) {
          if (locationCubit.sourcePlace != null &&
              locationCubit.destinationPlace != null) {
            userHomeCubit.getPrice(
              originLat: locationCubit.sourcePlace?.lat ?? 0,
              originLng: locationCubit.sourcePlace?.lng ?? 0,
              destinationLat: locationCubit.destinationPlace?.lat ?? 0,
              destinationLng: locationCubit.destinationPlace?.lng ?? 0,
            );
          }
        }
      },
      child: BlocListener<PaymentCubit, PaymentState>(
        listener: (context, state) async {
          if (state is AddCardRequiresWebView) {
            await navigateTo(
              context,
              Routes.ridePaymentWebView,
              extra: RidePaymentWebViewArgs(
                checkoutUrl: state.checkoutUrl,
                orderId: int.tryParse(state.orderId) ?? 0,
                isAddingCard: true,
              ),
            );
            if (context.mounted) {
              PaymentCubit.get(context).getSavedCards();
              context.read<AuthCubit>().getProfile();
            }
          } else if (state is AddCardFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        child: BlocConsumer<UserHomeCubit, UserHomeState>(
          listener: (context, state) {
            if (state is ServicesSuccess) {
              if (locationCubit.sourcePlace != null &&
                  locationCubit.destinationPlace != null) {
                userHomeCubit.getPrice(
                  originLat: locationCubit.sourcePlace?.lat ?? 0,
                  originLng: locationCubit.sourcePlace?.lng ?? 0,
                  destinationLat: locationCubit.destinationPlace?.lat ?? 0,
                  destinationLng: locationCubit.destinationPlace?.lng ?? 0,
                );
              }
            } else if (state is NewRideRequestSuccess) {
              final bool isShippingOrder = widget.args?.isShipping == true || 
                                           state.newRideModel.isShippingOrder || 
                                           (state.newRideModel.receiverPhone != null && state.newRideModel.receiverPhone!.isNotEmpty) ||
                                           (widget.args?.receiverPhone != null && widget.args!.receiverPhone!.isNotEmpty);

              if (isShippingOrder && !state.newRideModel.isReceiverVerified) {
                _showReceiverOtpVerificationDialog(context, state.newRideModel);
              } else {
                navigateAndFinish(context, Routes.offersView,
                    extra: OffersViewArgs(newRideData: state.newRideModel));
              }
            } else if (state is NewRideRequestActiveTripFound) {
              Navigator.of(context, rootNavigator: true).pop(); // hide loading
              final msg = state.message == 'already_has_active_trip'
                  ? S.of(context).alreadyHasActiveTrip
                  : state.message;
              _showActiveTripDialog(context, state.activeOrderId, msg);
            } else if (state is CancelOrderLoading) {
              // Optional: show loading overlay
            } else if (state is CancelOrderSuccess) {
              Navigator.of(context).pop(); // Close the dialog
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(S.of(context).doneSuccessfully),
                backgroundColor: Colors.green,
              ));
            } else if (state is CancelOrderFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ));
            }
          },
          builder: (context, state) {
            return BaseLayoutView(
              title: S.of(context).bookRide,
              horizontalPadding: 0,
              topPadding: 0,
              body: Stack(
                children: [
                  BookRideMap(
                    locationCubit: locationCubit,
                    onMapCreated: onMapCreated,
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.4,
                    minChildSize: 0.3,
                    maxChildSize: 0.8,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      double distance = 0;
                      if (locationCubit.sourcePlace?.lat != null &&
                          locationCubit.sourcePlace?.lng != null &&
                          locationCubit.destinationPlace?.lat != null &&
                          locationCubit.destinationPlace?.lng != null) {
                        distance = calculateDistance(
                          locationCubit.sourcePlace!.lat!,
                          locationCubit.sourcePlace!.lng!,
                          locationCubit.destinationPlace!.lat!,
                          locationCubit.destinationPlace!.lng!,
                        );
                      }
                      bool isInCity = distance <= 100;
                      if (_lastIsInCity != isInCity) {
                        _lastIsInCity = isInCity;
                        selectedServiceIndex = -1;
                      }

                      // Filter services if in shipping mode
                      var services = userHomeCubit.servicesDetails;
                      if (widget.args?.isShipping == true) {
                        services = services.where((s) {
                          return _isServiceCompatible(
                            serviceName: s.service.name ?? '',
                            selectedWeight:
                                widget.args?.parcelWeight ?? 'light',
                            selectedDimension:
                                widget.args?.parcelDimension ?? '',
                          );
                        }).toList();
                      }

                      return BookRideSheetContent(
                        isInCity: isInCity,
                        isShipping: widget.args?.isShipping ?? false,
                        parcelWeight: widget.args?.parcelWeight,
                        parcelDimension: widget.args?.parcelDimension,
                        scrollController: scrollController,
                        selectedServiceIndex: selectedServiceIndex,
                        selectedPaymentMethod: selectedPaymentMethod,
                        useWallet: useWallet,
                        currentOffer: currentOffer,
                        minPriceLimit: minPriceLimit,
                        maxPriceLimit: maxPriceLimit,
                        scheduledDate: scheduledDate,
                        passengerCount: passengerCount,
                        onServiceSelected: (index, price) {
                          setState(() {
                            selectedServiceIndex = index;
                            _initializePrice(price);
                          });
                        },
                        onIncreasePrice: _increasePrice,
                        onDecreasePrice: _decreasePrice,
                        onSliderChanged: _onSliderChanged,
                        onResetPrice: _resetPrice,
                        onPaymentChanged: _onPaymentMethodChanged,
                        onWalletToggled: _onWalletToggled,
                        onDateChanged: _onDateChanged,
                        onPassengerCountChanged: _onPassengerCountChanged,
                        onConfirmTap: () {
                          if (state is NewRideRequestLoading) return;

                          if (!_isVerificationChecked) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text(S.of(context).checkingAccountStatus),
                              ),
                            );
                            return;
                          }

                          if (!_isUserVerified) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    S.of(context).identityRequiredDialogMsg),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            navigateTo(context,
                                    Routes.userIdentityVerificationView)
                                .then((_) {
                              _checkVerificationStatus();
                            });
                            return;
                          }

                          if (selectedServiceIndex != -1) {
                            if (services.isNotEmpty) {
                              var selectedService =
                                  services[selectedServiceIndex];

                              String mappedPaymentType = 'cash';
                              int? mappedCardId;

                              if (selectedPaymentMethod == 'cash') {
                                mappedPaymentType =
                                    useWallet ? 'wallet_cash' : 'cash';
                              } else {
                                mappedCardId =
                                    int.tryParse(selectedPaymentMethod);
                                mappedPaymentType =
                                    useWallet ? 'wallet_card' : 'saved_card';
                              }

                              var model = NewRideRequestBodyModel(
                                serviceId: selectedService.service.id!.toInt(),
                                distance: distance.toString(),
                                destinationAddress: locationCubit
                                        .destinationPlace?.description ??
                                    "",
                                destinationLat: locationCubit
                                    .destinationPlace!.lat!
                                    .toString(),
                                destinationLong: locationCubit
                                    .destinationPlace!.lng!
                                    .toString(),
                                sourceAddress:
                                    locationCubit.sourcePlace?.description ??
                                        "",
                                sourceLat:
                                    locationCubit.sourcePlace!.lat!.toString(),
                                sourceLong:
                                    locationCubit.sourcePlace!.lng!.toString(),
                                offerRate: currentOffer.toString(),
                                interCity: false,
                                paymentType: mappedPaymentType,
                                savedCardId: mappedCardId,
                                whenDate: scheduledDate,
                                numberOfPassenger:
                                    widget.args?.isShipping == true
                                        ? 1
                                        : passengerCount,
                                femaleOnly: widget.args?.isShipping == true
                                    ? false
                                    : userHomeCubit.isFemaleOnly,
                                receiverName: widget.args?.receiverName,
                                receiverPhone: widget.args?.receiverPhone,
                                parcelWeight: widget.args?.parcelWeight,
                                parcelDimension: widget.args?.parcelDimension,
                                parcelImagePath: widget.args?.parcelImagePath,
                              );

                              userHomeCubit.newRideRequest(
                                  newRideRequestBodyModel: model);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(S.of(context).pleaseSelectRide),
                            ));
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showActiveTripDialog(
      BuildContext context, int activeOrderId, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<UserHomeCubit>(),
        child: AlertDialog(
          title: Text(S.of(context).warning),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                _showCancelConfirmationDialog(context, activeOrderId);
              },
              child: Text(
                S.of(context).cancel,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<UserHomeCubit>().getRideDetails(activeOrderId);
              },
              child: Text(S.of(context).resumeYourTrip),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmationDialog(BuildContext context, int orderId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(S.of(context).confirmCancellation),
        content: Text(S.of(context).confirmCancelTripMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(S.of(context).goBack),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
              context.read<UserHomeCubit>().cancelOrder(orderId: orderId);
            },
            child: Text(
              S.of(context).confirmCancellation,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showReceiverOtpVerificationDialog(BuildContext context, NewRideDataEntity newRideData) {
    final TextEditingController otpController = TextEditingController();
    final receiverPhone = newRideData.receiverPhone?.isNotEmpty == true
        ? newRideData.receiverPhone!
        : (widget.args?.receiverPhone ?? '');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: BlocProvider.value(
          value: context.read<UserHomeCubit>(),
          child: BlocConsumer<UserHomeCubit, UserHomeState>(
            listener: (dialogContext, state) {
              if (state is VerifyReceiverOtpSuccess) {
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext, rootNavigator: true).pop();
                }
                if (context.mounted) {
                  showSnackBar(
                    context,
                    state.message,
                    S.of(context).doneSuccessfully,
                    AppColors.primaryColor,
                    ContentType.success,
                  );
                  navigateAndFinish(
                    context,
                    Routes.offersView,
                    extra: OffersViewArgs(newRideData: newRideData),
                  );
                }
              } else if (state is VerifyReceiverOtpFailure) {
                if (dialogContext.mounted) {
                  showSnackBar(
                    dialogContext,
                    state.errorMessage,
                    S.of(context).errorOccurred,
                    AppColors.redColor,
                    ContentType.failure,
                  );
                }
              }
            },
            builder: (dialogContext, state) {
              final isLoading = state is VerifyReceiverOtpLoading;
              final defaultPinTheme = PinTheme(
                width: 50.w,
                height: 56.h,
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              );

              final focusedPinTheme = defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: AppColors.primaryColor, width: 2),
                ),
              );

              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: AppColors.primaryColor),
                    SizedBox(width: 8),
                    Text(
                      "تأكيد رقم المستلم",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "تم إرسال كود تأكيد مكون من 4 أرقام عبر SMS إلى رقم المستلم ($receiverPhone). يرجى التواصل معه وإدخال الكود لبدء استقبال عروض الكباتن.",
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Pinput(
                          controller: otpController,
                          length: 4,
                          enabled: !isLoading,
                          autofocus: true,
                          autofillHints: const [AutofillHints.oneTimeCode],
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          onClipboardFound: (value) {
                            otpController.setText(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              final otp = otpController.text.trim();
                              if (otp.length == 4) {
                                dialogContext.read<UserHomeCubit>().verifyReceiverOtp(
                                      orderId: newRideData.id,
                                      otp: otp,
                                    );
                              } else {
                                showSnackBar(
                                  dialogContext,
                                  "يرجى إدخال كود مكون من 4 أرقام",
                                  S.of(context).errorOccurred,
                                  AppColors.redColor,
                                  ContentType.failure,
                                );
                              }
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "تأكيد الكود",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showVerificationRequiredDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
              title: Text(
                S.of(context).identityRequiredDialogTitle,
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(
                S.of(context).identityRequiredDialogMsg,
                textAlign: TextAlign.right,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: Text(S.of(context).cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    navigateTo(context, Routes.userIdentityVerificationView)
                        .then((_) {
                      _checkVerificationStatus();
                    });
                  },
                  child: Text(
                    S.of(context).verifyNow,
                    style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ));
  }

  bool _isServiceCompatible({
    required String serviceName,
    required String selectedWeight,
    required String selectedDimension,
  }) {
    final name = serviceName.toLowerCase();

    // Determine vehicle type
    final bool isMotorcycle = name.contains('موتوسيكل') ||
        name.contains('motorcycle') ||
        name.contains('bike') ||
        name.contains('فيسبا') ||
        name.contains('vespa') ||
        (name.contains('سيكل') && !name.contains('تروسيكل'));

    final bool isTricycle =
        name.contains('تروسيكل') || name.contains('tricycle');

    // Check if the dimension is a large package/electronics/other
    final dim = selectedDimension.toLowerCase();
    final bool isLargePackage = dim.contains('طرد') ||
        dim.contains('كرتونة') ||
        dim.contains('box') ||
        dim.contains('parcel') ||
        dim.contains('أخرى') ||
        dim.contains('other') ||
        dim.contains('أجهزة') ||
        dim.contains('electronics');

    // 1. Check Motorcycle compatibility:
    // - Only supports 'light' weight (0-5 Kg).
    // - Cannot carry large/bulky items.
    if (isMotorcycle) {
      if (selectedWeight != 'light') return false;
      if (isLargePackage) return false;
    }

    // 2. Check Tricycle compatibility:
    // - Only supports 'light' and 'medium' weights (up to 20 Kg).
    if (isTricycle) {
      if (selectedWeight == 'heavy') return false;
    }

    return true;
  }
}
