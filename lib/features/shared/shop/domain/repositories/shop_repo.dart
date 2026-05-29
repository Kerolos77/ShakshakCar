import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/shop/data/models/package_model.dart';
import 'package:shakshak/features/shared/shop/data/models/subscription_status_model.dart';

abstract class ShopRepo {
  Future<Either<Failure, ShopResponseModel>> getPackages({required bool isDriver});
  Future<Either<Failure, Map<String, dynamic>>> buyPackage({
    required bool isDriver,
    required int packageId,
    required String paymentMethod,
  });
  Future<Either<Failure, SubscriptionStatusModel>> getSubscriptionStatus();
}
