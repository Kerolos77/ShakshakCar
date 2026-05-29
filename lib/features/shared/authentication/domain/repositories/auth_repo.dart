import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/city_entity.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/country_entity.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/login_entity.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/profile_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, ProfileEntity>> signup({
    required String userName,
    required String email,
    required String phoneNumber,
    required String countryCode,
    required String referralCode,
    required String gender,
  });

  Future<Either<Failure, LoginEntity>> login({required String phone});

  Future<Either<Failure, CountryEntity>> getCountries();

  Future<Either<Failure, CityEntity>> getCities({
    required int countryId,
  });

  Future<Either<Failure, ProfileEntity>> verifyPhoneOtp({required String otp});

  Future<Either<Failure, ProfileEntity>> getProfile();

  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String name,
    required String email,
    required int countryId,
    required int cityId,
    File? photo,
  });
}
