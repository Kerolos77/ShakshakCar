import 'package:dartz/dartz.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/driver/new_rides/domain/entities/negotiation_settings_entity.dart';

abstract class NewRideRepo {
  /// Fetches the list of new rides.
  ///
  /// Returns a list of rides or throws an exception if the fetch fails.
  Future<Either<Failure, List<NewRideData>>> fetchNewRides();

  /// Accepts a ride request with the original price.
  Future<Either<Failure, bool>> acceptRide(int orderId);

  /// Sends a counter offer for a ride request.
  Future<Either<Failure, bool>> counterOffer(int orderId, double offerRate);

  /// Fetches the dynamic negotiation settings (e.g percentage increase logic).
  Future<Either<Failure, NegotiationSettingsEntity>> fetchNegotiationSettings();

  /// Rejects a ride request.
  Future<Either<Failure, bool>> rejectRide(int orderId);
}
