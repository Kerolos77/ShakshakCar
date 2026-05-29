import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:shakshak/core/services/audio_service.dart';
import 'package:shakshak/core/services/real_time/realtime_manager.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/driver/home/domain/usecases/get_demand_map_usecase.dart';
import 'package:shakshak/features/driver/new_rides/domain/usecases/accept_ride_usecase.dart';
import 'package:shakshak/features/driver/new_rides/domain/usecases/counter_offer_usecase.dart';
import 'package:shakshak/features/driver/new_rides/domain/usecases/fetch_negotiation_settings_usecase.dart';
import 'package:shakshak/core/services/user_storage_service.dart';
import 'package:shakshak/features/driver/new_rides/domain/usecases/fetch_new_rides_usecase.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_state.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';

import 'package:shakshak/features/driver/new_rides/domain/usecases/reject_ride_usecase.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';

class RideCubit extends Cubit<RideState> {
  RideCubit(
    this.fetchNewRidesUseCase,
    this.acceptRideUseCase,
    this.counterOfferUseCase,
    this.fetchNegotiationSettingsUseCase,
    this.rejectRideUseCase,
    this.getDemandMapUseCase,
  )   : _realtimeService = sl<RealtimeManager>(),
        super(RideState.initial()) {
    _getCurrentLocation();
    fetchNegotiationSettings();
    fetchDemandMap();
  }

  final RealtimeManager _realtimeService;
  String? _newRidesToken;
  final Map<int, String> _tripChannelTokens = {};
  final FetchNewRidesUseCase fetchNewRidesUseCase;
  final AcceptRideUseCase acceptRideUseCase;
  final CounterOfferUseCase counterOfferUseCase;
  final FetchNegotiationSettingsUseCase fetchNegotiationSettingsUseCase;
  final RejectRideUseCase rejectRideUseCase;
  final GetDemandMapUseCase getDemandMapUseCase;
  LatLng? currentDriverLocation;

  Future<void> _getCurrentLocation() async {
    try {
      loc.Location location = loc.Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }

      loc.PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) return;
      }

      loc.LocationData locationData = await location.getLocation();
      currentDriverLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
      emit(state.copyWith(status: RideStatus.loaded));
    } catch (e) {
      debugPrint("Could not get location: $e");
    }
  }

  Future<void> fetchNegotiationSettings() async {
    var result = await fetchNegotiationSettingsUseCase(const NoParameters());
    result.fold(
      (fail) =>
          debugPrint("Failed to load negotiation settings: ${fail.message}"),
      (settings) => emit(state.copyWith(negotiationSettings: settings)),
    );
  }

  Future<void> fetchDemandMap() async {
    var result = await getDemandMapUseCase(const NoParameters());
    result.fold(
      (fail) => debugPrint("Failed to load demand map: ${fail.message}"),
      (demandMap) => emit(state.copyWith(demandMap: demandMap)),
    );
  }

  Future<void> fetchRides() async {
    emit(state.copyWith(status: RideStatus.loading));
    var result = await fetchNewRidesUseCase(const NoParameters());
    result.fold((fail) {
      debugPrint("error while fetching old rides: ${fail.message}");
      emit(state.copyWith(status: RideStatus.error, message: fail.message));
    }, (List<NewRideData> rideList) {
      List<NewRideData> currentRides = List.from(state.rides);
      for (var oldRide in rideList) {
        if (!currentRides.any((r) => r.id == oldRide.id)) {
          currentRides.add(oldRide);
        }
      }
      // ترتيب بعد الجلب
      final sorted = _sortRides(currentRides, state.pendingOffers);
      emit(state.copyWith(status: RideStatus.loaded, rides: sorted));
    });
  }

  void connectToWebSocket() {
    if (_newRidesToken != null) return;

    final user = UserStorageService.getUser();
    final driverId = user?.id;

    if (driverId == null) {
      debugPrint('⚠️ RideCubit: Driver ID is null, cannot subscribe to driver channel');
      return;
    }

    final channelName = 'driver-$driverId';
    debugPrint('📡 RideCubit: Subscribing to $channelName channel...');
    _newRidesToken = _realtimeService.addListener(
      channel: channelName,
      event: "TripStatusUpdated",
      callback: (data) {
        try {
          debugPrint('📥 TripStatusUpdated on drivers channel: $data');

          Map<String, dynamic> payload;
          if (data is String) {
            payload = jsonDecode(data) as Map<String, dynamic>;
          } else if (data is Map<String, dynamic>) {
            payload = data;
          } else if (data is Map) {
            payload = Map<String, dynamic>.from(data);
          } else {
            debugPrint('⚠️ تنسيق غير معروف للبيانات: $data');
            return;
          }

          final orderData = payload.containsKey('order') ? payload['order'] : payload;
          final ride = NewRideData.fromJson(orderData as Map<String, dynamic>);
          final isExisting = state.rides.any((r) => r.id == ride.id);

          if (!isExisting) {
            // رحلة جديدة - أضفها للقائمة وشغّل الصوت والاهتزاز
            AudioService().playNotificationSound();
            HapticFeedback.heavyImpact();
            List<NewRideData> updatedRides = List.from(state.rides);
            Set<int> updatedNewRideIds = Set.from(state.newRideIds);
            final Map<int, DateTime> updatedSeenAt =
                Map.from(state.newRideSeenAt);

            updatedNewRideIds.add(ride.id);
            updatedSeenAt[ride.id] = DateTime.now();
            updatedRides.insert(0, ride);

            final sorted = _sortRides(updatedRides, state.pendingOffers);

            emit(state.copyWith(
              status: RideStatus.loaded,
              rides: sorted,
              newRideIds: updatedNewRideIds,
              newRideSeenAt: updatedSeenAt,
            ));
          } else {
            // رحلة موجودة - حدّث بياناتها (رد العميل على الأوفر مثلاً)
            debugPrint('📥 تحديث رحلة موجودة id=${ride.id} status=${ride.status}');
            final updatedRides = state.rides.map((r) {
              return r.id == ride.id ? ride : r;
            }).toList();
            final sorted = _sortRides(updatedRides, state.pendingOffers);
            emit(state.copyWith(status: RideStatus.loaded, rides: sorted));
          }
        } catch (e) {
          debugPrint('⚠️ خطأ في معالجة TripStatusUpdated: $e');
        }
      },
    );
  }

  // ─── اشتراك في TripStatusUpdated لمعرفة رد اليوز على الأوفر ───────────────
  void subscribeToTripChannel(int orderId) {
    if (_tripChannelTokens.containsKey(orderId)) return; // مشترك بالفعل

    debugPrint('📡 RideCubit: Subscribing to trip-$orderId channel...');
    final token = _realtimeService.addListener(
      channel: 'trip-$orderId',
      event: 'TripStatusUpdated',
      callback: (rawData) {
        try {
          debugPrint('📥 TripStatusUpdated trip-$orderId: $rawData');

          // الـ data قد تكون String JSON أو Map مباشرة
          Map<String, dynamic> payload;
          if (rawData is String) {
            payload = jsonDecode(rawData) as Map<String, dynamic>;
          } else if (rawData is Map<String, dynamic>) {
            payload = rawData;
          } else {
            return;
          }

          // استخلاص الـ order Object
          final orderJson = payload['order'] is Map<String, dynamic>
              ? payload['order'] as Map<String, dynamic>
              : null;
          if (orderJson == null) return;

          // تحديث الرحلة في الـ state بنفس الـ id
          final updatedRide = NewRideData.fromJson(orderJson);
          final updatedRides = state.rides.map((r) {
            return r.id == orderId ? updatedRide : r;
          }).toList();

          final sorted = _sortRides(updatedRides, state.pendingOffers);
          emit(state.copyWith(status: RideStatus.loaded, rides: sorted));
        } catch (e) {
          debugPrint('⚠️ خطأ في معالجة TripStatusUpdated: $e');
        }
      },
    );
    _tripChannelTokens[orderId] = token;
  }

  void unsubscribeFromTripChannel(int orderId) {
    final token = _tripChannelTokens.remove(orderId);
    if (token != null) {
      _realtimeService.removeListener(token);
      debugPrint('🔌 RideCubit: Unsubscribed from trip-$orderId');
    }
  }

  /// تحديث السعر المعدّل لرحلة معينة – يُشارَك بين كل كارتات نفس الرحلة
  void updateAmount(int orderId, double amount) {
    final updated = Map<int, double>.from(state.currentAmounts);
    updated[orderId] = amount;
    emit(state.copyWith(currentAmounts: updated));
  }

  Future<void> acceptRide(int orderId) async {
    emit(state.copyWith(
        actionStatus: RideActionStatus.loading, actionOrderId: orderId));
    var result = await acceptRideUseCase(AcceptRideParams(orderId: orderId));
    result.fold(
      (fail) => emit(state.copyWith(
          actionStatus: RideActionStatus.error,
          actionOrderId: orderId,
          message: fail.message)),
      (success) {
        Set<int> updatedPending = Set.from(state.pendingOffers);
        updatedPending.remove(orderId);

        // إعادة ترتيب بعد الحذف من الـ pending
        final sorted = _sortRides(state.rides, updatedPending);

        emit(state.copyWith(
            actionStatus: RideActionStatus.success,
            actionOrderId: orderId,
            pendingOffers: updatedPending,
            rides: sorted,
            message: "تم قبول الرحلة بنجاح"));
      },
    );
  }

  Future<void> counterOffer(int orderId, double offerRate) async {
    emit(state.copyWith(
        actionStatus: RideActionStatus.loading, actionOrderId: orderId));
    var result = await counterOfferUseCase(
        CounterOfferParams(orderId: orderId, offerRate: offerRate));
    result.fold(
      (fail) => emit(state.copyWith(
          actionStatus: RideActionStatus.error,
          actionOrderId: orderId,
          message: fail.message)),
      (success) {
        Set<int> updatedPending = Set.from(state.pendingOffers);
        updatedPending.add(orderId);

        // أهم خطوة: إعادة ترتيب القائمة عشان اللي اتعمل عليه أوفر يطلع فوق
        final sorted = _sortRides(state.rides, updatedPending);

        // اشترك في trip-{id} عشان تعرف رد اليوزر على الأوفر
        subscribeToTripChannel(orderId);

        emit(state.copyWith(
            actionStatus: RideActionStatus.success,
            actionOrderId: orderId,
            pendingOffers: updatedPending,
            rides: sorted,
            message: "تم إرسال عرض السعر، في انتظار موافقة العميل"));
      },
    );
  }

  // حذف الرحلة تماماً من قائمة السواق ورفضها في الباك اند
  void dismissRide(int orderId) {
    rejectRideUseCase(orderId); // Fire and forget to notify backend of rejection

    unsubscribeFromTripChannel(orderId); // إلغاء الاشتراك عند الحذف
    List<NewRideData> updatedRides =
        state.rides.where((r) => r.id != orderId).toList();
    Set<int> updatedPending = Set.from(state.pendingOffers)..remove(orderId);
    Set<int> updatedNew = Set.from(state.newRideIds)..remove(orderId);
    final Map<int, double> updatedAmounts = Map.from(state.currentAmounts)
      ..remove(orderId);
    final Map<int, DateTime> updatedSeenAt = Map.from(state.newRideSeenAt)
      ..remove(orderId);

    final sorted = _sortRides(updatedRides, updatedPending);

    emit(state.copyWith(
      rides: sorted,
      pendingOffers: updatedPending,
      newRideIds: updatedNew,
      currentAmounts: updatedAmounts,
      newRideSeenAt: updatedSeenAt,
    ));
  }

  // إلغاء عرض السعر (يرجع الرحلة لأصلها)
  void cancelOffer(int orderId) {
    Set<int> updatedPending = Set.from(state.pendingOffers)..remove(orderId);

    // إعادة ترتيب عشان تنزل لمكانها الطبيعي
    final sorted = _sortRides(state.rides, updatedPending);

    emit(state.copyWith(
      pendingOffers: updatedPending,
      rides: sorted,
      actionStatus: RideActionStatus.initial,
      clearActionOrderId: true,
    ));
  }

  // Helper للترتيب: الـ Pending أولاً، ثم الباقي من الأحدث للأقدم
  List<NewRideData> _sortRides(List<NewRideData> rides, Set<int> pendingIds) {
    List<NewRideData> pending = [];
    List<NewRideData> others = [];

    for (var ride in rides) {
      if (pendingIds.contains(ride.id)) {
        pending.add(ride);
      } else {
        others.add(ride);
      }
    }

    // هنا نقدر نتحكم في ترتيب الـ others لو عندنا timestamp،
    // بس حالياً هي أصلاً مترتبة "نظرياً" حسب دخولها اللستة
    return [...pending, ...others];
  }

  @override
  Future<void> close() {
    if (_newRidesToken != null) {
      _realtimeService.removeListener(_newRidesToken!);
    }
    // إلغاء كل اشتراكات trip channels
    for (final token in _tripChannelTokens.values) {
      _realtimeService.removeListener(token);
    }
    _tripChannelTokens.clear();
    return super.close();
  }
}
