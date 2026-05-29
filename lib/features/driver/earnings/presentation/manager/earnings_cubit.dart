import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/features/driver/earnings/data/earnings_repo.dart';
import 'earnings_state.dart';

class EarningsCubit extends Cubit<EarningsState> {
  final EarningsRepo earningsRepo;
  EarningsCubit(this.earningsRepo) : super(EarningsInitial());

  String currentPeriod = 'today';

  Future<void> fetchEarnings({String? period}) async {
    if (period != null) currentPeriod = period;
    
    emit(EarningsLoading());

    final summaryResult = await earningsRepo.getSummary(period: currentPeriod);
    final historyResult = await earningsRepo.getHistory(period: currentPeriod);

    summaryResult.fold(
      (failure) => emit(EarningsError(failure.message)),
      (summary) {
        historyResult.fold(
          (failure) => emit(EarningsError(failure.message)),
          (history) => emit(EarningsSuccess(summary: summary, history: history)),
        );
      },
    );
  }
}
