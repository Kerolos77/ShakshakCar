import 'package:shakshak/features/user/user_home/domain/entities/new_ride_user_entity.dart';

class OfferEntity {
  final int id;
  final double driverOffer;
  final String carColor;
  final String carNumber;
  final String carBrand;
  final String carModel;
  final String? driverName;
  final String driverImage;
  final String phoneNumber;
  final String senderType; // 'driver' or 'user'
  final String status; // 'pending', 'user_denied', 'accepted', etc.
  final String? userCounterOffer;

  OfferEntity({
    required this.id,
    required this.driverOffer,
    required this.carColor,
    required this.carNumber,
    required this.carBrand,
    required this.carModel,
    this.driverName,
    required this.driverImage,
    required this.phoneNumber,
    required this.senderType,
    required this.status,
    this.userCounterOffer,
  });
}

class PaymentDetailsEntity {
  final String type;
  final double totalAmount;
  final double walletPaid;
  final double cardPaid;
  final double cashPaid;
  final bool isEscrow;
  final String paymentStatus;

  PaymentDetailsEntity({
    required this.type,
    required this.totalAmount,
    required this.walletPaid,
    required this.cardPaid,
    required this.cashPaid,
    required this.isEscrow,
    required this.paymentStatus,
  });
}

class NewRideDataEntity {
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
  final NewRideUserEntity user;
  final DateTime? whenDate;
  final bool interCity;
  final int userServiceId;
  final bool paid;
  final String paymentType;
  final int numberOfPassenger;
  final String serviceType;
  final int reviewsCount;
  final bool hasReview;
  final NewRideUserEntity? driver;
  final String? carBrand;
  final String? carModel;
  final String? carColor;
  final String? carPlate;
  final String? parcelDimension;
  final String? parcelImage;
  final String? parcelWeight;
  final String? offerdriver;
  final String? commission;
  final PaymentDetailsEntity? paymentDetails;
  final List<OfferEntity> offers;
  final String? pickupOtp;
  final String? deliveryOtp;

  NewRideDataEntity({
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
}
