import '../../features/ticket/tickets/data/models/ticket_model.dart';
import '../../features/ticket/tickets/domain/entities/ticket_entity.dart';

extension TicketEntityMapper on TicketEntity {
  TicketModel toModel() {
    return TicketModel(
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
