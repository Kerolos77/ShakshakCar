import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/driver/store/data/models/driver_package_model.dart';
import 'package:shakshak/features/driver/store/domain/repositories/driver_store_repo.dart';

class GetDriverPackagesUseCase {
  final DriverStoreRepo _repository;

  GetDriverPackagesUseCase(this._repository);

  Future<Either<Failure, List<DriverPackageModel>>> call() async {
    return await _repository.getPackages();
  }
}
