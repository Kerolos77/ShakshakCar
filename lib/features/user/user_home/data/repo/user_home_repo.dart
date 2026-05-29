import 'package:dartz/dartz.dart';
import 'package:shakshak/features/shared/rides/data/models/rides_model.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';
import 'package:shakshak/features/user/user_home/data/models/user_home_caption_model.dart';

import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/user/user_home/data/models/accept_offer_model.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_request_body_model.dart';
import 'package:shakshak/features/user/user_home/data/models/price_model.dart';
import 'package:shakshak/features/user/user_home/data/models/services_model.dart';

abstract class UserHomeRepo {
  Future<Either<Failure, NewRideData>> newRideRequest(
      {required NewRideRequestBodyModel newRideRequestBodyModel});

  Future<Either<Failure, UserHomeCaptionModel>> getCaptions();

  Future<Either<Failure, ServicesModel>> getInCityServices();

  Future<Either<Failure, ServicesModel>> getOutCityServices();

  Future<Either<Failure, RideModel>> getRides({required int inCity});

  Future<Either<Failure, AcceptOfferModel>> acceptOffer({
    required int offerId,
    required int driverId,
  });

  Future<Either<Failure, AcceptOfferModel>> denyOffer({
    required int offerId,
  });

  Future<Either<Failure, AcceptOfferModel>> cancelOrder({
    required int orderId,
  });

  Future<Either<Failure, PriceModel>> getPrice({
    required int serviceId,
    required String origin,
    required String destination,
  });

  Future<Either<Failure, dynamic>> getNearbyDrivers({
    required double latitude,
    required double longitude,
  });
}



