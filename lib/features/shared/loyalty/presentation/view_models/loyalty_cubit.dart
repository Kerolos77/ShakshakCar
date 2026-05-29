import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/features/shared/loyalty/data/repo/loyalty_repo.dart';
import 'package:shakshak/features/shared/loyalty/presentation/view_models/loyalty_state.dart';

class LoyaltyCubit extends Cubit<LoyaltyState> {
  final LoyaltyRepo loyaltyRepo;

  LoyaltyCubit(this.loyaltyRepo) : super(LoyaltyInitial());

  Future<void> getPointsHistory() async {
    emit(LoyaltyLoading());
    var result = await loyaltyRepo.getPointsHistory();
    result.fold(
      (failure) => emit(LoyaltyError(failure.message)),
      (response) => emit(LoyaltySuccess(response)),
    );
  }
}
