

abstract class ShipmentState {}

class ShipmentInitial extends ShipmentState {}

class ShipmentFormUpdated extends ShipmentState {}

class ShipmentValidationError extends ShipmentState {
  final String message;

  ShipmentValidationError({required this.message});
}
