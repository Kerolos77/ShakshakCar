import 'package:shakshak/features/shared/support_tickets/domain/entities/support_ticket_entity.dart';

abstract class SupportTicketState {}

class SupportTicketInitial extends SupportTicketState {}

class SupportTicketLoading extends SupportTicketState {}

class MyTicketsLoaded extends SupportTicketState {
  final List<SupportTicketEntity> tickets;
  MyTicketsLoaded(this.tickets);
}

class TicketCreatedSuccess extends SupportTicketState {
  final SupportTicketEntity ticket;
  TicketCreatedSuccess(this.ticket);
}

class SupportTicketError extends SupportTicketState {
  final String message;
  SupportTicketError(this.message);
}
