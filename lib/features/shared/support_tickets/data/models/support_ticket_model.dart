import 'package:shakshak/features/shared/support_tickets/domain/entities/support_ticket_entity.dart';

class SupportTicketModel extends SupportTicketEntity {
  const SupportTicketModel({
    required super.id,
    required super.ticketNumber,
    required super.subject,
    required super.description,
    required super.status,
    required super.priority,
    required super.createdAt,
    super.orderId,
    super.adminNotes,
    super.resolvedAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['id']?.toString() ?? '',
      ticketNumber: json['ticket_number']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? 'open',
      priority: json['priority']?.toString() ?? 'medium',
      orderId: json['order_id'] != null
          ? int.tryParse(json['order_id'].toString())
          : null,
      adminNotes: json['admin_notes']?.toString(),
      resolvedAt: json['resolved_at'] != null
          ? DateTime.tryParse(json['resolved_at'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_number': ticketNumber,
      'subject': subject,
      'description': description,
      'status': status,
      'priority': priority,
      'order_id': orderId,
      'admin_notes': adminNotes,
      'resolved_at': resolvedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
