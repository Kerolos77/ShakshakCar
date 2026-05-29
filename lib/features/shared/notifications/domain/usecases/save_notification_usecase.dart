import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/entities/notification_entity.dart';
import 'package:shakshak/features/shared/notifications/domain/repositories/notification_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';

class SaveNotificationUseCase extends BaseUseCase<void, NotificationEntity> {
  final NotificationRepo notificationRepo;

  SaveNotificationUseCase(this.notificationRepo);

  @override
  Future<Either<Failure, void>> call(NotificationEntity parameters) async {
    try {
      await notificationRepo.saveNotification(parameters);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
