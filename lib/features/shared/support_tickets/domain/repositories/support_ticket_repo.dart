import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/support_tickets/domain/entities/support_ticket_entity.dart';

abstract class SupportTicketRepo {
  Future<Either<Failure, List<SupportTicketEntity>>> getMyTickets();
  Future<Either<Failure, SupportTicketEntity>> createTicket({
    required String subject,
    required String description,
    int? orderId,
    String priority,
  });
}
