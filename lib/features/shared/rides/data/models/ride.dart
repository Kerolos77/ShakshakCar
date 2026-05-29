import 'ride_driver.dart';
import 'ride_user.dart';

class Ride {
  Ride({
    this.id,
    this.destinationLat,
    this.destinationLong,
    this.destinationAddress,
    this.sourceLat,
    this.sourceLong,
    this.sourceAddress,
    this.amount,
    this.finalRate,
    this.distance,
    this.distanceType,
    this.status,
    this.offerdriver,
    this.isOffer,
    this.createdAt,
    this.driver,
    this.user,
    this.whenDate,
    this.interCity,
    this.userServiceId,
    this.paid,
    this.paymentType,
    this.commission,
    this.destinationCity,
    this.sourceCity,
    this.parcelDimension,
    this.parcelImage,
    this.parcelWeight,
    this.numberOfPassenger,
    this.isPlaced,
    this.isStarted,
    this.isAccept,
    this.isComplete,
    this.isCanceled,
    this.canceledBy,
    this.comment,
    this.serviceType,
    this.carBrand,
    this.carModel,
    this.carColor,
    this.carPlate,
  });

  Ride.fromJson(dynamic json) {
    id = json['id'];
    destinationLat = json['destination_lat'];
    destinationLong = json['destination_long'];
    destinationAddress = json['destination_address'];
    sourceLat = json['source_lat'];
    sourceLong = json['source_long'];
    sourceAddress = json['source_address'];
    amount = json['amount'];
    finalRate = json['final_rate'];
    distance = json['distance'];
    distanceType = json['distance_type'];
    status = json['status'];
    offerdriver = json['offerdriver'];
    isOffer = json['is_offer'];
    createdAt = json['created_at'];
    driver = json['driver'] is Map<String, dynamic>
        ? RideDriver.fromJson(json['driver'])
        : null;
    user = json['user'] != null ? RideUser.fromJson(json['user']) : null;
    whenDate = json['when_date'];
    interCity = json['inter_city'];
    userServiceId = json['user_service_id'];
    paid = json['paid'];
    paymentType = json['payment_type'];
    commission = json['commission'];
    destinationCity = json['destination_City'];
    sourceCity = json['source_city'];
    parcelDimension = json['parcel_dimension'];
    parcelImage = json['parcel_image'];
    parcelWeight = json['parcel_weight'];
    numberOfPassenger = json['number_of_passenger'];
    isPlaced = json['is_placed'];
    isStarted = json['is_started'];
    isAccept = json['is_accept'];
    isComplete = json['is_complete'];
    isCanceled = json['is_canceled'];
    canceledBy = json['canceled_by'];
    comment = json['comment'];
    serviceType = json['service_type'];
    carBrand = json['car_brand'];
    carModel = json['car_model'];
    carColor = json['car_color'];
    carPlate = json['car_plate'];
  }

  int? id;
  String? destinationLat;
  String? destinationLong;
  String? destinationAddress;
  String? sourceLat;
  String? sourceLong;
  String? sourceAddress;
  String? amount;
  String? finalRate;
  String? distance;
  String? distanceType;
  String? status;
  String? offerdriver;
  String? isOffer;
  String? createdAt;
  RideDriver? driver;
  RideUser? user;
  String? whenDate;
  int? interCity;
  String? userServiceId;
  int? paid;
  String? paymentType;
  String? commission;
  String? destinationCity;
  String? sourceCity;
  String? parcelDimension;
  String? parcelImage;
  String? parcelWeight;
  dynamic numberOfPassenger;
  String? isPlaced;
  String? isStarted;
  String? isAccept;
  String? isComplete;
  String? isCanceled;
  dynamic canceledBy;
  String? comment;
  String? serviceType;
  String? carBrand;
  String? carModel;
  String? carColor;
  String? carPlate;
}
