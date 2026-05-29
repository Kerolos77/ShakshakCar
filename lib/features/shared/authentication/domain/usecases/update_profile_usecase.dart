import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/profile_entity.dart';
import 'package:shakshak/features/shared/authentication/domain/repositories/auth_repo.dart';

class UpdateProfileUseCase
    extends BaseUseCase<ProfileEntity, UpdateProfileParams> {
  final AuthRepo authRepo;

  UpdateProfileUseCase(this.authRepo);

  @override
  Future<Either<Failure, ProfileEntity>> call(
      UpdateProfileParams parameters) async {
    return await authRepo.updateProfile(
      name: parameters.name,
      email: parameters.email,
      countryId: parameters.countryId,
      cityId: parameters.cityId,
      photo: parameters.photo,
    );
  }
}

class UpdateProfileParams {
  final String name;
  final String email;
  final int countryId;
  final int cityId;
  final File? photo;

  UpdateProfileParams({
    required this.name,
    required this.email,
    required this.countryId,
    required this.cityId,
    this.photo,
  });
}
