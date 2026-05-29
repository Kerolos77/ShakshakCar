import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shakshak/features/shared/rides/domain/usecases/get_rides_usecase.dart';
import 'package:shakshak/features/shared/rides/domain/entities/rides_entity.dart';

part 'rides_state.dart';

class RidesCubit extends Cubit<RidesState> {
  RidesCubit(this.getRidesUseCase) : super(RidesInitial());
  final GetSharedRidesUseCase getRidesUseCase;

  Future<void> getRides({int? inCity, bool isDriver = false}) async {
    emit(RidesLoading());
    var result = await getRidesUseCase(
        GetSharedRidesParams(inCity: inCity, isDriver: isDriver));
    result.fold((error) {
      debugPrint("error while get rides data ${error.message}");
      return emit(RidesFailure(errorMessage: error.message));
    }, (success) {
      return emit(RidesSuccess(ridesEntity: success));
    });
  }
}
