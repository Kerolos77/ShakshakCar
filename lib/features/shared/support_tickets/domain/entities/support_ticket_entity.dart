class SupportTicketEntity {
  final String id;
  final String ticketNumber;
  final String subject;
  final String description;
  final String status; // open, in_review, resolved, closed
  final String priority; // low, medium, high, urgent
  final int? orderId;
  final String? adminNotes;
  final DateTime? resolvedAt;
  final DateTime createdAt;

  const SupportTicketEntity({
    required this.id,
    required this.ticketNumber,
    required this.subject,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.orderId,
    this.adminNotes,
    this.resolvedAt,
  });
}
