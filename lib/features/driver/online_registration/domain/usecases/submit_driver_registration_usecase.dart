import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/driver/online_registration/domain/entities/driver_registration_entity.dart';
import 'package:shakshak/features/driver/online_registration/domain/repositories/driver_registration_repo.dart';

class SubmitDriverRegistrationUseCase extends BaseUseCase<
    DriverRegistrationEntity, SubmitDriverRegistrationParams> {
  final DriverRegistrationRepo driverRegistrationRepo;

  SubmitDriverRegistrationUseCase(this.driverRegistrationRepo);

  @override
  Future<Either<Failure, DriverRegistrationEntity>> call(
      SubmitDriverRegistrationParams parameters) async {
    return await driverRegistrationRepo.submitDriverRegistration(
      nationalIdBirthDate: parameters.nationalIdBirthDate,
      nationalIdNumber: parameters.nationalIdNumber,
      nationalIdExpireDate: parameters.nationalIdExpireDate,
      criminalRecordImage: parameters.criminalRecordImage,
      nationalIdImage: parameters.nationalIdImage,
      licenceImage: parameters.licenceImage,
      licenceExpireDate: parameters.licenceExpireDate,
      carLicenceImage: parameters.carLicenceImage,
      carLicenceExpireDate: parameters.carLicenceExpireDate,
      carImage: parameters.carImage,
      carNumber: parameters.carNumber,
      carBrand: parameters.carBrand,
      carYear: parameters.carYear,
      carModel: parameters.carModel,
      carColor: parameters.carColor,
    );
  }
}

class SubmitDriverRegistrationParams {
  final String nationalIdBirthDate;
  final String nationalIdNumber;
  final String nationalIdExpireDate;
  final File criminalRecordImage;
  final File nationalIdImage;
  final File licenceImage;
  final String licenceExpireDate;
  final File carLicenceImage;
  final String carLicenceExpireDate;
  final File carImage;
  final String carNumber;
  final String carBrand;
  final String carYear;
  final String carModel;
  final String carColor;

  SubmitDriverRegistrationParams({
    required this.nationalIdBirthDate,
    required this.nationalIdNumber,
    required this.nationalIdExpireDate,
    required this.criminalRecordImage,
    required this.nationalIdImage,
    required this.licenceImage,
    required this.licenceExpireDate,
    required this.carLicenceImage,
    required this.carLicenceExpireDate,
    required this.carImage,
    required this.carNumber,
    required this.carBrand,
    required this.carYear,
    required this.carModel,
    required this.carColor,
  });
}
