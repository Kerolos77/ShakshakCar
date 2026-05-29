import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/entities/user_home_caption_entity.dart';
import 'package:shakshak/features/user/user_home/domain/repositories/user_home_repo.dart';

class GetCaptionsUseCase
    extends BaseUseCase<UserHomeCaptionEntity, NoParameters> {
  final UserHomeRepo userHomeRepo;

  GetCaptionsUseCase(this.userHomeRepo);

  @override
  Future<Either<Failure, UserHomeCaptionEntity>> call(
      NoParameters parameters) async {
    return await userHomeRepo.getCaptions();
  }
}
