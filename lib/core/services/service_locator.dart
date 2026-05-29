import 'package:get_it/get_it.dart';
import 'package:shakshak/features/shared/wallet/domain/repositories/wallet_repo.dart';
import 'package:shakshak/features/shared/wallet/domain/usecases/get_wallet_transactions_usecase.dart';
import 'package:shakshak/features/shared/wallet/domain/usecases/charge_wallet_usecase.dart';
import 'package:shakshak/features/shared/wallet/domain/usecases/withdraw_request_usecase.dart';
import 'package:shakshak/core/services/real_time/realtime_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shakshak/core/services/location_service.dart';
import 'package:shakshak/core/services/notification_service.dart';
import 'package:shakshak/core/network/network_info/network_cubit.dart';
import 'package:shakshak/features/shared/authentication/domain/repositories/auth_repo.dart';

import 'package:shakshak/features/shared/authentication/data/repo/auth_repo_imp.dart';
import 'package:shakshak/features/shared/authentication/domain/usecases/login_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/usecases/signup_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/usecases/verify_phone_otp_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/usecases/get_profile_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/usecases/update_profile_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/usecases/get_countries_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/usecases/get_cities_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/accept_offer_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/cancel_order_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/deny_offer_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/get_captions_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/get_in_city_services_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/get_nearby_drivers_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/get_out_city_services_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/get_price_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/get_rides_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/new_ride_request_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/get_ride_details_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/get_active_ride_usecase.dart';
import 'package:shakshak/features/shared/chat/domain/repositories/chat_repo.dart';
import 'package:shakshak/features/shared/chat/data/repo/chat_repo_imp.dart';
import 'package:shakshak/features/shared/chat/domain/usecases/send_message_usecase.dart';
import 'package:shakshak/features/shared/contact_us/domain/repositories/contact_us_repo.dart';
import 'package:shakshak/features/shared/contact_us/data/repo/contact_us_repo_imp.dart';
import 'package:shakshak/features/shared/contact_us/domain/usecases/get_contact_us_usecase.dart';
import 'package:shakshak/features/shared/contact_us/domain/usecases/write_us_usecase.dart';
import 'package:shakshak/features/driver/home/domain/repositories/driver_home_repo.dart';
import 'package:shakshak/features/driver/home/data/repo/driver_home_repo_imp.dart';
import 'package:shakshak/features/driver/home/domain/usecases/driver_toggle_online_usecase.dart';
import 'package:shakshak/features/driver/home/domain/usecases/get_demand_map_usecase.dart';
import 'package:shakshak/features/driver/home/domain/usecases/set_driver_destination_usecase.dart';
import 'package:shakshak/features/driver/store/data/repo/driver_store_repo_imp.dart';
import 'package:shakshak/features/driver/store/domain/repositories/driver_store_repo.dart';
import 'package:shakshak/features/driver/store/domain/usecases/buy_driver_package_usecase.dart';
import 'package:shakshak/features/driver/store/domain/usecases/get_driver_packages_usecase.dart';
import 'package:shakshak/features/driver/store/presentation/view_models/driver_store_cubit.dart';
import 'package:shakshak/features/driver/new_rides/domain/repositories/new_ride_repo.dart';
import 'package:shakshak/features/driver/new_rides/domain/usecases/fetch_new_rides_usecase.dart';
import 'package:shakshak/features/driver/new_rides/domain/usecases/accept_ride_usecase.dart';
import 'package:shakshak/features/driver/new_rides/domain/usecases/counter_offer_usecase.dart';
import 'package:shakshak/features/driver/new_rides/domain/usecases/fetch_negotiation_settings_usecase.dart';
import 'package:shakshak/features/driver/new_rides/domain/usecases/reject_ride_usecase.dart';
import 'package:shakshak/features/driver/new_rides/data/repo/new_ride_repo_imp.dart';
import 'package:shakshak/features/driver/online_registration/domain/repositories/driver_registration_repo.dart';
import 'package:shakshak/features/user/saved_places/domain/usecases/update_saved_place_usecase.dart';
import 'package:shakshak/features/driver/online_registration/data/repo/driver_registration_repo_imp.dart';
import 'package:shakshak/features/driver/online_registration/domain/usecases/submit_driver_registration_usecase.dart';
import 'package:shakshak/features/driver/online_registration/domain/usecases/get_car_brands_usecase.dart';
import 'package:shakshak/features/driver/online_registration/domain/usecases/get_car_models_usecase.dart';
import 'package:shakshak/features/driver/online_registration/presentation/view_models/driver_registration_cubit.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_cubit.dart';
import 'package:shakshak/features/shared/faq/data/repo/faqs_repo_imp.dart';
import 'package:shakshak/features/shared/faq/domain/repositories/faqs_repo.dart';
import 'package:shakshak/features/shared/faq/domain/usecases/get_faqs_usecase.dart';
import 'package:shakshak/features/shared/rides/domain/repositories/rides_repo.dart';
import 'package:shakshak/features/shared/rides/data/repo/rides_repo_imp.dart';
import 'package:shakshak/features/shared/rides/domain/usecases/get_rides_usecase.dart';
import 'package:shakshak/features/shared/static_pages/data/repo/static_pages_repo_imp.dart';
import 'package:shakshak/features/shared/static_pages/domain/repositories/static_pages_repo.dart';
import 'package:shakshak/features/shared/static_pages/domain/usecases/get_static_pages_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/repositories/user_home_repo.dart';
import 'package:shakshak/features/user/user_home/data/repo/user_home_repo_imp.dart';
import 'package:shakshak/features/shared/wallet/data/repo/wallet_repo_imp.dart';
import 'package:shakshak/features/shared/payment/domain/repositories/payment_repo.dart';
import 'package:shakshak/features/shared/payment/data/repo/payment_repo_imp.dart';
import 'package:shakshak/features/shared/payment/domain/repositories/saved_cards_repo.dart';
import 'package:shakshak/features/shared/payment/data/repo/saved_cards_repo_imp.dart';
import 'package:shakshak/features/shared/payment/domain/usecases/get_add_card_intent_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/usecases/saved_cards_usecases.dart';
import 'package:shakshak/features/shared/payment/domain/usecases/get_saved_cards_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/usecases/pay_with_saved_card_wallet_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/usecases/charge_wallet_new_card_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/usecases/delete_card_usecase.dart';
import 'package:shakshak/features/user/saved_places/domain/repositories/saved_places_repo.dart';
import 'package:shakshak/features/user/saved_places/data/repo/saved_places_repo_imp.dart';
import 'package:shakshak/features/user/saved_places/domain/usecases/get_saved_places_usecase.dart';
import 'package:shakshak/features/user/saved_places/domain/usecases/add_saved_place_usecase.dart';
import 'package:shakshak/features/user/saved_places/domain/usecases/remove_saved_place_usecase.dart';
import 'package:shakshak/features/user/saved_places/domain/usecases/get_suggested_place_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/repositories/notification_repo.dart';
import 'package:shakshak/features/shared/notifications/data/repo/notification_repo_imp.dart';
import 'package:shakshak/features/shared/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/usecases/save_notification_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/usecases/update_fcm_token_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/usecases/get_unread_notifications_count_usecase.dart';
import 'package:shakshak/features/shared/notifications/presentation/manager/notification_cubit.dart';
import 'package:shakshak/features/shared/review/domain/repositories/review_repo.dart';
import 'package:shakshak/features/shared/review/domain/usecases/submit_review_usecase.dart';
import 'package:shakshak/features/shared/review/domain/usecases/get_user_reviews_usecase.dart';

import 'package:shakshak/features/shared/review/data/repo/review_repo_imp.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/country_city_cubit/countries_cities_cubit.dart';
import 'package:shakshak/features/driver/earnings/presentation/manager/earnings_cubit.dart';
import 'package:shakshak/features/shared/loyalty/data/repo/loyalty_repo.dart';
import 'package:shakshak/features/shared/loyalty/data/repo/loyalty_repo_imp.dart';
import 'package:shakshak/features/shared/loyalty/presentation/view_models/loyalty_cubit.dart';
import 'package:shakshak/features/user/store/data/repo/user_store_repo_imp.dart';
import 'package:shakshak/features/user/store/domain/repositories/user_store_repo.dart';
import 'package:shakshak/features/user/store/presentation/view_models/user_store_cubit.dart';
import 'package:shakshak/features/driver/earnings/data/earnings_repo.dart';
import 'package:shakshak/features/driver/earnings/data/earnings_repo_impl.dart';
import 'package:shakshak/features/shared/shop/data/repo/shop_repo_imp.dart';
import 'package:shakshak/features/shared/shop/domain/repositories/shop_repo.dart';
import 'package:shakshak/features/shared/shop/domain/usecases/buy_package_usecase.dart';
import 'package:shakshak/features/shared/shop/domain/usecases/get_packages_usecase.dart';
import 'package:shakshak/features/shared/shop/domain/usecases/get_subscription_status_usecase.dart';
import 'package:shakshak/features/shared/shop/presentation/view_models/shop_cubit.dart';

final sl = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {
    await _initSharedPref();
    sl.registerLazySingleton<AuthRepo>(
      () => AuthRepoImp(),
    );
    sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
    sl.registerLazySingleton<SignupUseCase>(() => SignupUseCase(sl()));
    sl.registerLazySingleton<VerifyPhoneOtpUseCase>(
        () => VerifyPhoneOtpUseCase(sl()));
    sl.registerLazySingleton<GetProfileUseCase>(() => GetProfileUseCase(sl()));
    sl.registerLazySingleton<UpdateProfileUseCase>(
        () => UpdateProfileUseCase(sl()));
    sl.registerLazySingleton<GetCountriesUseCase>(
        () => GetCountriesUseCase(sl()));
    sl.registerLazySingleton<GetCitiesUseCase>(() => GetCitiesUseCase(sl()));

    // User Home UseCases
    sl.registerLazySingleton<AcceptOfferUseCase>(
        () => AcceptOfferUseCase(sl()));
    sl.registerLazySingleton<CancelOrderUseCase>(
        () => CancelOrderUseCase(sl()));
    sl.registerLazySingleton<DenyOfferUseCase>(() => DenyOfferUseCase(sl()));
    sl.registerLazySingleton<GetCaptionsUseCase>(
        () => GetCaptionsUseCase(sl()));
    sl.registerLazySingleton<GetInCityServicesUseCase>(
        () => GetInCityServicesUseCase(sl()));
    sl.registerLazySingleton<GetNearbyDriversUseCase>(
        () => GetNearbyDriversUseCase(sl()));
    sl.registerLazySingleton<GetOutCityServicesUseCase>(
        () => GetOutCityServicesUseCase(sl()));
    sl.registerLazySingleton<GetPriceUseCase>(() => GetPriceUseCase(sl()));
    sl.registerLazySingleton<GetRidesUseCase>(() => GetRidesUseCase(sl()));
    sl.registerLazySingleton<NewRideRequestUseCase>(
        () => NewRideRequestUseCase(sl()));
    sl.registerLazySingleton<GetRideDetailsUseCase>(
        () => GetRideDetailsUseCase(sl()));
    sl.registerLazySingleton<GetUserActiveRideUseCase>(
        () => GetUserActiveRideUseCase(sl()));

    sl.registerSingleton<NewRideRepo>(
      NewRideRepoImp(),
    );
    sl.registerLazySingleton<FetchNewRidesUseCase>(
      () => FetchNewRidesUseCase(sl()),
    );
    sl.registerLazySingleton<AcceptRideUseCase>(
      () => AcceptRideUseCase(sl()),
    );
    sl.registerLazySingleton<CounterOfferUseCase>(
      () => CounterOfferUseCase(sl()),
    );
    sl.registerLazySingleton<FetchNegotiationSettingsUseCase>(
      () => FetchNegotiationSettingsUseCase(sl()),
    );
    sl.registerLazySingleton<RejectRideUseCase>(
      () => RejectRideUseCase(sl()),
    );
    sl.registerLazySingleton<RideCubit>(
      () => RideCubit(
        sl<FetchNewRidesUseCase>(),
        sl<AcceptRideUseCase>(),
        sl<CounterOfferUseCase>(),
        sl<FetchNegotiationSettingsUseCase>(),
        sl<RejectRideUseCase>(),
        sl<GetDemandMapUseCase>(),
      ),
    );
    sl.registerLazySingleton<RidesRepo>(
      () => RidesRepoImp(),
    );
    sl.registerLazySingleton<GetSharedRidesUseCase>(
      () => GetSharedRidesUseCase(sl()),
    );
    sl.registerLazySingleton<WalletRepo>(
      () => WalletRepoImp(),
    );
    sl.registerLazySingleton<GetWalletTransactionsUseCase>(
      () => GetWalletTransactionsUseCase(sl()),
    );
    sl.registerLazySingleton<ChargeWalletUseCase>(
      () => ChargeWalletUseCase(sl()),
    );
    sl.registerLazySingleton<WithdrawRequestUseCase>(
      () => WithdrawRequestUseCase(sl()),
    );
    sl.registerLazySingleton<PaymentRepo>(
      () => PaymentRepoImp(),
    );
    sl.registerLazySingleton<SavedCardsRepo>(
      () => SavedCardsRepoImp(),
    );
    sl.registerLazySingleton<GetSavedCardsUseCase>(
      () => GetSavedCardsUseCase(sl()),
    );
    sl.registerLazySingleton<FetchSavedCardsUseCase>(
      () => FetchSavedCardsUseCase(sl()),
    );
    sl.registerLazySingleton<PayWithSavedCardUseCase>(
      () => PayWithSavedCardUseCase(sl()),
    );
    sl.registerLazySingleton<PayWithSavedCardWalletUseCase>(
      () => PayWithSavedCardWalletUseCase(sl()),
    );
    sl.registerLazySingleton<ChargeWalletNewCardUseCase>(
      () => ChargeWalletNewCardUseCase(sl()),
    );
    sl.registerLazySingleton<GetAddCardIntentUseCase>(
      () => GetAddCardIntentUseCase(sl()),
    );
    sl.registerLazySingleton<DeleteCardUseCase>(
      () => DeleteCardUseCase(sl()),
    );
    sl.registerLazySingleton<FaqsRepo>(
      () => FaqsRepoImp(),
    );
    sl.registerLazySingleton<GetFaqsUseCase>(
      () => GetFaqsUseCase(sl()),
    );
    sl.registerLazySingleton<ContactUsRepo>(
      () => ContactUsRepoImp(),
    );
    sl.registerLazySingleton<GetContactUsUseCase>(
      () => GetContactUsUseCase(sl()),
    );
    sl.registerLazySingleton<WriteUsUseCase>(
      () => WriteUsUseCase(sl()),
    );
    sl.registerLazySingleton<StaticPagesRepo>(
      () => StaticPagesRepoImp(),
    );
    sl.registerLazySingleton<GetStaticPagesUseCase>(
      () => GetStaticPagesUseCase(sl()),
    );
    sl.registerLazySingleton<DriverRegistrationRepo>(
      () => DriverRegistrationRepoImp(),
    );
    sl.registerLazySingleton<SubmitDriverRegistrationUseCase>(
      () => SubmitDriverRegistrationUseCase(sl()),
    );
    sl.registerLazySingleton<GetCarBrandsUseCase>(
      () => GetCarBrandsUseCase(sl()),
    );
    sl.registerLazySingleton<GetCarModelsUseCase>(
      () => GetCarModelsUseCase(sl()),
    );
    sl.registerLazySingleton<ReviewRepo>(
      () => ReviewRepoImp(),
    );
    sl.registerLazySingleton<SubmitReviewUseCase>(
      () => SubmitReviewUseCase(sl()),
    );
    sl.registerLazySingleton<GetUserReviewsUseCase>(
      () => GetUserReviewsUseCase(sl()),
    );
    sl.registerSingleton<DriverRegistrationCubit>(
      DriverRegistrationCubit(
        sl<SubmitDriverRegistrationUseCase>(),
        sl<GetCarBrandsUseCase>(),
        sl<GetCarModelsUseCase>(),
      ),
    );
    sl.registerSingleton<DriverHomeRepo>(
      DriverHomeRepoImp(),
    );
    sl.registerLazySingleton<DriverToggleOnlineUseCase>(
      () => DriverToggleOnlineUseCase(sl()),
    );
    sl.registerLazySingleton<GetDemandMapUseCase>(
      () => GetDemandMapUseCase(sl()),
    );
    sl.registerLazySingleton<SetDriverDestinationUseCase>(
      () => SetDriverDestinationUseCase(sl()),
    );
    
    sl.registerSingleton<DriverStoreRepo>(
      DriverStoreRepoImp(),
    );
    sl.registerLazySingleton<GetDriverPackagesUseCase>(
      () => GetDriverPackagesUseCase(sl()),
    );
    sl.registerLazySingleton<BuyDriverPackageUseCase>(
      () => BuyDriverPackageUseCase(sl()),
    );
    sl.registerFactory<DriverStoreCubit>(
      () => DriverStoreCubit(sl(), sl()),
    );
    
    sl.registerLazySingleton<UserStoreRepo>(
      () => UserStoreRepoImp(),
    );
    sl.registerFactory<UserStoreCubit>(
      () => UserStoreCubit(sl()),
    );

    sl.registerSingleton<UserHomeRepo>(
      UserHomeRepoImp(),
    );
    sl.registerSingleton<ChatRepo>(
      ChatRepoImp(),
    );
    sl.registerLazySingleton<SendMessageUseCase>(
      () => SendMessageUseCase(sl()),
    );
    sl.registerSingleton<LocationService>(
      LocationService(),
    );
    sl.registerLazySingleton<SavedPlacesRepo>(
      () => SavedPlacesRepoImp(),
    );
    sl.registerLazySingleton<GetSavedPlacesUseCase>(
      () => GetSavedPlacesUseCase(sl()),
    );
    sl.registerLazySingleton<AddSavedPlaceUseCase>(
      () => AddSavedPlaceUseCase(sl()),
    );
    sl.registerLazySingleton<RemoveSavedPlaceUseCase>(
      () => RemoveSavedPlaceUseCase(sl()),
    );
    sl.registerLazySingleton<UpdateSavedPlaceUseCase>(
      () => UpdateSavedPlaceUseCase(sl()),
    );
    sl.registerLazySingleton<GetSuggestedPlaceUseCase>(
      () => GetSuggestedPlaceUseCase(savedPlacesRepo: sl(), ridesRepo: sl()),
    );
    sl.registerSingleton<RealtimeManager>(
      RealtimeManager(),
    );
    sl.registerSingleton<NotificationRepo>(
      NotificationRepoImp(),
    );
    sl.registerLazySingleton<GetNotificationsUseCase>(
      () => GetNotificationsUseCase(sl()),
    );
    sl.registerLazySingleton<SaveNotificationUseCase>(
      () => SaveNotificationUseCase(sl()),
    );
    sl.registerLazySingleton<MarkNotificationAsReadUseCase>(
      () => MarkNotificationAsReadUseCase(sl()),
    );
    sl.registerLazySingleton<MarkAllNotificationsAsReadUseCase>(
      () => MarkAllNotificationsAsReadUseCase(sl()),
    );
    sl.registerLazySingleton<UpdateFcmTokenUseCase>(
      () => UpdateFcmTokenUseCase(sl()),
    );
    sl.registerLazySingleton<GetUnreadNotificationsCountUseCase>(
      () => GetUnreadNotificationsCountUseCase(sl()),
    );
    sl.registerSingleton<NotificationService>(
      NotificationService(),
    );
    sl.registerLazySingleton<NotificationCubit>(
      () => NotificationCubit(
        getNotificationsUseCase: sl(),
        saveNotificationUseCase: sl(),
        markNotificationAsReadUseCase: sl(),
        markAllNotificationsAsReadUseCase: sl(),
        updateFcmTokenUseCase: sl(),
        getUnreadNotificationsCountUseCase: sl(),
      ),
    );
    sl.registerSingleton<CountriesCitiesCubit>(
      CountriesCitiesCubit(
        getCountriesUseCase: sl(),
        getCitiesUseCase: sl(),
      ),
    );
    sl.registerSingleton<NetworkCubit>(
      NetworkCubit(),
    );
    sl.registerLazySingleton<EarningsRepo>(
      () => EarningsRepoImpl(),
    );
    sl.registerFactory<EarningsCubit>(
      () => EarningsCubit(sl()),
    );
    sl.registerLazySingleton<LoyaltyRepo>(
      () => LoyaltyRepoImp(),
    );
    sl.registerFactory<LoyaltyCubit>(
      () => LoyaltyCubit(sl()),
    );

    // Shop
    sl.registerLazySingleton<ShopRepo>(() => ShopRepoImp());
    sl.registerLazySingleton<GetPackagesUseCase>(() => GetPackagesUseCase(sl()));
    sl.registerLazySingleton<BuyPackageUseCase>(() => BuyPackageUseCase(sl()));
    sl.registerLazySingleton<GetSubscriptionStatusUseCase>(() => GetSubscriptionStatusUseCase(sl()));
    sl.registerFactory<ShopCubit>(() => ShopCubit(
          getPackagesUseCase: sl(),
          buyPackageUseCase: sl(),
          getSubscriptionStatusUseCase: sl(),
        ));
  }

  Future<void> _initSharedPref() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sl.registerSingleton<SharedPreferences>(sharedPref);
  }
}
