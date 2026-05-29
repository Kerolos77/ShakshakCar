import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/driver/online_registration/domain/usecases/submit_driver_registration_usecase.dart';
import 'package:shakshak/features/driver/online_registration/domain/usecases/get_car_brands_usecase.dart';
import 'package:shakshak/features/driver/online_registration/domain/usecases/get_car_models_usecase.dart';
import 'package:shakshak/features/driver/online_registration/domain/entities/car_brand_entity.dart';
import 'package:shakshak/features/driver/online_registration/domain/entities/car_model_entity.dart';
import 'package:shakshak/features/driver/online_registration/domain/entities/driver_registration_entity.dart';

part 'driver_registration_state.dart';

class DriverRegistrationCubit extends Cubit<DriverRegistrationState> {
  DriverRegistrationCubit(
    this.submitDriverRegistrationUseCase,
    this.getCarBrandsUseCase,
    this.getCarModelsUseCase,
  ) : super(DriverRegistrationInitial());

  final SubmitDriverRegistrationUseCase submitDriverRegistrationUseCase;
  final GetCarBrandsUseCase getCarBrandsUseCase;
  final GetCarModelsUseCase getCarModelsUseCase;

  // Stored images
  File? criminalRecordImage;

  // National ID Images
  File? nationalIdImage; // Front
  File? nationalIdBackImage;
  File? nationalIdSelfieImage;

  // Licence Images
  File? licenceImage; // Front
  File? licenceBackImage;
  File? licenceSelfieImage;

  // Car Licence Images
  File? carLicenceImage; // Front
  File? carLicenceBackImage;
  File? carLicenceSelfieImage;

  File? carImage;
  String? nationalIdBirthDate;
  String? nationalIdNumber;
  String? nationalIdExpireDate;
  String? licenceExpireDate;
  String? carLicenceExpireDate;

  // Stored car data
  String? carNumber;
  String? carBrand;
  String? carYear;
  String? carModel;
  String? carColor;
  int? carBrandId;
  int? carModelId;

  List<CarBrandEntity> brands = [];
  List<CarModelEntity> models = [];

  // Store criminal record image
  void storeCriminalRecordImage(File image) {
    criminalRecordImage = image;
    emit(CriminalRecordImageStoredState());
  }

  // Store national ID images
  void storeNationalIdImages({
    required File front,
    File? back,
    File? selfie,
  }) {
    nationalIdImage = front;
    if (back != null) nationalIdBackImage = back;
    if (selfie != null) nationalIdSelfieImage = selfie;
    emit(NationalIdImageStoredState());
  }

  // Store licence images
  void storeLicenceImages({
    required File front,
    File? back,
    File? selfie,
  }) {
    licenceImage = front;
    if (back != null) licenceBackImage = back;
    if (selfie != null) licenceSelfieImage = selfie;
    emit(LicenceImageStoredState());
  }

  // Store car licence images
  void storeCarLicenceImages({
    required File front,
    File? back,
    File? selfie,
  }) {
    carLicenceImage = front;
    if (back != null) carLicenceBackImage = back;
    if (selfie != null) carLicenceSelfieImage = selfie;
    emit(CarLicenceImageStoredState());
  }

  // Store car image
  void storeCarImage(File image) {
    carImage = image;
    emit(CarImageStoredState());
  }

  // Store national ID birth date
  void storeNationalIdBirthDate(String date) {
    nationalIdBirthDate = date;
    emit(NationalIdBirthDateStoredState());
  }

  // Store National ID Number
  void storeNationalIdNumber(String number) {
    nationalIdNumber = number;
    emit(NationalIdNumberStoredState());
  }

  // Store National ID Expiration Date
  void storeNationalIdExpireDate(String date) {
    nationalIdExpireDate = date;
    emit(NationalIdExpireDateStoredState());
  }

  // Store Licence Expiration Date
  void storeLicenceExpireDate(String date) {
    licenceExpireDate = date;
    emit(LicenceExpireDateStoredState());
  }

  // Store Car Licence Expiration Date
  void storeCarLicenceExpireDate(String date) {
    carLicenceExpireDate = date;
    emit(CarLicenceExpireDateStoredState());
  }

  // Store car data
  void storeCarNumber(String number) {
    carNumber = number;
    emit(CarDataStoredState());
  }

  void storeCarBrand(String brand) {
    carBrand = brand;
    emit(CarDataStoredState());
  }

  void storeCarBrandId(int id) {
    carBrandId = id;
    emit(CarDataStoredState());
  }

  void storeCarYear(String year) {
    carYear = year;
    emit(CarDataStoredState());
  }

  void storeCarModel(String model) {
    carModel = model;
    emit(CarDataStoredState());
  }

  void storeCarModelId(int id) {
    carModelId = id;
    emit(CarDataStoredState());
  }

  void storeCarColor(String color) {
    carColor = color;
    emit(CarDataStoredState());
  }

  // Check if all required data is available
  bool get isAllDataComplete {
    return criminalRecordImage != null &&
        nationalIdImage != null &&
        licenceImage != null &&
        carLicenceImage != null &&
        carImage != null &&
        nationalIdBirthDate != null &&
        nationalIdNumber != null &&
        nationalIdExpireDate != null &&
        licenceExpireDate != null &&
        carLicenceExpireDate != null &&
        carNumber != null &&
        carBrand != null &&
        carYear != null &&
        carModel != null &&
        carColor != null;
  }

  // Getter methods for accessing stored data
  File? get storedCriminalRecordImage => criminalRecordImage;

  File? get storedNationalIdImage => nationalIdImage;

  File? get storedNationalIdBackImage => nationalIdBackImage;

  File? get storedNationalIdSelfieImage => nationalIdSelfieImage;

  File? get storedLicenceImage => licenceImage;

  File? get storedLicenceBackImage => licenceBackImage;

  File? get storedLicenceSelfieImage => licenceSelfieImage;

  File? get storedCarLicenceImage => carLicenceImage;

  File? get storedCarLicenceBackImage => carLicenceBackImage;

  File? get storedCarLicenceSelfieImage => carLicenceSelfieImage;

  File? get storedCarImage => carImage;

  String? get storedNationalIdBirthDate => nationalIdBirthDate;

  String? get storedNationalIdNumber => nationalIdNumber;

  String? get storedNationalIdExpireDate => nationalIdExpireDate;

  String? get storedLicenceExpireDate => licenceExpireDate;

  String? get storedCarLicenceExpireDate => carLicenceExpireDate;

  // Getter methods for car data
  String? get storedCarNumber => carNumber;

  String? get storedCarBrand => carBrand;

  String? get storedCarYear => carYear;

  String? get storedCarModel => carModel;

  String? get storedCarColor => carColor;

  // Submit driver registration
  Future<void> submitDriverRegistration() async {
    if (!isAllDataComplete) {
      emit(DriverRegistrationFailure(
          errorMessage: 'Please complete all required fields'));
      return;
    }

    emit(DriverRegistrationLoading());

    var result = await submitDriverRegistrationUseCase(
      SubmitDriverRegistrationParams(
        nationalIdBirthDate: nationalIdBirthDate!,
        nationalIdNumber: nationalIdNumber!,
        nationalIdExpireDate: nationalIdExpireDate!,
        criminalRecordImage: criminalRecordImage!,
        nationalIdImage: nationalIdImage!,
        licenceImage: licenceImage!,
        licenceExpireDate: licenceExpireDate!,
        carLicenceImage: carLicenceImage!,
        carLicenceExpireDate: carLicenceExpireDate!,
        carImage: carImage!,
        carNumber: carNumber!,
        carBrand: carBrand!,
        carYear: carYear!,
        carModel: carModel!,
        carColor: carColor!,
      ),
    );

    result.fold((error) {
      debugPrint(
          "error while submitting driver registration ${error.toString()}");
      emit(DriverRegistrationFailure(errorMessage: error.toString()));
    }, (success) {
      emit(DriverRegistrationSuccess(driverRegistrationEntity: success));
    });
  }

  // Get car brands
  Future<void> getCarBrands() async {
    emit(GetCarBrandsLoading());
    final result = await getCarBrandsUseCase(const NoParameters());
    result.fold(
      (failure) {
        debugPrint("❌ Cubit GetCarBrands Error: $failure");
        emit(GetCarBrandsFailure(errorMessage: failure.toString()));
      },
      (success) {
        brands = success;
        debugPrint("✅ Cubit Received ${brands.length} brands");
        emit(GetCarBrandsSuccess(brands: brands));
      },
    );
  }

  // Get car models
  Future<void> getCarModels(int brandId) async {
    emit(GetCarModelsLoading());
    final result =
        await getCarModelsUseCase(GetCarModelsParams(brandId: brandId));
    result.fold(
      (failure) {
        debugPrint("❌ Cubit GetCarModels Error: $failure");
        emit(GetCarModelsFailure(errorMessage: failure.toString()));
      },
      (success) {
        models = success;
        debugPrint(
            "✅ Cubit Received ${models.length} models for brand $brandId");
        emit(GetCarModelsSuccess(models: models));
      },
    );
  }

  // Clear all stored data
  void clearAllData() {
    criminalRecordImage = null;

    nationalIdImage = null;
    nationalIdBackImage = null;
    nationalIdSelfieImage = null;

    licenceImage = null;
    licenceBackImage = null;
    licenceSelfieImage = null;

    carLicenceImage = null;
    carLicenceBackImage = null;
    carLicenceSelfieImage = null;

    carImage = null;
    nationalIdBirthDate = null;
    carNumber = null;
    carBrand = null;
    carYear = null;
    carModel = null;
    carColor = null;

    nationalIdNumber = null;
    nationalIdExpireDate = null;
    licenceExpireDate = null;
    carLicenceExpireDate = null;

    emit(DriverRegistrationDataClearedState());
  }
}
