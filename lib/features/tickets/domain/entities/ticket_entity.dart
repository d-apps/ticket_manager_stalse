import '../enums/ticket_priority.dart';
import '../enums/ticket_status.dart';

class TicketEntity {
  final String id;
  final DateTime createdAt;
  final String customerName;
  final String message;
  final TicketStatus status;
  final TicketPriority priority;
  final String category;

  const TicketEntity({
    required this.id,
    required this.createdAt,
    required this.customerName,
    required this.message,
    required this.status,
    required this.priority,
    required this.category,
  });
}


