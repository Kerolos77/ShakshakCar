part of 'driver_registration_cubit.dart';

@immutable
sealed class DriverRegistrationState {}

final class DriverRegistrationInitial extends DriverRegistrationState {}

// Image storage states
final class CriminalRecordImageStoredState extends DriverRegistrationState {}

final class NationalIdImageStoredState extends DriverRegistrationState {}

final class LicenceImageStoredState extends DriverRegistrationState {}

final class CarLicenceImageStoredState extends DriverRegistrationState {}

final class CarImageStoredState extends DriverRegistrationState {}

final class NationalIdBirthDateStoredState extends DriverRegistrationState {}

final class NationalIdNumberStoredState extends DriverRegistrationState {}

final class NationalIdExpireDateStoredState extends DriverRegistrationState {}

final class LicenceExpireDateStoredState extends DriverRegistrationState {}

final class CarLicenceExpireDateStoredState extends DriverRegistrationState {}

final class CarDataStoredState extends DriverRegistrationState {}

// API states
final class DriverRegistrationLoading extends DriverRegistrationState {}

final class DriverRegistrationSuccess extends DriverRegistrationState {
  final DriverRegistrationEntity driverRegistrationEntity;

  DriverRegistrationSuccess({required this.driverRegistrationEntity});
}

final class DriverRegistrationFailure extends DriverRegistrationState {
  final String errorMessage;

  DriverRegistrationFailure({required this.errorMessage});
}

// Get Car Brands States
final class GetCarBrandsLoading extends DriverRegistrationState {}

final class GetCarBrandsSuccess extends DriverRegistrationState {
  final List<CarBrandEntity> brands;

  GetCarBrandsSuccess({required this.brands});
}

final class GetCarBrandsFailure extends DriverRegistrationState {
  final String errorMessage;

  GetCarBrandsFailure({required this.errorMessage});
}

// Get Car Models States
final class GetCarModelsLoading extends DriverRegistrationState {}

final class GetCarModelsSuccess extends DriverRegistrationState {
  final List<CarModelEntity> models;

  GetCarModelsSuccess({required this.models});
}

final class GetCarModelsFailure extends DriverRegistrationState {
  final String errorMessage;

  GetCarModelsFailure({required this.errorMessage});
}

// Data management states
final class DriverRegistrationDataClearedState
    extends DriverRegistrationState {}
