import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/driver/store/data/models/driver_package_model.dart';

abstract class DriverStoreRepo {
  Future<Either<Failure, List<DriverPackageModel>>> getPackages();
  Future<Either<Failure, bool>> buyPackage({required int packageId, required String paymentMethod});
}
