import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/driver/online_registration/domain/entities/car_brand_entity.dart';
import 'package:shakshak/features/driver/online_registration/domain/entities/car_model_entity.dart';
import 'package:shakshak/features/driver/online_registration/domain/entities/driver_registration_entity.dart';

abstract class DriverRegistrationRepo {
  Future<Either<Failure, DriverRegistrationEntity>> submitDriverRegistration({
    required String nationalIdBirthDate,
    required String nationalIdNumber,
    required String nationalIdExpireDate,
    required File criminalRecordImage,
    required File nationalIdImage,
    required File licenceImage,
    required String licenceExpireDate,
    required File carLicenceImage,
    required String carLicenceExpireDate,
    required File carImage,
    required String carNumber,
    required String carBrand,
    required String carYear,
    required String carModel,
    required String carColor,
  });

  Future<Either<Failure, List<CarBrandEntity>>> getCarBrands();

  Future<Either<Failure, List<CarModelEntity>>> getCarModels(
      {required int brandId});
}
