import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/driver/home/data/models/driver_toggle_online_model.dart';
import 'package:shakshak/features/driver/home/data/models/demand_map_model.dart';
import 'package:shakshak/features/driver/home/domain/entities/driver_toggle_online_entity.dart';

abstract class DriverHomeRepo {
  Future<Either<Failure, DriverToggleOnlineEntity>> driverToggleOnline(
      {required int value});

  Future<Either<Failure, DemandMapModel>> getDemandMap();

  Future<Either<Failure, bool>> driverSetDestination({
    required bool isHeadingDestination,
    double? lat,
    double? lng,
    String? address,
  });
}
