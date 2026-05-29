import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/features/shared/shop/domain/usecases/buy_package_usecase.dart';
import 'package:shakshak/features/shared/shop/domain/usecases/get_packages_usecase.dart';
import 'package:shakshak/features/shared/shop/domain/usecases/get_subscription_status_usecase.dart';
import 'package:shakshak/features/shared/shop/presentation/view_models/shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  final GetPackagesUseCase getPackagesUseCase;
  final BuyPackageUseCase buyPackageUseCase;
  final GetSubscriptionStatusUseCase getSubscriptionStatusUseCase;

  ShopCubit({
    required this.getPackagesUseCase,
    required this.buyPackageUseCase,
    required this.getSubscriptionStatusUseCase,
  }) : super(ShopInitial());

  Future<void> getSubscriptionStatus() async {
    final currentState = state;
    final result = await getSubscriptionStatusUseCase();
    result.fold(
      (failure) {
        if (currentState is ShopLoaded) {
          emit(ShopLoaded(
            packages: currentState.packages,
            userPoints: currentState.userPoints,
            userWallet: currentState.userWallet,
            activePackage: currentState.activePackage,
            subscriptionDetails: null,
          ));
        }
      },
      (response) {
        if (currentState is ShopLoaded) {
          emit(ShopLoaded(
            packages: currentState.packages,
            userPoints: response.data?.points ?? currentState.userPoints,
            userWallet: response.data?.wallet ?? currentState.userWallet,
            activePackage: response.data?.subscription?.package,
            subscriptionDetails: response.data?.subscription,
          ));
        } else {
          emit(ShopLoaded(
            packages: [],
            userPoints: response.data?.points ?? 0,
            userWallet: response.data?.wallet,
            activePackage: response.data?.subscription?.package,
            subscriptionDetails: response.data?.subscription,
          ));
        }
      },
    );
  }

  Future<void> fetchPackages({required bool isDriver}) async {
    emit(ShopLoading());
    final result = await getPackagesUseCase(isDriver: isDriver);
    result.fold(
      (failure) => emit(ShopError(message: failure.message)),
      (response) {
        emit(ShopLoaded(
          packages: response.data?.packages ?? [],
          userPoints: response.data?.points ?? 0,
          userWallet: response.data?.wallet,
          activePackage: response.data?.activePackage,
        ));
        getSubscriptionStatus();
      },
    );
  }

  Future<void> buyPackage({
    required bool isDriver,
    required int packageId,
    required String paymentMethod,
  }) async {
    final currentState = state;
    if (currentState is ShopLoaded) {
      emit(ShopBuyLoading(packageId: packageId));
      final result = await buyPackageUseCase(
        isDriver: isDriver,
        packageId: packageId,
        paymentMethod: paymentMethod,
      );
      result.fold(
        (failure) {
          emit(ShopBuyError(message: failure.message));
          emit(currentState);
        },
        (response) {
          final message = response['message'] ?? 'تم شراء الباقة بنجاح';
          emit(ShopBuySuccess(message: message));
          fetchPackages(isDriver: isDriver);
          getSubscriptionStatus();
        },
      );
    }
  }
}
