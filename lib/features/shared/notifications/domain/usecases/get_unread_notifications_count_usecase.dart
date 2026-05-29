import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/notifications/domain/repositories/notification_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';

class GetUnreadNotificationsCountUseCase
    extends BaseUseCase<int, NoParameters> {
  final NotificationRepo notificationRepo;

  GetUnreadNotificationsCountUseCase(this.notificationRepo);

  @override
  Future<Either<Failure, int>> call(
      NoParameters parameters) async {
    try {
      final count = await notificationRepo.getUnreadCount();
      return Right(count);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
