import 'package:shakshak/features/shared/loyalty/data/models/points_history_model.dart';

abstract class LoyaltyState {}

class LoyaltyInitial extends LoyaltyState {}

class LoyaltyLoading extends LoyaltyState {}

class LoyaltySuccess extends LoyaltyState {
  final PointsHistoryResponse response;
  LoyaltySuccess(this.response);
}

class LoyaltyError extends LoyaltyState {
  final String message;
  LoyaltyError(this.message);
}
