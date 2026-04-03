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

  TicketEntity copyWith({
      String? id,
      DateTime? createdAt,
      String? customerName,
      String? message,
      TicketStatus? status,
      TicketPriority? priority,
      String? category
      }) => TicketEntity(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        customerName: customerName ?? this.customerName,
        message: message ?? this.message,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        category: category ?? this.category,
  );

}


