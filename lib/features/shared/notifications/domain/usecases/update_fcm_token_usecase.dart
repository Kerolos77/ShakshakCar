import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/repositories/notification_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';

class UpdateFcmTokenUseCase extends BaseUseCase<void, String> {
  final NotificationRepo notificationRepo;

  UpdateFcmTokenUseCase(this.notificationRepo);

  @override
  Future<Either<Failure, void>> call(String token) async {
    try {
      await notificationRepo.updateFcmToken(token);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
