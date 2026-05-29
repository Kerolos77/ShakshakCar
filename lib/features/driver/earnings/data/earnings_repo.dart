import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import 'models/earnings_summary_model.dart';
import 'models/earnings_trip_model.dart';

abstract class EarningsRepo {
  Future<Either<Failure, EarningsSummaryModel>> getSummary(
      {required String period, String? startDate, String? endDate});

  Future<Either<Failure, List<EarningsTripModel>>> getHistory(
      {required String period, String? startDate, String? endDate});
}
