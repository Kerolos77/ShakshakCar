import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/support_tickets/domain/entities/support_ticket_entity.dart';
import 'package:shakshak/features/shared/support_tickets/domain/repositories/support_ticket_repo.dart';

class CreateTicketUseCase {
  final SupportTicketRepo repo;
  CreateTicketUseCase(this.repo);

  Future<Either<Failure, SupportTicketEntity>> call({
    required String subject,
    required String description,
    int? orderId,
    String priority = 'medium',
  }) {
    return repo.createTicket(
      subject: subject,
      description: description,
      orderId: orderId,
      priority: priority,
    );
  }
}
