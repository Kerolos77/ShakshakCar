import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/profile_entity.dart';
import 'package:shakshak/features/shared/authentication/domain/repositories/auth_repo.dart';

class VerifyPhoneOtpUseCase
    extends BaseUseCase<ProfileEntity, VerifyPhoneOtpParams> {
  final AuthRepo authRepo;

  VerifyPhoneOtpUseCase(this.authRepo);

  @override
  Future<Either<Failure, ProfileEntity>> call(
      VerifyPhoneOtpParams parameters) async {
    return await authRepo.verifyPhoneOtp(otp: parameters.otp);
  }
}

class VerifyPhoneOtpParams {
  final String otp;

  VerifyPhoneOtpParams({required this.otp});
}
