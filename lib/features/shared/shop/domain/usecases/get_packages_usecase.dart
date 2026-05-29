import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/shop/data/models/package_model.dart';
import 'package:shakshak/features/shared/shop/domain/repositories/shop_repo.dart';

class GetPackagesUseCase {
  final ShopRepo repository;

  GetPackagesUseCase(this.repository);

  Future<Either<Failure, ShopResponseModel>> call({required bool isDriver}) {
    return repository.getPackages(isDriver: isDriver);
  }
}
