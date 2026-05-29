import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/driver/store/domain/repositories/driver_store_repo.dart';

class BuyDriverPackageParams {
  final int packageId;
  final String paymentMethod;

  BuyDriverPackageParams({required this.packageId, required this.paymentMethod});
}

class BuyDriverPackageUseCase {
  final DriverStoreRepo _repository;

  BuyDriverPackageUseCase(this._repository);

  Future<Either<Failure, bool>> call(BuyDriverPackageParams params) async {
    return await _repository.buyPackage(
      packageId: params.packageId,
      paymentMethod: params.paymentMethod,
    );
  }
}
