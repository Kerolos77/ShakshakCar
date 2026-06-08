import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_user.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';

class OfferModel extends OfferEntity {
  OfferModel({
    required super.id,
    required super.driverOffer,
    required super.carColor,
    required super.carNumber,
    required super.carBrand,
    required super.carModel,
    super.driverName,
    required super.driverImage,
    required super.phoneNumber,
    required super.senderType,
    required super.status,
    super.userCounterOffer,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      driverOffer:
          double.tryParse(json['driver_offer']?.toString() ?? '') ?? 0.0,
      carColor: json['car_color']?.toString() ?? '',
      carNumber: json['car_number']?.toString() ?? '',
      carBrand: json['car_brand']?.toString() ?? '',
      carModel: json['car_model']?.toString() ?? '',
      driverName: json['driver_name']?.toString(),
      driverImage: json['driver_image']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      senderType: json['sender_type']?.toString() ?? 'driver',
      status: json['status']?.toString() ?? 'pending',
      userCounterOffer: json['user_counter_offer']?.toString(),
    );
  }
}

class PaymentDetailsModel extends PaymentDetailsEntity {
  PaymentDetailsModel({
    required super.type,
    required super.totalAmount,
    required super.walletPaid,
    required super.cardPaid,
    required super.cashPaid,
    required super.isEscrow,
    required super.paymentStatus,
  });

  factory PaymentDetailsModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailsModel(
      type: json['type']?.toString() ?? '',
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '') ?? 0.0,
      walletPaid: double.tryParse(json['wallet_paid']?.toString() ?? '') ?? 0.0,
      cardPaid: double.tryParse(json['card_paid']?.toString() ?? '') ?? 0.0,
      cashPaid: double.tryParse(json['cash_paid']?.toString() ?? '') ?? 0.0,
      isEscrow: json['is_escrow'] == true || json['is_escrow'] == '1',
      paymentStatus: json['payment_status']?.toString() ?? '',
    );
  }
}

class NewRideData implements NewRideDataEntity {
  final int id;
  final double destinationLat;
  final double destinationLong;
  final String destinationAddress;
  final double sourceLat;
  final double sourceLong;
  final String sourceAddress;
  final double amount;
  final double finalRate;
  final double distance;
  final String distanceType;
  final String status;
  final bool isOffer;
  final DateTime createdAt;
  final NewRideUser user;
  final DateTime? whenDate;
  final bool interCity;
  final int userServiceId;
  final bool paid;
  final String paymentType;
  final int numberOfPassenger;
  final String serviceType;
  final int reviewsCount;
  final bool hasReview;
  final NewRideUser? driver;
  final String? carBrand;
  final String? carModel;
  final String? carColor;
  final String? carPlate;
  final String? parcelDimension;
  final String? parcelImage;
  final String? parcelWeight;
  final String? offerdriver;
  final String? commission;
  @override
  final PaymentDetailsModel? paymentDetails;
  @override
  final List<OfferModel> offers;
  @override
  final String? pickupOtp;
  @override
  final String? deliveryOtp;

  NewRideData({
    required this.id,
    required this.destinationLat,
    required this.destinationLong,
    required this.destinationAddress,
    required this.sourceLat,
    required this.sourceLong,
    required this.sourceAddress,
    required this.amount,
    required this.finalRate,
    required this.distance,
    required this.distanceType,
    required this.status,
    required this.isOffer,
    required this.createdAt,
    required this.user,
    required this.whenDate,
    required this.interCity,
    required this.userServiceId,
    required this.paid,
    required this.paymentType,
    required this.numberOfPassenger,
    required this.serviceType,
    required this.reviewsCount,
    required this.hasReview,
    this.driver,
    this.carBrand,
    this.carModel,
    this.carColor,
    this.carPlate,
    this.parcelDimension,
    this.parcelImage,
    this.parcelWeight,
    this.offerdriver,
    this.commission,
    this.paymentDetails,
    this.offers = const [],
    this.pickupOtp,
    this.deliveryOtp,
  });

  NewRideData copyWith({
    int? id,
    double? destinationLat,
    double? destinationLong,
    String? destinationAddress,
    double? sourceLat,
    double? sourceLong,
    String? sourceAddress,
    double? amount,
    double? finalRate,
    double? distance,
    String? distanceType,
    String? status,
    bool? isOffer,
    DateTime? createdAt,
    NewRideUser? user,
    DateTime? whenDate,
    bool? interCity,
    int? userServiceId,
    bool? paid,
    String? paymentType,
    int? numberOfPassenger,
    String? serviceType,
    int? reviewsCount,
    bool? hasReview,
    NewRideUser? driver,
    String? carBrand,
    String? carModel,
    String? carColor,
    String? carPlate,
    String? parcelDimension,
    String? parcelImage,
    String? parcelWeight,
    String? offerdriver,
    String? commission,
    PaymentDetailsModel? paymentDetails,
    List<OfferModel>? offers,
    String? pickupOtp,
    String? deliveryOtp,
  }) {
    return NewRideData(
      id: id ?? this.id,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLong: destinationLong ?? this.destinationLong,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      sourceLat: sourceLat ?? this.sourceLat,
      sourceLong: sourceLong ?? this.sourceLong,
      sourceAddress: sourceAddress ?? this.sourceAddress,
      amount: amount ?? this.amount,
      finalRate: finalRate ?? this.finalRate,
      distance: distance ?? this.distance,
      distanceType: distanceType ?? this.distanceType,
      status: status ?? this.status,
      isOffer: isOffer ?? this.isOffer,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
      whenDate: whenDate ?? this.whenDate,
      interCity: interCity ?? this.interCity,
      userServiceId: userServiceId ?? this.userServiceId,
      paid: paid ?? this.paid,
      paymentType: paymentType ?? this.paymentType,
      numberOfPassenger: numberOfPassenger ?? this.numberOfPassenger,
      serviceType: serviceType ?? this.serviceType,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      hasReview: hasReview ?? this.hasReview,
      driver: driver ?? this.driver,
      carBrand: carBrand ?? this.carBrand,
      carModel: carModel ?? this.carModel,
      carColor: carColor ?? this.carColor,
      carPlate: carPlate ?? this.carPlate,
      parcelDimension: parcelDimension ?? this.parcelDimension,
      parcelImage: parcelImage ?? this.parcelImage,
      parcelWeight: parcelWeight ?? this.parcelWeight,
      offerdriver: offerdriver ?? this.offerdriver,
      commission: commission ?? this.commission,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      offers: offers ?? this.offers,
      pickupOtp: pickupOtp ?? this.pickupOtp,
      deliveryOtp: deliveryOtp ?? this.deliveryOtp,
    );
  }

  NewRideData merge(NewRideDataEntity other) {
    return copyWith(
      destinationLat: other.destinationLat != 0.0 ? other.destinationLat : destinationLat,
      destinationLong: other.destinationLong != 0.0 ? other.destinationLong : destinationLong,
      destinationAddress: other.destinationAddress.isNotEmpty ? other.destinationAddress : destinationAddress,
      sourceLat: other.sourceLat != 0.0 ? other.sourceLat : sourceLat,
      sourceLong: other.sourceLong != 0.0 ? other.sourceLong : sourceLong,
      sourceAddress: other.sourceAddress.isNotEmpty ? other.sourceAddress : sourceAddress,
      amount: other.amount > 0 ? other.amount : amount,
      finalRate: other.finalRate > 0 ? other.finalRate : finalRate,
      distance: other.distance > 0 ? other.distance : distance,
      distanceType: other.distanceType.isNotEmpty ? other.distanceType : distanceType,
      status: other.status.isNotEmpty ? other.status : status,
      isOffer: other.isOffer,
      user: other.user is NewRideUser ? (other.user as NewRideUser) : user,
      whenDate: other.whenDate ?? whenDate,
      interCity: other.interCity,
      userServiceId: other.userServiceId > 0 ? other.userServiceId : userServiceId,
      paid: other.paid,
      paymentType: other.paymentType.isNotEmpty ? other.paymentType : paymentType,
      numberOfPassenger: other.numberOfPassenger > 0 ? other.numberOfPassenger : numberOfPassenger,
      serviceType: other.serviceType.isNotEmpty ? other.serviceType : serviceType,
      reviewsCount: other.reviewsCount > 0 ? other.reviewsCount : reviewsCount,
      hasReview: other.hasReview,
      driver: other.driver is NewRideUser ? (other.driver as NewRideUser) : (other.driver == null ? driver : null),
      carBrand: other.carBrand ?? carBrand,
      carModel: other.carModel ?? carModel,
      carColor: other.carColor ?? carColor,
      carPlate: other.carPlate ?? carPlate,
      parcelDimension: other.parcelDimension ?? parcelDimension,
      parcelImage: other.parcelImage ?? parcelImage,
      parcelWeight: other.parcelWeight ?? parcelWeight,
      offerdriver: other.offerdriver ?? offerdriver,
      commission: other.commission ?? commission,
      paymentDetails: other.paymentDetails is PaymentDetailsModel ? (other.paymentDetails as PaymentDetailsModel) : paymentDetails,
      offers: other.offers.isNotEmpty ? other.offers.cast<OfferModel>() : offers,
      pickupOtp: other.pickupOtp?.isNotEmpty == true ? other.pickupOtp : pickupOtp,
      deliveryOtp: other.deliveryOtp?.isNotEmpty == true ? other.deliveryOtp : deliveryOtp,
    );
  }

  /// ---------- helpers Ø¢Ù…Ù†Ø© ----------
  static String _string(dynamic v) => v?.toString() ?? '';

  static int _int(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

  static double _double(dynamic v) =>
      double.tryParse(v?.toString() ?? '') ?? 0.0;

  static bool _bool(dynamic v) => v?.toString() == '1' || v == true;

  static DateTime _dateTime(dynamic v) {
    if (v == null || v == '') return DateTime.now();
    return DateTime.tryParse(v.toString()) ?? DateTime.now();
  }

  static DateTime? _dateTimeNullable(dynamic v) {
    if (v == null || v == '') return null;
    return DateTime.tryParse(v.toString());
  }

  factory NewRideData.fromJson(dynamic json) {
    // 1. التعامل مع القوائم (في حال أرسل الـ WebSocket قائمة)
    if (json is List && json.isNotEmpty) {
      json = json[0];
    }

    // 2. التحقق من أن المدخل Map
    if (json is! Map<String, dynamic>) {
      json = <String, dynamic>{};
    }

    // 3. دعم وجود مغلف (Wrapper) مثل "data" أو "order" أو "ride"
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      json = json['data'];
    } else if (json.containsKey('order') &&
        json['order'] is Map<String, dynamic>) {
      json = json['order'];
    } else if (json.containsKey('ride') &&
        json['ride'] is Map<String, dynamic>) {
      json = json['ride'];
    }

    // 4. استخلاص بيانات المستخدم بمرونة (متداخلة أو مسطحة)
    Map<String, dynamic> userMap = {};
    if (json['user'] is Map<String, dynamic>) {
      userMap = json['user'];
    } else {
      // إذا كانت مسطحة (كما في TripOfferModel أحياناً)
      userMap = {
        'id': json['user_id'] ?? json['user-id'] ?? json['client_id'],
        'name': json['user_name'] ??
            json['userName'] ??
            json['name'] ??
            json['client_name'] ??
            json['customer_name'],
        'image': json['user_image'] ??
            json['userImage'] ??
            json['image'] ??
            json['client_image'],
        'phone': json['user_phone'] ??
            json['userPhone'] ??
            json['phone'] ??
            json['client_phone'],
      };
    }

    return NewRideData(
      id: _int(json['id']),
      destinationLat: _double(
          json['destination_lat'] ?? json['destinationLat'] ?? json['to_lat']),
      destinationLong: _double(json['destination_long'] ??
          json['destinationLong'] ??
          json['to_long']),
      destinationAddress: _string(json['destination_address'] ??
          json['destinationAddress'] ??
          json['to_address'] ??
          json['destination']),
      sourceLat:
          _double(json['source_lat'] ?? json['sourceLat'] ?? json['from_lat']),
      sourceLong: _double(
          json['source_long'] ?? json['sourceLong'] ?? json['from_long']),
      sourceAddress: _string(json['source_address'] ??
          json['sourceAddress'] ??
          json['from_address'] ??
          json['source']),
      amount: _double(json['amount'] ??
          json['offer_driver'] ??
          json['offerdriver'] ??
          json['price'] ??
          json['total_amount']),
      finalRate: _double(json['final_rate'] ??
          json['finalRate'] ??
          json['amount'] ??
          json['price']),
      distance: _double(json['distance'] ?? json['total_distance'] ?? 0.0),
      distanceType:
          _string(json['distance_type'] ?? json['distanceType'] ?? 'km'),
      status: _string(json['status']),
      isOffer: _bool(json['is_offer'] ?? json['isOffer']),
      createdAt: _dateTime(json['created_at'] ?? json['createdAt']),
      user: NewRideUser.fromJson(userMap),
      whenDate: _dateTimeNullable(json['when_date'] ?? json['whenDate']),
      interCity: _bool(json['inter_city'] ?? json['interCity']),
      userServiceId: _int(json['user_service_id'] ??
          json['userServiceId'] ??
          json['service_id']),
      paid: _bool(json['paid']),
      paymentType:
          _string(json['payment_type'] ?? json['paymentType'] ?? 'cash'),
      numberOfPassenger:
          _int(json['number_of_passenger'] ?? json['numberOfPassenger']),
      serviceType: _string(json['service_type'] ?? json['serviceType']),
      reviewsCount: _int(json['reviews_count'] ?? json['reviewsCount']),
      hasReview: json['has_review'] == true || json['hasReview'] == true,
      driver: json['driver'] is Map<String, dynamic>
          ? NewRideUser.fromJson(json['driver'])
          : (json['driver_id'] != null || json['driver_name'] != null)
              ? NewRideUser.fromJson({
                  'id': json['driver_id'] ?? 0,
                  'name': json['driver_name'] ?? '',
                  'image': json['driver_image'] ?? '',
                  'phone': json['driver_phone'] ?? '',
                  'is_driver': true,
                })
              : null,
      carBrand: json['car_brand']?.toString() ?? json['carBrand']?.toString(),
      carModel: json['car_model']?.toString() ?? json['carModel']?.toString(),
      carColor: json['car_color']?.toString() ?? json['carColor']?.toString(),
      carPlate: json['car_plate']?.toString() ??
          json['carPlate']?.toString() ??
          json['car_number']?.toString(),
      parcelDimension: json['parcel_dimension']?.toString() ??
          json['parcelDimension']?.toString(),
      parcelImage:
          json['parcel_image']?.toString() ?? json['parcelImage']?.toString(),
      parcelWeight:
          json['parcel_weight']?.toString() ?? json['parcelWeight']?.toString(),
      offerdriver:
          json['offerdriver']?.toString() ?? json['offer_driver']?.toString(),
      commission: json['commission']?.toString(),
      paymentDetails: json['payment_details'] is Map<String, dynamic>
          ? PaymentDetailsModel.fromJson(json['payment_details'])
          : null,
      offers: (json['offers'] is List)
          ? (json['offers'] as List)
              .whereType<Map<String, dynamic>>()
              .map((o) => OfferModel.fromJson(o))
              .toList()
          : const [],
      pickupOtp: _string(json['pickup_otp'] ?? json['pickupOtp']),
      deliveryOtp: _string(json['delivery_otp'] ?? json['deliveryOtp']),
    );
  }
}
