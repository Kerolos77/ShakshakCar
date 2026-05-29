import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/repositories/notification_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';

class MarkAllNotificationsAsReadUseCase
    extends BaseUseCase<void, NoParameters> {
  final NotificationRepo notificationRepo;

  MarkAllNotificationsAsReadUseCase(this.notificationRepo);

  @override
  Future<Either<Failure, void>> call(
      NoParameters parameters) async {
    try {
      await notificationRepo.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
