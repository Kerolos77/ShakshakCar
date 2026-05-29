import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/entities/notification_entity.dart';
import 'package:shakshak/features/shared/notifications/domain/repositories/notification_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';

class GetNotificationsParams {
  final int page;
  const GetNotificationsParams({required this.page});
}

class GetNotificationsUseCase
    extends BaseUseCase<PaginatedNotificationEntity, GetNotificationsParams> {
  final NotificationRepo notificationRepo;

  GetNotificationsUseCase(this.notificationRepo);

  @override
  Future<Either<Failure, PaginatedNotificationEntity>> call(
      GetNotificationsParams parameters) async {
    try {
      final notifications = await notificationRepo.getNotifications(page: parameters.page);
      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
