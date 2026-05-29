class ApiConstant {
  static const String baseUrl = 'https://shakshak.net/api/v1/';
  static const String realTimeBaseUrl =
      'wss://shakshak.net:443/app/key?protocol=7&client=js&version=4.3.1&flash=false';

  // local

  // static const String baseIp = '192.168.1.4'; //http://192.168.1.107:8000
  // static const String baseUrl = 'http://$baseIp:8000/api/v1/';
  // static const String realTimeBaseUrl =
  //     'ws://$baseIp:6001/app/key?protocol=7&client=js&version=4.3.1&flash=false';

  // auth
  static const String getCountriesUrl = 'user/country';
  static const String getCitiesUrl = 'user/city';
  static const String signupUrl = 'auth/signup';

  static const String loginUrl = 'auth/send_otp';
  static const String verifyOtpUrl = 'login';

  static const String testDriverToken =
      "202|T3V78WjSbmTXhuUHKM6lAuA91VF4u3vAM8r8dkxpc2e41459";
  static const String sendOTP = 'auth/send_otp';
  static const String verifyOTP = 'auth/verify_otp';
  static const String orderOldForDriver = 'order/old-for-driver';

  static const String getProfileUrl = 'user/profile';
  static const String updateProfileUrl = 'user/profile/update';

  // wallet & points
  static const String getWalletTransactionsUrl = 'user/transactions';
  static const String chargeWalletUrl = 'user/charge_wallet';
  static const String withdrawRequestUrl = 'user/withdraw_request';
  static const String pointsHistoryUrl = 'user/points/history';

  // rides
  static const String getUserRidesUrl = 'order/old-for-user';

  //faqs
  static const String getFaqsUrl = 'faqs';

  //contact us
  static const String getContactUsUrl = 'contact-us';
  static const String writeUsUrl = 'write_us';

  //contact us
  static const String getStaticPagesUrl = 'pages';

  //user home
  static const String getCaptionsUrl = 'captions';
  static const String getInCityServicesUrl = 'services/incity';
  static const String getOutCityServicesUrl = 'services/outcity';

  //driver registration
  static const String driverRegistrationUrl = 'driver/registration';
  static const String driverToggleOnlineUrl = 'user/toggle_online';
  static const String carBrandsUrl = 'car/brands';
  static const String carModelsUrl = 'car/models';

  // driver earnings
  static const String driverEarningsSummaryUrl = 'driver/earnings/summary';
  static const String driverEarningsHistoryUrl = 'driver/earnings/history';
  
  // driver actions
  static const String driverSetDestinationUrl = 'driver/set-destination';
  // packages (shop)
  static const String packagesUrl = 'packages';
  static const String buyPackageUrl = 'packages/buy';
  static const String subscriptionStatusUrl = 'packages/status';

  // chat
  static const String sendMessageUrl = 'send/chat';

  // offer
  static const String acceptOfferUrl = 'order/offer';
  static const String percentageIncreaseUrl = 'settings/percentage-increase';
  static const String driverAcceptUserPriceUrl =
      'order/offer/driver-accept-user-price';
  static const String driverCounterOfferUrl = 'order/offer/driver-counter';
  static const String cancelOrderUrl = 'order/cancel';
  static const String rejectOrderUrl = 'order/reject';

  // order

  static const String getPrice = 'order/getprice';

  // review
  static const String reviewUrl = 'review';
  static const String userReviewUrl = 'review/user';
  static const String orderNewUrl = 'order/new';
  static const String getActiveRideUrl = 'order/get-user-active-ride';
  static String getOrderDetailsUrl(int id) => 'order/show/$id';

  // location
  static const String locationUpdateUrl = 'location/update';
  static const String nearbyDriversUrl = 'location/nearby';
  static const String demandMapUrl = 'location/demand-map';
  static String getDriverLocationUrl(int driverId) => 'location/$driverId';
  static const String favoriteLocationsUrl = 'user/favorite-locations';
  static const String suggestedPlacesUrl = 'order/suggested-places';

  // paymob saved cards
  static const String savedCardsUrl = 'paymob/saved-cards';
  static const String addCardUrl = 'paymob/add-card';
  static const String payWithSavedCardUrl = 'paymob/pay-with-saved-card';
  static const String chargeWalletPaymobUrl = 'paymob/charge-wallet';

  // fcm
  static const String fcmTokenUrl = 'notifications/fcm-token';
  static const String notificationsUrl = 'notifications';
  static const String unreadNotificationsCountUrl =
      'notifications/unread-count';
  static const String markAllNotificationsReadUrl = 'notifications/read-all';
  static const String resolvePaymentUrl = 'order'; // used as order/$id/resolve-payment

  static String markNotificationReadUrl(String id) => 'notifications/$id/read';
}
