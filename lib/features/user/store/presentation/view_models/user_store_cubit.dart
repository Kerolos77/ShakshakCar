import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/features/user/store/domain/repositories/user_store_repo.dart';
import 'package:shakshak/features/driver/store/presentation/view_models/driver_store_state.dart';

class UserStoreCubit extends Cubit<DriverStoreState> {
  UserStoreCubit(this.userStoreRepo) : super(DriverStoreInitial());

  final UserStoreRepo userStoreRepo;

  Future<void> fetchPackages() async {
    emit(DriverStoreLoading());
    var result = await userStoreRepo.getPackages();
    result.fold(
      (failure) => emit(DriverStoreError(message: failure.message)),
      (packages) => emit(DriverStoreLoaded(packages: packages)),
    );
  }

  Future<void> buyPackage(int packageId, String paymentMethod) async {
    final currentState = state;
    List<dynamic> currentPackages = [];
    if (currentState is DriverStoreLoaded) {
      currentPackages = currentState.packages;
    }

    emit(DriverStoreBuyLoading(packageId: packageId));
    
    var result = await userStoreRepo.buyPackage(
        packageId: packageId, paymentMethod: paymentMethod);
        
    result.fold(
      (failure) {
        emit(DriverStoreBuyError(message: failure.message));
        if (currentPackages.isNotEmpty) {
          emit(DriverStoreLoaded(packages: currentPackages));
        }
      },
      (success) {
        emit(DriverStoreBuySuccess(message: 'تم شراء الباقة بنجاح'));
        fetchPackages();
      },
    );
  }
}
