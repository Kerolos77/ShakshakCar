import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/services/audio_service.dart';
import 'package:shakshak/core/services/real_time/realtime_manager.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/services/trip_storage_service.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_request_body_model.dart';
import 'package:shakshak/features/user/user_home/data/models/services_deteles_model.dart';
import 'package:shakshak/features/user/user_home/data/models/trip_offer_model.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/accept_offer_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/cancel_order_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/deny_offer_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/get_active_ride_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/get_captions_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/get_in_city_services_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/get_out_city_services_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/get_price_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/get_ride_details_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/new_ride_request_usecase.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_state.dart';

class UserHomeCubit extends Cubit<UserHomeState> {
  final GetCaptionsUseCase getCaptionsUseCase;
  final GetInCityServicesUseCase getInCityServicesUseCase;
  final GetOutCityServicesUseCase getOutCityServicesUseCase;
  final AcceptOfferUseCase acceptOfferUseCase;
  final DenyOfferUseCase denyOfferUseCase;
  final CancelOrderUseCase cancelOrderUseCase;
  final GetPriceUseCase getPriceUseCase;
  final NewRideRequestUseCase newRideRequestUseCase;
  final GetRideDetailsUseCase getRideDetailsUseCase;
  final GetUserActiveRideUseCase getActiveRideUseCase;

  UserHomeCubit({
    required this.getCaptionsUseCase,
    required this.getInCityServicesUseCase,
    required this.getOutCityServicesUseCase,
    required this.acceptOfferUseCase,
    required this.denyOfferUseCase,
    required this.cancelOrderUseCase,
    required this.getPriceUseCase,
    required this.newRideRequestUseCase,
    required this.getRideDetailsUseCase,
    required this.getActiveRideUseCase,
  })  : _realtimeService = sl<RealtimeManager>(),
        super(UserHomeInitial());

  static UserHomeCubit get(context) => BlocProvider.of(context);

  int? _currentTripId;

  final RealtimeManager _realtimeService;
  int? loadingOfferIndex;
  String? _tripOffersToken;
  String? _tripStatusToken;
  List<TripOfferModel> offers = <TripOfferModel>[];
  List<ServicesDetailsModel> servicesDetails = [];
  bool isAutoAcceptEnabled = true;
  double? requestedTripPrice;

  /// Check if there is an active trip on the server
  Future<void> checkActiveTrip() async {
    final result = await getActiveRideUseCase(NoParameters());
    result.fold(
      (error) {
        debugPrint("Error checking active trip: ${error.message}");
        // Fallback to local storage if API fails, or just clear it
        final activeTripId = TripStorageService.getActiveTripId();
        if (activeTripId != null) {
          emit(NewRideRequestActiveTripFound(
            activeOrderId: activeTripId,
            message: "Checking your current trip status...",
          ));
        }
      },
      (success) {
        if (success.id != 0) {
          debugPrint("Found active trip on server: ${success.id}");
          TripStorageService.saveActiveTripId(success.id);
          emit(NewRideRequestActiveTripFound(
            activeOrderId: success.id,
            message: 'already_has_active_trip',
            activeTrip: success,
          ));
        } else {
          TripStorageService.removeActiveTripId();
          emit(UserHomeInitial());
        }
      },
    );
  }

  /// Forcefully clears the active trip state without asking the server (prevents race conditions)
  Future<void> clearActiveTrip() async {
    await TripStorageService.removeActiveTripId();
    emit(UserHomeInitial());
  }

  Future<void> getCaptions() async {
    emit(UserHomeCaptionLoading());
    final result = await getCaptionsUseCase(NoParameters());
    result.fold(
      (error) {
        debugPrint("error while get captions data ${error.message}");
        return emit(UserHomeCaptionFailure(errorMessage: error.message));
      },
      (success) {
        return emit(UserHomeCaptionSuccess(userHomeCaptionModel: success));
      },
    );
  }

  Future<void> getServices(bool inCity) async {
    if (inCity) {
      emit(ServicesLoading());
      final result = await getInCityServicesUseCase(NoParameters());
      result.fold(
        (error) {
          debugPrint("error while get services data ${error.message}");
          return emit(ServicesFailure(errorMessage: error.message));
        },
        (success) {
          servicesDetails = success.data
                  ?.map((e) => ServicesDetailsModel(service: e))
                  .toList() ??
              [];
          return emit(ServicesSuccess(servicesModel: success));
        },
      );
    } else {
      emit(ServicesLoading());
      final result = await getOutCityServicesUseCase(NoParameters());
      result.fold(
        (error) {
          debugPrint("error while get services data ${error.message}");
          return emit(ServicesFailure(errorMessage: error.message));
        },
        (success) {
          servicesDetails = success.data
                  ?.map((e) => ServicesDetailsModel(service: e))
                  .toList() ??
              [];
          return emit(ServicesSuccess(servicesModel: success));
        },
      );
    }
  }

  Future<void> acceptOffer({
    required int offerId,
    required int driverId,
  }) async {
    emit(AcceptOfferLoading(offerId: offerId));

    final result = await acceptOfferUseCase(
        AcceptOfferUseCaseParams(offerId: offerId, driverId: driverId));

    result.fold(
      (error) {
        if (error is PaymentRequiredFailure) {
          debugPrint("Payment required for offer: ${error.data}");
          final checkoutUrl = error.data['checkout_url'] ?? '';
          emit(AcceptOfferPaymentRequired(
              offerId: offerId, checkoutUrl: checkoutUrl));
        } else {
          debugPrint("Error while accepting offer: ${error.message}");
          emit(AcceptOfferFailure(
              errorMessage: error.message, offerId: offerId));
        }
      },
      (success) {
        emit(AcceptOfferSuccess(acceptOfferModel: success, offerId: offerId));
      },
    );
  }

  void toggleAutoAccept(bool value) {
    isAutoAcceptEnabled = value;
    emit(OffersUpdated(List<TripOfferModel>.from(offers)));
  }

  Future<void> denyOffer({
    required int offerId,
  }) async {
    emit(DenyOfferLoading(offerId: offerId));

    final result =
        await denyOfferUseCase(DenyOfferUseCaseParams(offerId: offerId));

    result.fold(
      (error) {
        debugPrint("Error while denying offer: ${error.message}");
        emit(DenyOfferFailure(errorMessage: error.message, offerId: offerId));
      },
      (success) {
        offers.removeWhere((element) => element.id == offerId);
        emit(DenyOfferSuccess(offerId: offerId));
        emit(OffersUpdated(List<TripOfferModel>.from(offers)));
      },
    );
  }

  Future<void> cancelOrder({
    required int orderId,
  }) async {
    emit(CancelOrderLoading());
    final result = await cancelOrderUseCase(CancelOrderUseCaseParams(
      orderId: orderId,
    ));
    result.fold(
      (error) {
        debugPrint("error while get services data ${error.message}");
        return emit(CancelOrderFailure(errorMessage: error.message));
      },
      (success) {
        TripStorageService.removeActiveTripId();
        return emit(CancelOrderSuccess(cancelOrderModel: success));
      },
    );
  }

  Future<void> getPrice({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
  }) async {
    var origin = "$originLat,$originLng";
    var destination = "$destinationLat,$destinationLng";
    emit(GetPriceLoading());
    List<Future> futures = [];
    for (var element in servicesDetails) {
      final serviceId = element.service.id;
      if (serviceId != null) {
        futures.add(getPriceUseCase(GetPriceUseCaseParams(
          serviceId: serviceId.toInt(),
          origin: origin,
          destination: destination,
        )).then((value) {
          value.fold((l) {
            debugPrint("error while get price ${l.message}");
          }, (r) {
            element.price = r;
          });
        }));
      }
    }
    await Future.wait(futures);
    if (servicesDetails.isEmpty) {
      emit(GetPriceFailure(errorMessage: "No services found"));
    } else {
      emit(GetPriceSuccess(servicesDetails: servicesDetails));
    }
  }

  Future<void> newRideRequest({
    required NewRideRequestBodyModel newRideRequestBodyModel,
  }) async {
    emit(NewRideRequestLoading());
    final result = await newRideRequestUseCase(NewRideRequestUseCaseParams(
      newRideRequestBodyModel: newRideRequestBodyModel,
    ));
    result.fold(
      (error) {
        if (error is ActiveTripFailure) {
          debugPrint("Active trip detected via 400: ${error.activeOrderId}");
          TripStorageService.saveActiveTripId(error.activeOrderId);
          return emit(NewRideRequestActiveTripFound(
            activeOrderId: error.activeOrderId,
            message: error.message,
          ));
        }
        debugPrint("error while new ride request ${error.message}");
        return emit(NewRideRequestFailure(errorMessage: error.message));
      },
      (success) {
        TripStorageService.saveActiveTripId(success.id);
        return emit(NewRideRequestSuccess(newRideModel: success));
      },
    );
  }

  Future<void> getRideDetails(int rideId) async {
    emit(NewRideRequestLoading());
    final result = await getRideDetailsUseCase(rideId);
    result.fold(
      (error) {
        debugPrint("error while fetching ride details: ${error.message}");
        emit(NewRideRequestFailure(errorMessage: error.message));
      },
      (success) {
        emit(NewRideRequestSuccess(newRideModel: success));
      },
    );
  }

  void connect(int tripId, int userId, {double? tripPrice}) {
    debugPrint("🔌 UserHomeCubit: Connecting to trip $tripId (User: $userId)");
    _currentTripId = tripId;
    requestedTripPrice = tripPrice;

    offers.clear();

    final String tripOffersChannelName = "trip-offers-$tripId";
    final String tripStatusChannelName = "trip-$tripId";

    emit(OffersUpdated(List<TripOfferModel>.from(offers)));
    emit(TripRealtimeConnected());

    _listenToTripOffers(tripOffersChannelName);
    _listenToTripStatus(tripStatusChannelName);
  }

  void _listenToTripOffers(String channelName) {
    if (_tripOffersToken != null) {
      _realtimeService.removeListener(_tripOffersToken!);
    }

    _tripOffersToken = _realtimeService.addListener(
      channel: channelName,
      event: 'offer',
      callback: (data) {
        debugPrint("📥 RAW Pusher Data received: $data");
        AudioService().playNotificationSound();

        if (data == null) {
          debugPrint("⚠️ Received NULL data from Pusher");
          return;
        }

        Map<String, dynamic> json;
        try {
          json = Map<String, dynamic>.from(data);
        } catch (e) {
          debugPrint("❌ Failed to cast data to Map: $e");
          return;
        }

        // Handle wrapping if the whole payload is inside 'data' or 'offer'
        if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
          final wrappedData = json['data'] as Map<String, dynamic>;
          if (wrappedData.containsKey('offers') ||
              wrappedData.containsKey('offer_id') ||
              wrappedData.containsKey('id')) {
            json = wrappedData;
          }
        }

        if (json.containsKey('offers') &&
            json['offers'] is List &&
            (json['offers'] as List).isNotEmpty) {
          debugPrint(
              "✅ Found ${(json['offers'] as List).length} offers in payload. Updating list...");
          offers.clear();
          for (var offerData in (json['offers'] as List)) {
            final Map<String, dynamic> merged = Map<String, dynamic>.from(json);
            merged.addAll(Map<String, dynamic>.from(offerData));
            // نستخدم الـ id بتاع الأوفر نفسه
            merged['id'] = offerData['offer_id'] ?? offerData['id'];
            final currentOffer = TripOfferModel.fromJson(merged);

            offers.removeWhere((element) =>
                element.id == currentOffer.id ||
                (element.driverId != 0 &&
                    element.driverId == currentOffer.driverId));

            offers.add(currentOffer);

            if (isAutoAcceptEnabled &&
                requestedTripPrice != null &&
                currentOffer.offerDriver.toDouble() == requestedTripPrice) {
              debugPrint(
                  "✅ Auto Accepting Offer from list: ${currentOffer.id}");
              acceptOffer(
                offerId: currentOffer.id,
                driverId: currentOffer.driverId,
              );
            }
          }
        } else {
          // Single offer case
          // Check if the single offer is inside 'offer' key
          Map<String, dynamic> singleOfferJson = json;
          if (json.containsKey('offer') &&
              json['offer'] is Map<String, dynamic>) {
            singleOfferJson = json['offer'];
          }

          final newOffer = TripOfferModel.fromJson(singleOfferJson);
          debugPrint(
              "ℹ️ Parsed single offer with ID: ${newOffer.id}, Driver: ${newOffer.driverName}");

          offers.removeWhere((element) =>
              element.id == newOffer.id ||
              (element.driverId != 0 && element.driverId == newOffer.driverId));

          offers.add(newOffer);

          if (isAutoAcceptEnabled &&
              requestedTripPrice != null &&
              newOffer.offerDriver.toDouble() == requestedTripPrice) {
            debugPrint("✅ Auto Accepting Single Offer: ${newOffer.id}");
            acceptOffer(
              offerId: newOffer.id,
              driverId: newOffer.driverId,
            );
          }
        }

        // --- التصفية النهائية والتحقق من عدم التكرار ---

        offers.removeWhere((offer) =>
            offer.status == 'user_denied' ||
            offer.status == 'driver_canceled' ||
            offer.status == 'canceled' ||
            offer.status == 'denied');

        final Map<String, TripOfferModel> uniqueOffers = {};
        for (var o in offers) {
          if (o.driverId != 0) {
            uniqueOffers["driver_${o.driverId}"] = o;
          } else {
            uniqueOffers["offer_${o.id}"] = o;
          }
        }

        offers = uniqueOffers.values.toList();
        debugPrint("📊 Final offers count to display: ${offers.length}");

        emit(OffersUpdated(List<TripOfferModel>.from(offers)));
      },
    );

    debugPrint('✅ Listening to offers on channel $channelName');
  }

  void _listenToTripStatus(String channelName) {
    if (_tripStatusToken != null) {
      _realtimeService.removeListener(_tripStatusToken!);
    }

    _tripStatusToken = _realtimeService.addListener(
      channel: channelName,
      event: 'TripStatusUpdated',
      callback: (data) {
        debugPrint("📥 حالة الرحلة اتغيرت: $data");
        final status = data['status'];
        final orderData = data['order'];
        final tripModel = NewRideData.fromJson(orderData);

        if (status == 'completed' ||
            status == 'canceled' ||
            status == 'user_cancel') {
          TripStorageService.removeActiveTripId();
        }

        emit(TripStatusChanged(status: status, tripModel: tripModel));
      },
    );

    debugPrint('✅ Listening to trip status updates on channel $channelName');
  }

  void closeTripOffersSubscription() {
    if (_tripOffersToken != null) {
      _realtimeService.removeListener(_tripOffersToken!);
      _tripOffersToken = null;
    }
    if (_tripStatusToken != null) {
      _realtimeService.removeListener(_tripStatusToken!);
      _tripStatusToken = null;
    }

    if (_currentTripId != null) {
      _realtimeService.unsubscribe('trip-$_currentTripId');
      _realtimeService.unsubscribe('trip-offers-$_currentTripId');
    }

    debugPrint('🚫 Stopped listening to offers');
  }

  bool isFemaleOnly = false;

  void toggleFemaleOnly(bool value) {
    isFemaleOnly = value;
    emit(OffersUpdated(List<TripOfferModel>.from(
        offers))); // using an existing simple state update
  }

  @override
  Future<void> close() {
    closeTripOffersSubscription();
    return super.close();
  }
}
