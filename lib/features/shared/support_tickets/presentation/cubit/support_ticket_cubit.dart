import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/features/shared/support_tickets/domain/usecases/create_ticket_usecase.dart';
import 'package:shakshak/features/shared/support_tickets/domain/usecases/get_my_tickets_usecase.dart';
import 'package:shakshak/features/shared/support_tickets/presentation/cubit/support_ticket_state.dart';

class SupportTicketCubit extends Cubit<SupportTicketState> {
  final GetMyTicketsUseCase getMyTicketsUseCase;
  final CreateTicketUseCase createTicketUseCase;

  SupportTicketCubit({
    required this.getMyTicketsUseCase,
    required this.createTicketUseCase,
  }) : super(SupportTicketInitial());

  Future<void> fetchMyTickets() async {
    emit(SupportTicketLoading());
    final result = await getMyTicketsUseCase();
    result.fold(
      (failure) => emit(SupportTicketError(failure.message)),
      (tickets) => emit(MyTicketsLoaded(tickets)),
    );
  }

  Future<void> createTicket({
    required String subject,
    required String description,
    int? orderId,
    String priority = 'medium',
  }) async {
    emit(SupportTicketLoading());
    final result = await createTicketUseCase(
      subject: subject,
      description: description,
      orderId: orderId,
      priority: priority,
    );
    result.fold(
      (failure) => emit(SupportTicketError(failure.message)),
      (ticket) => emit(TicketCreatedSuccess(ticket)),
    );
  }
}
