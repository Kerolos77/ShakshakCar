import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/rides/domain/entities/rides_entity.dart';

abstract class RidesRepo {
  Future<Either<Failure, RidesEntity>> getRides({
    int? inCity,
    bool isDriver = false,
  });
}
