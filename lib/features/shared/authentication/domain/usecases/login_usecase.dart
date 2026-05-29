import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/login_entity.dart';
import 'package:shakshak/features/shared/authentication/domain/repositories/auth_repo.dart';

class LoginUseCase extends BaseUseCase<LoginEntity, LoginParams> {
  final AuthRepo authRepo;

  LoginUseCase(this.authRepo);

  @override
  Future<Either<Failure, LoginEntity>> call(LoginParams parameters) async {
    return await authRepo.login(phone: parameters.phone);
  }
}

class LoginParams {
  final String phone;

  LoginParams({required this.phone});
}
