import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/shop/domain/repositories/shop_repo.dart';

class BuyPackageUseCase {
  final ShopRepo repository;

  BuyPackageUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required bool isDriver,
    required int packageId,
    required String paymentMethod,
  }) {
    return repository.buyPackage(
      isDriver: isDriver,
      packageId: packageId,
      paymentMethod: paymentMethod,
    );
  }
}
