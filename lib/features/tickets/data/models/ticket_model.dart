import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_priority.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_status.dart';

import '../../domain/entities/ticket_entity.dart';

final class TicketModel extends TicketEntity {
  TicketModel({
    required super.id,
    required super.createdAt,
    required super.customerName,
    required super.message,
    required super.status,
    required super.priority,
    required super.category
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'customerName': customerName,
      'message': message,
      'status': status.name,
      'priority': priority.name,
      'category': category,
    };
  }

  factory TicketModel.fromJson(Map<dynamic, dynamic> map) {
    return TicketModel(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      customerName: map['customerName'] as String,
      message: map['message'] as String,
      status: TicketStatus.fromString(map['status']),
      priority: TicketPriority.fromString(map['priority']),
      category: map['category'] as String,
    );
  }

}

extension TicketModelMapper on TicketModel {
  TicketEntity toEntity() {
    return TicketEntity(
      id: id,
      createdAt: createdAt,
      customerName: customerName,
      message: message,
      status: status,
      priority: priority,
      category: category,
    );
  }
}