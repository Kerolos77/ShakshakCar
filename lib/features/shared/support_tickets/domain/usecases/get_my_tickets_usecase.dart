import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/support_tickets/domain/entities/support_ticket_entity.dart';
import 'package:shakshak/features/shared/support_tickets/domain/repositories/support_ticket_repo.dart';

class GetMyTicketsUseCase {
  final SupportTicketRepo repo;
  GetMyTicketsUseCase(this.repo);

  Future<Either<Failure, List<SupportTicketEntity>>> call() {
    return repo.getMyTickets();
  }
}
