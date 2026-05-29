import 'package:shakshak/features/shared/loyalty/data/models/points_history_model.dart';
import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';

abstract class LoyaltyRepo {
  Future<Either<Failure, PointsHistoryResponse>> getPointsHistory();
}
