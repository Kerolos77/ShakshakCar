import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_request_body_model.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_state.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/book_ride/book_ride_map.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/book_ride/book_ride_sheet_content.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_states.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/payment_cubit.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/payment_states.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/resources/app_colors.dart';

import 'package:shakshak/core/utils/google_maps_resolver.dart';

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
    selectedPaymentMethod = CacheHelper.getData(key: 'default_payment_method') ?? 'cash';
    useWallet = CacheHelper.getData(key: 'use_wallet') ?? false;
    if (selectedPaymentMethod == 'wallet') {
      selectedPaymentMethod = 'cash';
      useWallet = true;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthCubit>().getProfile();
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
            navigateAndFinish(context, Routes.offersView,
                extra: OffersViewArgs(newRideData: state.newRideModel));
          } else if (state is NewRideRequestActiveTripFound) {
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
                    return BookRideSheetContent(
                      isInCity: isInCity,
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
                              content: Text(S.of(context).checkingAccountStatus),
                            ),
                          );
                          return;
                        }

                        if (!_isUserVerified) {
                          _showVerificationRequiredDialog(context);
                          return;
                        }

                        if (selectedServiceIndex != -1) {
                          if (userHomeCubit.servicesDetails.isNotEmpty) {
                            var selectedService = userHomeCubit
                                .servicesDetails[selectedServiceIndex];

                            String mappedPaymentType = 'cash';
                            int? mappedCardId;

                            if (selectedPaymentMethod == 'cash') {
                              mappedPaymentType = useWallet ? 'wallet_cash' : 'cash';
                            } else {
                              mappedCardId = int.tryParse(selectedPaymentMethod);
                              mappedPaymentType = useWallet ? 'wallet_card' : 'saved_card';
                            }

                            var model = NewRideRequestBodyModel(
                              serviceId: selectedService.service.id!.toInt(),
                              distance: distance.toString(),
                              destinationAddress:
                                  locationCubit.destinationPlace?.description ??
                                      "",
                              destinationLat: locationCubit
                                  .destinationPlace!.lat!
                                  .toString(),
                              destinationLong: locationCubit
                                  .destinationPlace!.lng!
                                  .toString(),
                              sourceAddress:
                                  locationCubit.sourcePlace?.description ?? "",
                              sourceLat:
                                  locationCubit.sourcePlace!.lat!.toString(),
                              sourceLong:
                                  locationCubit.sourcePlace!.lng!.toString(),
                              offerRate: currentOffer.toString(),
                              interCity: !isInCity,
                              paymentType: mappedPaymentType,
                              savedCardId: mappedCardId,
                              whenDate: scheduledDate,
                              numberOfPassenger: passengerCount,
                              femaleOnly: userHomeCubit.isFemaleOnly,
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
              navigateTo(context, Routes.userIdentityVerificationView).then((_) {
                _checkVerificationStatus();
              });
            },
            child: Text(
              S.of(context).verifyNow,
              style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
