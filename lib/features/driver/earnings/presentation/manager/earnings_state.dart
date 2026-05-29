import 'package:shakshak/features/driver/earnings/data/models/earnings_summary_model.dart';
import 'package:shakshak/features/driver/earnings/data/models/earnings_trip_model.dart';

abstract class EarningsState {}

class EarningsInitial extends EarningsState {}

class EarningsLoading extends EarningsState {}

class EarningsSuccess extends EarningsState {
  final EarningsSummaryModel summary;
  final List<EarningsTripModel> history;

  EarningsSuccess({required this.summary, required this.history});
}

class EarningsError extends EarningsState {
  final String errMessage;

  EarningsError(this.errMessage);
}
