import 'package:shakshak/features/shared/shop/data/models/package_model.dart';
import 'package:shakshak/features/shared/shop/data/models/subscription_status_model.dart';

abstract class ShopState {}

class ShopInitial extends ShopState {}

class ShopLoading extends ShopState {}

class ShopLoaded extends ShopState {
  final List<PackageModel> packages;
  final int userPoints;
  final double? userWallet;
  final PackageModel? activePackage;
  final SubscriptionDetails? subscriptionDetails;

  ShopLoaded({
    required this.packages, 
    required this.userPoints,
    this.userWallet,
    this.activePackage,
    this.subscriptionDetails,
  });
}

class ShopError extends ShopState {
  final String message;

  ShopError({required this.message});
}

class ShopBuyLoading extends ShopState {
  final int packageId;

  ShopBuyLoading({required this.packageId});
}

class ShopBuySuccess extends ShopState {
  final String message;

  ShopBuySuccess({required this.message});
}

class ShopBuyError extends ShopState {
  final String message;

  ShopBuyError({required this.message});
}
