import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/features/driver/store/domain/usecases/buy_driver_package_usecase.dart';
import 'package:shakshak/features/driver/store/domain/usecases/get_driver_packages_usecase.dart';
import 'driver_store_state.dart';

class DriverStoreCubit extends Cubit<DriverStoreState> {
  DriverStoreCubit(this.getDriverPackagesUseCase, this.buyDriverPackageUseCase)
      : super(DriverStoreInitial());

  final GetDriverPackagesUseCase getDriverPackagesUseCase;
  final BuyDriverPackageUseCase buyDriverPackageUseCase;

  Future<void> fetchPackages() async {
    emit(DriverStoreLoading());
    var result = await getDriverPackagesUseCase();
    result.fold(
      (failure) => emit(DriverStoreError(message: failure.message)),
      (packages) => emit(DriverStoreLoaded(packages: packages)),
    );
  }

  Future<void> buyPackage(int packageId, String paymentMethod) async {
    // Save previous state to revert if failed, but since we emit a temporary state and then revert or refresh:
    final currentState = state;
    List<dynamic> currentPackages = [];
    if (currentState is DriverStoreLoaded) {
      currentPackages = currentState.packages;
    }

    emit(DriverStoreBuyLoading(packageId: packageId));
    
    var result = await buyDriverPackageUseCase(
        BuyDriverPackageParams(packageId: packageId, paymentMethod: paymentMethod));
        
    result.fold(
      (failure) {
        emit(DriverStoreBuyError(message: failure.message));
        if (currentPackages.isNotEmpty) {
          emit(DriverStoreLoaded(packages: currentPackages));
        }
      },
      (success) {
        emit(DriverStoreBuySuccess(message: 'package_purchased_success'));
        fetchPackages(); // refresh to update UI state if needed
      },
    );
  }
}
