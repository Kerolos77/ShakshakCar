import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/profile_entity.dart';
import 'package:shakshak/features/shared/authentication/domain/repositories/auth_repo.dart';

class SignupUseCase extends BaseUseCase<ProfileEntity, SignupParams> {
  final AuthRepo authRepo;

  SignupUseCase(this.authRepo);

  @override
  Future<Either<Failure, ProfileEntity>> call(SignupParams parameters) async {
    return await authRepo.signup(
      userName: parameters.userName,
      email: parameters.email,
      phoneNumber: parameters.phoneNumber,
      countryCode: parameters.countryCode,
      referralCode: parameters.referralCode,
      gender: parameters.gender,
    );
  }
}

class SignupParams {
  final String userName;
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String referralCode;
  final String gender;

  SignupParams({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    required this.referralCode,
    required this.gender,
  });
}
