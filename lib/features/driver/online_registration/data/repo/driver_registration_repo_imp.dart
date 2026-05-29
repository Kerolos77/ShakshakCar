import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/features/driver/online_registration/data/models/driver_registration_model.dart';
import 'package:shakshak/features/driver/online_registration/data/models/car_brand_model.dart';
import 'package:shakshak/features/driver/online_registration/data/models/car_model_model.dart';
import 'package:shakshak/features/driver/online_registration/domain/repositories/driver_registration_repo.dart';
import 'package:shakshak/features/driver/online_registration/domain/entities/car_brand_entity.dart';
import 'package:shakshak/features/driver/online_registration/domain/entities/car_model_entity.dart';
import 'package:shakshak/features/driver/online_registration/domain/entities/driver_registration_entity.dart';

class DriverRegistrationRepoImp implements DriverRegistrationRepo {
  @override
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
  }) async {
    try {
      // Create form data
      FormData formData = FormData.fromMap({
        'national_id_birth_date': nationalIdBirthDate,
        'national_id_number': nationalIdNumber,
        'national_id_expiration_date': nationalIdExpireDate,
        'criminal_record': await MultipartFile.fromFile(
          criminalRecordImage.path,
          filename: 'criminal_record.jpg',
        ),
        'national_id': await MultipartFile.fromFile(
          nationalIdImage.path,
          filename: 'national_id.jpg',
        ),
        'licence': await MultipartFile.fromFile(
          licenceImage.path,
          filename: 'licence.jpg',
        ),
        'licence_expiration_date': licenceExpireDate,
        'car_licence': await MultipartFile.fromFile(
          carLicenceImage.path,
          filename: 'car_licence.jpg',
        ),
        'car_licence_expiration_date': carLicenceExpireDate,
        'car': await MultipartFile.fromFile(
          carImage.path,
          filename: 'car.jpg',
        ),
        'car_number': carNumber,
        'car_brand': carBrand,
        'brand': carBrand, // Alternative key
        'car_year': carYear,
        'year': carYear, // Alternative key
        'car_model': carModel,
        'model': carModel, // Alternative key
        'car_color': carColor,
      });

      debugPrint("ðŸ“¤ Sending Registration Data: "
          "brand: $carBrand, model: $carModel, year: $carYear, number: $carNumber");

      var data = await DioHelper.postData(
        url: ApiConstant.driverRegistrationUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
        data: formData,
      );

      return right(DriverRegistrationModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CarBrandEntity>>> getCarBrands() async {
    try {
      var data = await DioHelper.getDataWithoutToken(
        url: ApiConstant.carBrandsUrl,
      );
      debugPrint("ðŸš— Car Brands Result: ${data.data}");
      var model = CarBrandModel.fromJson(data.data);
      return right(model.data ?? []);
    } catch (e) {
      debugPrint("âŒ Car Brands Error: $e");
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CarModelEntity>>> getCarModels(
      {required int brandId}) async {
    try {
      var data = await DioHelper.getDataWithoutToken(
        url: ApiConstant.carModelsUrl,
        query: {'brand_id': brandId},
      );
      debugPrint("ðŸš— Car Models Result (brandId: $brandId): ${data.data}");
      var model = CarModelModel.fromJson(data.data);
      return right(model.data ?? []);
    } catch (e) {
      debugPrint("âŒ Car Models Error: $e");
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
