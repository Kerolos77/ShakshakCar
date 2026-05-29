import 'package:dartz/dartz.dart';
import 'package:shakshak/features/shared/rides/data/models/rides_model.dart'; // TODO: Update to RideEntity later if needed
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';
import 'package:shakshak/features/user/user_home/domain/entities/user_home_caption_entity.dart';
import 'package:shakshak/features/user/user_home/domain/entities/accept_offer_entity.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_request_body_model.dart'; // TODO: Use parameters instead and remove this dependency
import 'package:shakshak/features/user/user_home/domain/entities/price_entity.dart';
import 'package:shakshak/features/user/user_home/domain/entities/services_entity.dart';
import 'package:shakshak/core/error/failure.dart';

abstract class UserHomeRepo {
  Future<Either<Failure, NewRideDataEntity>> newRideRequest({
    required NewRideRequestBodyModel newRideRequestBodyModel,
  });

  Future<Either<Failure, UserHomeCaptionEntity>> getCaptions();

  Future<Either<Failure, ServicesEntity>> getInCityServices();

  Future<Either<Failure, ServicesEntity>> getOutCityServices();

  Future<Either<Failure, RideModel>> getRides({required int inCity});

  Future<Either<Failure, AcceptOfferEntity>> acceptOffer({
    required int offerId,
    required int driverId,
  });

  Future<Either<Failure, AcceptOfferEntity>> denyOffer({
    required int offerId,
  });

  Future<Either<Failure, AcceptOfferEntity>> cancelOrder({
    required int orderId,
  });

  Future<Either<Failure, PriceEntity>> getPrice({
    required int serviceId,
    required String origin,
    required String destination,
  });

  Future<Either<Failure, dynamic>> getNearbyDrivers({
    required double latitude,
    required double longitude,
  });

  Future<Either<Failure, NewRideDataEntity>> getRideDetails({
    required int rideId,
  });

  Future<Either<Failure, NewRideDataEntity>> getActiveRide();
}
