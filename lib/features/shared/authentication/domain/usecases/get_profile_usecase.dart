import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/profile_entity.dart';
import 'package:shakshak/features/shared/authentication/domain/repositories/auth_repo.dart';

class GetProfileUseCase extends BaseUseCase<ProfileEntity, NoParameters> {
  final AuthRepo authRepo;

  GetProfileUseCase(this.authRepo);

  @override
  Future<Either<Failure, ProfileEntity>> call(NoParameters parameters) async {
    return await authRepo.getProfile();
  }
}
