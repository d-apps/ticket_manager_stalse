import '../domain/entities/ticket_entity.dart';

abstract class TicketState {}

class TicketLoadingState extends TicketState {}

class TicketLoadedState extends TicketState {
  final List<TicketEntity> tickets;

  TicketLoadedState(this.tickets);
}

class TicketEmptyState extends TicketState {}

class TicketErrorState extends TicketState {
  final String message;

  TicketErrorState(this.message);
}